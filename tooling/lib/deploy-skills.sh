#!/bin/bash
# deploy-skills.sh — Deploys skill directories to a target project
# Called by: just deploy-skills <target> [skills]
set -euo pipefail

# ── Argument parsing ──────────────────────────────────────────────────────────
LIBRARY=""
TARGET=""
SKILLS="all"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --library) LIBRARY="$2"; shift 2 ;;
    --target)  TARGET="$2";  shift 2 ;;
    --skills)  SKILLS="$2";  shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

[[ -z "$LIBRARY" ]] && { echo "Error: --library required" >&2; exit 1; }
[[ -z "$TARGET"  ]] && { echo "Error: --target required" >&2; exit 1; }

SKILLS_DST="$TARGET/.claude/skills"
mkdir -p "$SKILLS_DST"

# ── Skill resolution ──────────────────────────────────────────────────────────
deploy_skill() {
  local skill_dir="$1"
  local skill_name
  skill_name=$(basename "$skill_dir")
  local dst="$SKILLS_DST/$skill_name"

  mkdir -p "$dst"
  cp -r "$skill_dir/." "$dst/"
  echo "  Deployed skill: $skill_name → .claude/skills/$skill_name"
}

# ── Main ──────────────────────────────────────────────────────────────────────
if [[ "$SKILLS" == "all" ]]; then
  echo "Deploying all skills to $TARGET..."
  while IFS= read -r skill_dir; do
    deploy_skill "$skill_dir"
  done < <(find "$LIBRARY/skills" -maxdepth 3 -name "SKILL.md" -exec dirname {} \; | sort)
else
  echo "Deploying selected skills to $TARGET..."
  IFS=',' read -ra SKILL_NAMES <<< "$SKILLS"
  for name in "${SKILL_NAMES[@]}"; do
    name=$(echo "$name" | tr -d ' ')
    skill_dir=$(find "$LIBRARY/skills" -maxdepth 2 -type d -name "$name" | head -1)
    if [[ -z "$skill_dir" ]]; then
      echo "Warning: skill '$name' not found in library — skipping" >&2
      continue
    fi
    deploy_skill "$skill_dir"
  done
fi

echo ""
echo "Skills deployed to $TARGET/.claude/skills/"
