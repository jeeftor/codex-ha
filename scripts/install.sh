#!/bin/sh
set -eu

REPO="${REPO:-jeeftor/codex-ha}"
REF="${REF:-master}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"
SHARED_DIR="$CODEX_HOME/ha-assistant"
MANIFEST="$SHARED_DIR/installed-skills.txt"
SKILLS="ha-init ha-workflow ha-integration ha-library ha-feature ha-bugfix ha-tests ha-coverage ha-quality ha-quality-audit ha-quality-improve ha-pr ha-pr-writer ha-pr-create ha-pr-update ha-copilot-review ha-pr-watcher ha-sync ha-docs"

repo_dir=""
tmp_dir=""
installed_ha_skills=""

cleanup() {
  if [ -n "$tmp_dir" ] && [ -d "$tmp_dir" ]; then
    rm -rf "$tmp_dir"
  fi
}
trap cleanup EXIT INT TERM

script_dir() {
  case "$0" in
    */*) dirname "$0" ;;
    *) pwd ;;
  esac
}

find_installed_ha_skills() {
  if [ ! -d "$SKILLS_DIR" ]; then
    return
  fi

  for path in "$SKILLS_DIR"/ha-*; do
    [ -d "$path" ] || continue
    basename "$path"
  done
}

confirm_plan() {
  echo
  echo "Codex HA install/update plan"
  echo
  echo "Skills will be copied to:"
  for skill in $SKILLS; do
    echo "  $repo_dir/skills/$skill -> $SKILLS_DIR/$skill"
  done
  echo
  echo "Existing HA skill directories will be removed before reinstall:"
  if [ -n "$installed_ha_skills" ]; then
    for skill in $installed_ha_skills; do
      echo "  $SKILLS_DIR/$skill"
    done
  else
    echo "  (none)"
  fi
  echo
  echo "Shared files will be copied to:"
  echo "  $repo_dir/references/ha-assistant/. -> $SHARED_DIR/references/"
  echo "  $repo_dir/scripts/discover_config.py -> $SHARED_DIR/scripts/discover_config.py"
  echo "  current skill manifest -> $MANIFEST"
  echo
  echo "This makes updates a clean reinstall of the current HA skills bundle."

  if [ "${ASSUME_YES:-0}" = "1" ] || [ "${CI:-0}" = "1" ]; then
    echo "Proceeding because ASSUME_YES=1 or CI=1."
    return
  fi

  if [ -n "$installed_ha_skills" ]; then
    printf "Existing HA skills are installed. Press Enter to remove and reinstall, or Ctrl-C to abort: "
  else
    printf "Press Enter to install, or Ctrl-C to abort: "
  fi
  read -r _answer
}

local_dir="$(script_dir)"
if [ -d "$local_dir/skills" ] && [ -d "$local_dir/references/ha-assistant" ]; then
  repo_dir="$local_dir"
elif [ -d "$local_dir/../skills" ] && [ -d "$local_dir/../references/ha-assistant" ]; then
  repo_dir="$(cd "$local_dir/.." && pwd)"
else
  tmp_dir="$(mktemp -d)"
  archive="$tmp_dir/codex-ha.tar.gz"
  url="https://github.com/$REPO/archive/refs/heads/$REF.tar.gz"
  echo "Downloading $url"
  curl -fsSL "$url" -o "$archive"
  tar -xzf "$archive" -C "$tmp_dir"
  repo_dir="$(find "$tmp_dir" -maxdepth 1 -type d -name 'codex-ha-*' | head -n 1)"
fi

if [ ! -d "$repo_dir/skills" ]; then
  echo "Could not find skills directory in $repo_dir" >&2
  exit 1
fi

for skill in $SKILLS; do
  if [ ! -d "$repo_dir/skills/$skill" ]; then
    echo "Missing skill: $skill" >&2
    exit 1
  fi
done

installed_ha_skills="$(find_installed_ha_skills)"

confirm_plan

mkdir -p "$SKILLS_DIR" "$SHARED_DIR/references" "$SHARED_DIR/scripts"

for skill in $installed_ha_skills; do
  rm -rf "${SKILLS_DIR:?}/$skill"
  echo "Removed existing $skill"
done

for skill in $SKILLS; do
  rm -rf "${SKILLS_DIR:?}/$skill"
  cp -R "$repo_dir/skills/$skill" "$SKILLS_DIR/$skill"
  echo "Installed $skill"
done

rm -rf "$SHARED_DIR/references"
mkdir -p "$SHARED_DIR/references" "$SHARED_DIR/scripts"
cp -R "$repo_dir/references/ha-assistant/." "$SHARED_DIR/references/"
cp "$repo_dir/scripts/discover_config.py" "$SHARED_DIR/scripts/discover_config.py"
chmod +x "$SHARED_DIR/scripts/discover_config.py"
for skill in $SKILLS; do
  printf "%s\n" "$skill"
done > "$MANIFEST"

echo
echo "Installed Codex HA skills into $SKILLS_DIR"
echo "Installed shared HA Assistant files into $SHARED_DIR"
echo "Restart Codex to pick up new skills."
