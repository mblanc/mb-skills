# ADR 0001: Agent Skills Specification Compliance, Bucket Layout, and Single `AGENTS.md`

## Context

We want a repository of reusable, composable agentic skills that work across Antigravity, Gemini CLI, Codex, Claude Code, GitHub Copilot, Cursor, and OpenCode.

Two external references guide this repository:
1. The [Agent Skills Specification](https://agentskills.io/specification), which standardizes skill directory layout (`SKILL.md`, `scripts/`, `references/`, `assets/`), YAML frontmatter constraints (`name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`), and progressive disclosure (< 500 lines per `SKILL.md`).
2. [`mattpocock/skills`](https://github.com/mattpocock/skills), which organizes skills into promoted vs. non-promoted buckets and separates user-invoked orchestrators from model-invoked disciplines.

## Decisions

1. **Strict Agent Skills Specification compliance**: Every skill lives in its own directory containing `SKILL.md` with validated YAML frontmatter (`name` matching parent folder, `^[a-z0-9]+(-[a-z0-9]+)*$`, max 64 chars; `description` max 1024 chars) and optional `scripts/`, `references/`, and `assets/` subdirectories. `scripts/validate-skills.sh` enforces these rules automatically.
2. **Bucketed directory layout under `skills/`**:
   - `skills/engineering/` and `skills/productivity/` are **promoted** buckets shipped in `.claude-plugin/plugin.json` and documented in `docs/`.
   - `skills/in-progress/` holds beta skills linked locally via `scripts/link-skills.sh` for testing, but excluded from plugin manifests until promoted.
   - `skills/deprecated/` holds retired skills excluded from both plugin manifests and local symlinks.
3. **Single `AGENTS.md` steering file**: Rather than maintaining both `CLAUDE.md` and `AGENTS.md` (or a symlink pair), this repository maintains only `AGENTS.md` as the open cross-harness standard.
