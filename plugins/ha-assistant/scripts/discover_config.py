#!/usr/bin/env python3
"""Discover local Home Assistant repos and write HA Assistant config."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path
from typing import Any


HOME = Path.home()
DEFAULT_ROOT = HOME / "devel" / "ha"
DEFAULT_CONFIG = HOME / ".codex" / "ha-assistant" / "config.yaml"


def run_git(repo: Path, args: list[str]) -> str:
    """Return stdout from a git command, or an empty string when it fails."""
    try:
        result = subprocess.run(
            ["git", "-C", str(repo), *args],
            check=True,
            capture_output=True,
            text=True,
        )
    except (OSError, subprocess.CalledProcessError):
        return ""
    return result.stdout.strip()


def shorten(path: Path) -> str:
    """Render a path using a home-relative prefix when possible."""
    try:
        return "~/" + str(path.resolve().relative_to(HOME))
    except ValueError:
        return str(path)


def yaml_scalar(value: str) -> str:
    """Render a conservative YAML scalar."""
    if not value:
        return '""'
    if re.search(r"[:#\n\r\t]", value):
        return json.dumps(value)
    return value


def candidate_repos(root: Path) -> list[Path]:
    """Return git repositories under the root within a shallow search depth."""
    repos: list[Path] = []
    if not root.exists():
        return repos
    for path in [root, *root.iterdir()]:
        if path.is_dir() and (path / ".git").exists():
            repos.append(path)
    return sorted(set(repos))


def remotes(repo: Path) -> str:
    """Return the configured git remotes for a repository."""
    return run_git(repo, ["remote", "-v"])


def project_name(repo: Path) -> str | None:
    """Read the Python project name from pyproject.toml when present."""
    pyproject = repo / "pyproject.toml"
    if not pyproject.exists():
        return None
    for line in pyproject.read_text(encoding="utf-8").splitlines():
        match = re.match(r'\s*name\s*=\s*["\']([^"\']+)["\']', line)
        if match:
            return match.group(1)
    return None


def requirement_name(requirement: str) -> str:
    """Extract a package name from a requirement string."""
    return re.split(r"[<>=!~;\[]", requirement, maxsplit=1)[0].strip()


def read_manifest(path: Path) -> dict[str, Any] | None:
    """Read an integration manifest file."""
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return None


def find_core_and_docs(repos: list[Path]) -> tuple[Path | None, Path | None]:
    """Identify Home Assistant Core and docs repos from git remotes."""
    core: Path | None = None
    docs: Path | None = None
    for repo in repos:
        remote_text = remotes(repo)
        if "home-assistant/core" in remote_text:
            core = repo
        if "home-assistant/home-assistant.io" in remote_text:
            docs = repo
    return core, docs


def find_library(requirement: str, repos: list[Path]) -> Path | None:
    """Find the best local backing library candidate for a requirement."""
    name = requirement_name(requirement).lower()
    for repo in repos:
        if repo.name.lower() == name:
            return repo
    for repo in repos:
        if (project_name(repo) or "").lower() == name:
            return repo
    for repo in repos:
        if name in remotes(repo).lower():
            return repo
    return None


def discover_integrations(
    core: Path | None,
    docs: Path | None,
    repos: list[Path],
    github: str | None,
) -> dict[str, dict[str, Any]]:
    """Discover maintained integrations and their backing libraries."""
    if core is None:
        return {}
    components = core / "homeassistant" / "components"
    if not components.exists():
        return {}

    integrations: dict[str, dict[str, Any]] = {}
    owner = f"@{github}" if github else None
    for manifest_path in sorted(components.glob("*/manifest.json")):
        manifest = read_manifest(manifest_path)
        if not manifest:
            continue
        codeowners = manifest.get("codeowners", [])
        if owner and owner not in codeowners:
            continue

        domain = manifest_path.parent.name
        tests_path = core / "tests" / "components" / domain
        docs_path = docs / "source" / "_integrations" / f"{domain}.markdown" if docs else None
        entry: dict[str, Any] = {
            "core_path": shorten(manifest_path.parent),
            "tests_path": shorten(tests_path),
        }
        if docs_path and docs_path.exists():
            entry["docs_path"] = shorten(docs_path)

        libraries: list[dict[str, str]] = []
        for requirement in manifest.get("requirements", []):
            lib_path = find_library(requirement, repos)
            lib_entry = {
                "name": requirement_name(requirement),
                "requirement": requirement,
            }
            if lib_path:
                lib_entry["path"] = shorten(lib_path)
            libraries.append(lib_entry)
        if libraries:
            entry["backing_libraries"] = libraries
        integrations[domain] = entry
    return integrations


def write_config(path: Path, data: dict[str, Any]) -> None:
    """Write the HA Assistant config file."""
    lines = [
        f"repos_root: {yaml_scalar(data['repos_root'])}",
        "repos:",
        f"  core: {yaml_scalar(data['repos']['core'])}",
        f"  docs: {yaml_scalar(data['repos']['docs'])}",
        "maintainer:",
        f"  github: {yaml_scalar(data['maintainer']['github'])}",
        "integrations:",
    ]
    integrations: dict[str, dict[str, Any]] = data["integrations"]
    if not integrations:
        lines.append("  {}")
    for domain, entry in integrations.items():
        lines.append(f"  {domain}:")
        for key in ("core_path", "tests_path", "docs_path"):
            if key in entry:
                lines.append(f"    {key}: {yaml_scalar(entry[key])}")
        libraries = entry.get("backing_libraries", [])
        if libraries:
            lines.append("    backing_libraries:")
            for library in libraries:
                lines.append(f"      - name: {yaml_scalar(library['name'])}")
                lines.append(f"        requirement: {yaml_scalar(library['requirement'])}")
                if "path" in library:
                    lines.append(f"        path: {yaml_scalar(library['path'])}")

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def parse_args() -> argparse.Namespace:
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repos-root", type=Path, default=DEFAULT_ROOT)
    parser.add_argument("--config", type=Path, default=DEFAULT_CONFIG)
    parser.add_argument("--github", default="")
    return parser.parse_args()


def main() -> int:
    """Discover repos and write config."""
    args = parse_args()
    repos = candidate_repos(args.repos_root.expanduser())
    core, docs = find_core_and_docs(repos)
    integrations = discover_integrations(core, docs, repos, args.github or None)
    data = {
        "repos_root": shorten(args.repos_root.expanduser()),
        "repos": {
            "core": shorten(core) if core else "",
            "docs": shorten(docs) if docs else "",
        },
        "maintainer": {"github": args.github},
        "integrations": integrations,
    }
    write_config(args.config.expanduser(), data)
    print(f"Wrote {args.config.expanduser()}")
    print(f"Discovered {len(integrations)} integration(s)")
    if not core:
        print("Missing Home Assistant Core repo; rerun with --repos-root or edit config.")
    if not docs:
        print("Missing Home Assistant docs repo; rerun with --repos-root or edit config.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
