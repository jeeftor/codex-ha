#!/bin/sh
set -eu

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"
SHARED_DIR="$CODEX_HOME/ha-assistant"
SKILLS="ha-init ha-workflow ha-integration ha-library ha-feature ha-bugfix ha-tests ha-coverage ha-pr ha-sync ha-docs"

for skill in $SKILLS; do
  rm -rf "$SKILLS_DIR/$skill"
  echo "Removed $skill"
done

rm -rf "$SHARED_DIR/references" "$SHARED_DIR/scripts"

if [ "${REMOVE_CONFIG:-0}" = "1" ]; then
  rm -rf "$SHARED_DIR"
  echo "Removed $SHARED_DIR"
else
  echo "Preserved $SHARED_DIR/config.yaml if it exists"
fi

echo
echo "Uninstalled Codex HA skills. Restart Codex to refresh the skill list."
