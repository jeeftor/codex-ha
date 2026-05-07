#!/bin/sh
set -eu

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
SKILLS_DIR="$CODEX_HOME/skills"
SHARED_DIR="$CODEX_HOME/ha-assistant"
MANIFEST="$SHARED_DIR/installed-skills.txt"
SKILLS="ha-init ha-workflow ha-integration ha-library ha-feature ha-bugfix ha-tests ha-coverage ha-pr ha-pr-writer ha-pr-create ha-copilot-review ha-pr-watcher ha-sync ha-docs"
remove_skills=""

add_remove_skill() {
  case " $remove_skills " in
    *" $1 "*) return ;;
    *) remove_skills="${remove_skills}${remove_skills:+ }$1" ;;
  esac
}

load_remove_skills() {
  for skill in $SKILLS; do
    add_remove_skill "$skill"
  done

  if [ -f "$MANIFEST" ]; then
    while IFS= read -r skill; do
      [ -n "$skill" ] || continue
      case "$skill" in
        ha-*) add_remove_skill "$skill" ;;
      esac
    done < "$MANIFEST"
  fi
}

confirm_plan() {
  echo
  echo "Codex HA uninstall plan"
  echo
  echo "Skill directories will be removed:"
  for skill in $remove_skills; do
    echo "  $SKILLS_DIR/$skill"
  done
  echo
  echo "Shared files will be removed:"
  echo "  $SHARED_DIR/references"
  echo "  $SHARED_DIR/scripts"
  echo "  $MANIFEST"
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
  read -r _answer
}

load_remove_skills
confirm_plan

for skill in $remove_skills; do
  rm -rf "${SKILLS_DIR:?}/$skill"
  echo "Removed $skill"
done

rm -rf "$SHARED_DIR/references" "$SHARED_DIR/scripts" "$MANIFEST"

if [ "${REMOVE_CONFIG:-0}" = "1" ]; then
  rm -rf "$SHARED_DIR"
  echo "Removed $SHARED_DIR"
else
  echo "Preserved $SHARED_DIR/config.yaml if it exists"
fi

echo
echo "Uninstalled Codex HA skills. Restart Codex to refresh the skill list."
