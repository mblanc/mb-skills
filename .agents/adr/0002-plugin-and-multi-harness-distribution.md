# ADR 0002: Multi-Harness Distribution and Local Symlink Workflow

## Context

Different coding agents discover and install skills through different mechanisms:
- **Plugin marketplaces** (`.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`) are supported by Claude Code, Codex, and GitHub Copilot, accepting an explicit `skills` array of promoted skill paths.
- **Local skill directories** (`~/.agents/skills`, `~/.claude/skills`, `~/.gemini/skills`, `~/.gemini/config/skills`) allow instant zero-copy updates during local authoring via symlinks.
- **CLI copy installers** (`npx skills@latest add`, `gemini skills install`) copy skill directories into a user's workspace or global config.

## Decisions

1. **Curated plugin manifest**: `.claude-plugin/plugin.json` lists only the promoted skills (`skills/engineering/*` and `skills/productivity/*`) in its `skills` array. `scripts/new-skill.sh` automatically registers new promoted skills in `plugin.json`, and `scripts/validate-skills.sh` verifies that `plugin.json` matches the promoted buckets on every check.
2. **Version synchronization via Changesets**: `package.json` and `.claude-plugin/plugin.json` share a single version number kept in sync by `scripts/sync-plugin-version.mjs` during `npm run version`.
3. **Multi-harness local symlinking**: `scripts/link-skills.sh` symlinks all active skills (`engineering/`, `productivity/`, and `in-progress/`) into `~/.agents/skills`, `~/.claude/skills`, `~/.gemini/skills`, and `~/.gemini/config/skills` so local edits take effect immediately in Antigravity, Gemini CLI, Codex, and Claude Code.
