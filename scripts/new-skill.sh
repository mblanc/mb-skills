#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  cat <<EOF
Usage: $(basename "$0") <bucket> <skill-name> [options]

Buckets:
  engineering | productivity | in-progress | deprecated

Options:
  --user-invoked           Mark skill as user-invoked only (adds disable-model-invocation: true)
  --description "<text>"   Set the initial description in SKILL.md
  --with-dirs              Also create optional scripts/, references/, and assets/ directories
  -h, --help               Show this help message
EOF
}

if [ $# -lt 2 ]; then
  usage
  exit 1
fi

case "${1:-}" in
  -h|--help)
    usage
    exit 0
    ;;
esac

BUCKET="$1"
SKILL_NAME="$2"
shift 2

USER_INVOKED=false
DESCRIPTION=""
WITH_DIRS=false

while [ $# -gt 0 ]; do
  case "$1" in
    --user-invoked)
      USER_INVOKED=true
      shift
      ;;
    --description)
      if [ $# -lt 2 ]; then
        echo "error: --description requires a value" >&2
        exit 1
      fi
      DESCRIPTION="$2"
      shift 2
      ;;
    --with-dirs)
      WITH_DIRS=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option '$1'" >&2
      usage
      exit 1
      ;;
  esac
done

# Validate bucket
case "$BUCKET" in
  engineering|productivity|in-progress|deprecated) ;;
  *)
    echo "error: invalid bucket '$BUCKET'. Must be one of: engineering, productivity, in-progress, deprecated." >&2
    exit 1
    ;;
esac

# Validate skill name against https://agentskills.io/specification
# - 1-64 characters
# - lowercase alphanumeric (a-z, 0-9) and hyphens (-) only
# - must not start or end with a hyphen
# - must not contain consecutive hyphens (--)
NAME_LEN="${#SKILL_NAME}"
if [ "$NAME_LEN" -lt 1 ] || [ "$NAME_LEN" -gt 64 ]; then
  echo "error: skill name '$SKILL_NAME' must be between 1 and 64 characters (got $NAME_LEN)." >&2
  exit 1
fi

if ! [[ "$SKILL_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "error: skill name '$SKILL_NAME' violates the Agent Skills Specification." >&2
  echo "       Must contain only lowercase alphanumeric characters (a-z, 0-9) and single hyphens (-)," >&2
  echo "       and must not start or end with a hyphen or contain consecutive hyphens (--)." >&2
  exit 1
fi

SKILL_DIR="$REPO/skills/$BUCKET/$SKILL_NAME"
if [ -e "$SKILL_DIR" ]; then
  echo "error: skill directory already exists at $SKILL_DIR" >&2
  exit 1
fi

# Default descriptions
if [ -z "$DESCRIPTION" ]; then
  if [ "$USER_INVOKED" = true ]; then
    DESCRIPTION="One-line summary of what $SKILL_NAME does."
  else
    DESCRIPTION="Describe what $SKILL_NAME does. Use when the user asks for or mentions relevant tasks."
  fi
fi

# Human-readable display title (e.g., my-skill -> My Skill)
DISPLAY_NAME="$(echo "$SKILL_NAME" | tr '-' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1')"

mkdir -p "$SKILL_DIR/agents"

if [ "$WITH_DIRS" = true ]; then
  mkdir -p "$SKILL_DIR/scripts" "$SKILL_DIR/references" "$SKILL_DIR/assets"
fi

# Write SKILL.md
if [ "$USER_INVOKED" = true ]; then
  cat > "$SKILL_DIR/SKILL.md" <<EOF
---
name: $SKILL_NAME
description: $DESCRIPTION
disable-model-invocation: true
---

# $DISPLAY_NAME

Write step-by-step instructions for how the agent should execute this skill.
EOF
else
  cat > "$SKILL_DIR/SKILL.md" <<EOF
---
name: $SKILL_NAME
description: $DESCRIPTION
---

# $DISPLAY_NAME

Write instructions for how the agent should perform this skill.

## Instructions

1. First step
2. Second step

## Edge Cases

- Document common edge cases here.
EOF
fi

# Write agents/openai.yaml
if [ "$USER_INVOKED" = true ]; then
  cat > "$SKILL_DIR/agents/openai.yaml" <<EOF
interface:
  display_name: "$DISPLAY_NAME"
  short_description: "$DESCRIPTION"
policy:
  allow_implicit_invocation: false
EOF
else
  cat > "$SKILL_DIR/agents/openai.yaml" <<EOF
interface:
  display_name: "$DISPLAY_NAME"
  short_description: "$DESCRIPTION"
EOF
fi

echo "Created $SKILL_DIR/SKILL.md"
echo "Created $SKILL_DIR/agents/openai.yaml"

# If promoted bucket, also scaffold docs page and register in .claude-plugin/plugin.json
if [ "$BUCKET" = "engineering" ] || [ "$BUCKET" = "productivity" ]; then
  DOCS_FILE="$REPO/docs/$BUCKET/$SKILL_NAME.md"
  mkdir -p "$(dirname "$DOCS_FILE")"
  if [ ! -e "$DOCS_FILE" ]; then
    if [ "$USER_INVOKED" = true ]; then
      INVOCATION_LINE="You invoke this by typing \`/$SKILL_NAME\`, and the agent will not reach for it on its own."
    else
      INVOCATION_LINE="Type \`/$SKILL_NAME\`, or the agent reaches for it automatically when a task fits."
    fi
    cat > "$DOCS_FILE" <<EOF
# $SKILL_NAME

## What it does

$DESCRIPTION

## When to reach for it

- **Invocation mode.** $INVOCATION_LINE
- **Trigger boundary.** Reach for this skill when ...

## Common questions

### How does it interact with existing files?

Describe key behavior here.

## It's working if

- Describe observable signs that confirm the skill is working as intended.
EOF
    echo "Created $DOCS_FILE"
  fi

  # Register in .claude-plugin/plugin.json
  node -e '
    const fs = require("node:fs");
    const pluginPath = process.argv[1];
    const entry = process.argv[2];
    const plugin = JSON.parse(fs.readFileSync(pluginPath, "utf8"));
    if (!Array.isArray(plugin.skills)) plugin.skills = [];
    if (!plugin.skills.includes(entry)) {
      plugin.skills.push(entry);
      plugin.skills.sort();
      fs.writeFileSync(pluginPath, JSON.stringify(plugin, null, 2) + "\n");
      console.log("Registered " + entry + " in .claude-plugin/plugin.json");
    }
  ' "$REPO/.claude-plugin/plugin.json" "./skills/$BUCKET/$SKILL_NAME"
fi

echo ""
echo "Next steps:"
echo "  1. Edit skills/$BUCKET/$SKILL_NAME/SKILL.md"
if [ "$BUCKET" = "engineering" ] || [ "$BUCKET" = "productivity" ]; then
  echo "  2. Add '$SKILL_NAME' to README.md and skills/$BUCKET/README.md"
  echo "  3. Complete docs/$BUCKET/$SKILL_NAME.md"
else
  echo "  2. Add '$SKILL_NAME' to skills/$BUCKET/README.md"
fi
echo "  4. Run ./scripts/validate-skills.sh"
echo "  5. Run ./scripts/link-skills.sh to symlink locally"
