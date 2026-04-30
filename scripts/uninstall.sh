#!/bin/sh
set -eu

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"
SHARED_DIR="$CODEX_HOME/ha-assistant"
SKILLS="ha-init ha-workflow ha-integration ha-library ha-feature ha-bugfix ha-tests ha-coverage ha-pr ha-pr-writer ha-pr-watcher ha-sync ha-docs"

confirm_plan() {
  echo
  echo "Codex HA uninstall plan"
  echo
  echo "Skill directories will be removed:"
  for skill in $SKILLS; do
    echo "  $SKILLS_DIR/$skill"
  done
  echo
  echo "Shared files will be removed:"
  echo "  $SHARED_DIR/references"
  echo "  $SHARED_DIR/scripts"
  if [ "${REMOVE_CONFIG:-0}" = "1" ]; then
    echo
    echo "Generated config will also be removed:"
    echo "  $SHARED_DIR"
  else
    echo
    echo "Generated config will be preserved if present:"
    echo "  $SHARED_DIR/config.yaml"
  fi

  if [ "${ASSUME_YES:-0}" = "1" ] || [ "${CI:-0}" = "1" ]; then
    echo "Proceeding because ASSUME_YES=1 or CI=1."
    return
  fi

  printf "Press Enter to continue or Ctrl-C to abort: "
  read _answer
}

confirm_plan

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
