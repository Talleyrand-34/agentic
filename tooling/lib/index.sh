#!/bin/bash
# index.sh — Rebuilds index/skills.json and index/fragments.json
# Called by: just index
set -euo pipefail

LIBRARY=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --library) LIBRARY="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

[[ -z "$LIBRARY" ]] && { echo "Error: --library required" >&2; exit 1; }

INDEX_DIR="$LIBRARY/index"
mkdir -p "$INDEX_DIR"
GENERATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# ── Skills index ──────────────────────────────────────────────────────────────
build_skills_index() {
  local skills_json='{"version":"1.0.0","generated_at":"'"$GENERATED_AT"'","skills":['
  local first=true

  while IFS= read -r skill_file; do
    local dir
    dir=$(dirname "$skill_file")
    local group
    group=$(basename "$(dirname "$dir")")
    local name
    name=$(basename "$dir")
    local path="${skill_file#$LIBRARY/}"

    # Extract frontmatter fields using yq (treating YAML frontmatter)
    local description
    description=$(sed -n '/^---$/,/^---$/p' "$skill_file" | grep '^description:' | sed 's/^description: *//' | tr -d '"' | head -1)
    local version
    version=$(sed -n '/^---$/,/^---$/p' "$skill_file" | grep '^version:' | sed 's/^version: *//' | tr -d '"' | head -1)
    local tags
    tags=$(sed -n '/^---$/,/^---$/p' "$skill_file" | grep -A20 '^tags:' | grep '^  - ' | sed 's/^  - //' | jq -Rsc 'split("\n") | map(select(length > 0))' 2>/dev/null || echo '[]')

    [[ "$first" == "false" ]] && skills_json+=","
    skills_json+=$(printf '{"name":"%s","group":"%s","path":"%s","description":"%s","version":"%s","tags":%s}' \
      "$name" "$group" "$path" "${description:0:120}" "${version:-0.0.0}" "${tags:-[]}")
    first=false
  done < <(find "$LIBRARY/skills" -name "SKILL.md" | sort)

  skills_json+="]}"
  echo "$skills_json" | jq . > "$INDEX_DIR/skills.json"
  echo "  Built: index/skills.json ($(find "$LIBRARY/skills" -name "SKILL.md" | wc -l | tr -d ' ') skills)"
}

# ── Fragments index ───────────────────────────────────────────────────────────
build_fragments_index() {
  local frags_json='{"version":"1.0.0","generated_at":"'"$GENERATED_AT"'","fragments":['
  local first=true

  while IFS= read -r frag_file; do
    local rel="${frag_file#$LIBRARY/agents/}"
    local group
    group=$(dirname "$rel")
    local name
    name=$(basename "$rel" .md)
    local heading
    heading=$(grep '^## ' "$frag_file" | head -1 | sed 's/^## //')
    local word_count
    word_count=$(wc -w < "$frag_file" | tr -d ' ')

    [[ "$first" == "false" ]] && frags_json+=","
    frags_json+=$(printf '{"name":"%s","group":"%s","path":"agents/%s","heading":"%s","words":%s}' \
      "$name" "$group" "$rel" "$heading" "$word_count")
    first=false
  done < <(find "$LIBRARY/agents" -name "*.md" | sort)

  frags_json+="]}"
  echo "$frags_json" | jq . > "$INDEX_DIR/fragments.json"
  echo "  Built: index/fragments.json ($(find "$LIBRARY/agents" -name "*.md" | wc -l | tr -d ' ') fragments)"
}

echo "Rebuilding indexes..."
build_skills_index
build_fragments_index
echo "Done."
