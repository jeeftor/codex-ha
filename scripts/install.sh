#!/bin/sh
set -eu

REPO="${REPO:-jeeftor/codex-ha}"
REF="${REF:-master}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"
SHARED_DIR="$CODEX_HOME/ha-assistant"
SKILLS="ha-init ha-workflow ha-integration ha-library ha-feature ha-bugfix ha-tests ha-coverage ha-pr ha-sync ha-docs"

repo_dir=""
tmp_dir=""

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

confirm_plan() {
  echo
  echo "Codex HA install plan"
  echo
  echo "Skills will be copied to:"
  for skill in $SKILLS; do
    echo "  $repo_dir/skills/$skill -> $SKILLS_DIR/$skill"
  done
  echo
  echo "Shared files will be copied to:"
  echo "  $repo_dir/references/ha-assistant/. -> $SHARED_DIR/references/"
  echo "  $repo_dir/scripts/discover_config.py -> $SHARED_DIR/scripts/discover_config.py"
  echo
  echo "Existing HA skill directories at those destinations will be replaced."

  if [ "${ASSUME_YES:-0}" = "1" ] || [ "${CI:-0}" = "1" ]; then
    echo "Proceeding because ASSUME_YES=1 or CI=1."
    return
  fi

  printf "Press Enter to continue or Ctrl-C to abort: "
  read _answer
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

confirm_plan

mkdir -p "$SKILLS_DIR" "$SHARED_DIR/references" "$SHARED_DIR/scripts"

for skill in $SKILLS; do
  rm -rf "$SKILLS_DIR/$skill"
  cp -R "$repo_dir/skills/$skill" "$SKILLS_DIR/$skill"
  echo "Installed $skill"
done

rm -rf "$SHARED_DIR/references"
mkdir -p "$SHARED_DIR/references" "$SHARED_DIR/scripts"
cp -R "$repo_dir/references/ha-assistant/." "$SHARED_DIR/references/"
cp "$repo_dir/scripts/discover_config.py" "$SHARED_DIR/scripts/discover_config.py"
chmod +x "$SHARED_DIR/scripts/discover_config.py"

echo
echo "Installed Codex HA skills into $SKILLS_DIR"
echo "Installed shared HA Assistant files into $SHARED_DIR"
echo "Restart Codex to pick up new skills."
