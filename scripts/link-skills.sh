#!/usr/bin/env bash
set -euo pipefail

# Links all active skills in the repository into the global skill directories
# used by each agent harness:
#   - ~/.agents/skills: Codex and other Agent Skills-compatible harnesses
#   - ~/.claude/skills: Claude Code
#   - ~/.gemini/skills: Gemini CLI
#   - ~/.gemini/config/skills: Antigravity (config)
#   - ~/.gemini/antigravity/skills: Antigravity IDE
#   - ~/.gemini/antigravity-cli/skills: Antigravity CLI
#   - ~/.copilot/skills: GitHub Copilot
#
# Each entry is a symlink into this repo, so a `git pull` or local edit keeps
# installed skills up to date. Skills in `deprecated/` are skipped.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DESTS=(
  "$HOME/.agents/skills"
  "$HOME/.claude/skills"
  "$HOME/.gemini/skills"
  "$HOME/.gemini/config/skills"
  "$HOME/.gemini/antigravity/skills"
  "$HOME/.gemini/antigravity-cli/skills"
  "$HOME/.copilot/skills"
)

names=()
srcs=()
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  names+=("$(basename "$src")")
  srcs+=("$src")
done < <(find "$REPO/skills" -name SKILL.md -not -path '*/node_modules/*' -not -path '*/deprecated/*' -print0)

if [ "${#names[@]}" -eq 0 ]; then
  echo "No active skills found under $REPO/skills (nothing to link yet)."
  echo "Create one with: ./scripts/new-skill.sh engineering <skill-name>"
  exit 0
fi

for DEST in "${DESTS[@]}"; do
  if [ -L "$DEST" ]; then
    resolved="$(readlink -f "$DEST")"
    case "$resolved" in
      "$REPO"|"$REPO"/*)
        echo "error: $DEST is a symlink into this repo ($resolved)." >&2
        echo "Remove it (rm \"$DEST\") and re-run; the script will recreate it as a real dir." >&2
        exit 1
        ;;
    esac
  fi

  mkdir -p "$DEST"

  for i in "${!names[@]}"; do
    name="${names[$i]}"
    src="${srcs[$i]}"
    target="$DEST/$name"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
      rm -rf "$target"
    fi

    ln -sfn "$src" "$target"
    echo "linked $name -> $src ($DEST)"
  done
done
