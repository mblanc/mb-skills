# Agent Instructions (`AGENTS.md`)

This repository contains agentic skills conforming to the [Agent Skills Specification](https://agentskills.io/specification), structured and scaffolded with inspiration from [`mattpocock/skills`](https://github.com/mattpocock/skills).

`AGENTS.md` is the single canonical steering file for this repository across all harnesses (Antigravity, Gemini CLI, Codex, Claude Code, Copilot, Cursor, OpenCode). Do not create a separate `CLAUDE.md`.

## Repository Organization

Skills are organized into bucket folders under `skills/`:

- `skills/engineering/`: daily software engineering and code work (promoted)
- `skills/productivity/`: general workflow and non-code tools (promoted)
- `skills/in-progress/`: beta skills under active iteration, excluded from plugin manifests and top-level docs until promoted
- `skills/deprecated/`: retired skills kept only for historical context or migration notes

### Promoted Buckets Invariants

Every skill in `skills/engineering/` or `skills/productivity/` (the **promoted** buckets) must have:

1. An entry in the top-level [`README.md`](./README.md) Reference section, linking the skill name to its `SKILL.md`.
2. An entry in the bucket's own `README.md` (`skills/engineering/README.md` or `skills/productivity/README.md`), grouped under **User-invoked** or **Model-invoked**.
3. An entry in [`.claude-plugin/plugin.json`](./.claude-plugin/plugin.json)'s `skills` array.
4. A human-facing documentation page at `docs/<bucket>/<skill-name>.md` following [`.agents/writing-docs.md`](./.agents/writing-docs.md).

Skills in `skills/in-progress/` and `skills/deprecated/` must **not** appear in the top-level `README.md`, `.claude-plugin/plugin.json`, or `docs/`.

## Agent Skills Specification Compliance

Every skill directory (`skills/<bucket>/<skill-name>/`) must adhere to the [Agent Skills Specification](https://agentskills.io/specification):

```text
<skill-name>/
├── SKILL.md          # Required: YAML frontmatter + Markdown instructions
├── agents/
│   └── openai.yaml   # Harness UI & invocation policy metadata
├── scripts/          # Optional: self-contained executable scripts
├── references/       # Optional: detailed reference docs loaded on demand
└── assets/           # Optional: templates, schemas, static resources
```

### `SKILL.md` Frontmatter Rules

- `name` (Required):
  - 1 to 64 characters.
  - Lowercase alphanumeric characters (`a-z`, `0-9`) and hyphens (`-`) only.
  - Must not start or end with a hyphen (`-`), and must not contain consecutive hyphens (`--`).
  - Must exactly match the parent directory name (`<skill-name>`).
- `description` (Required):
  - 1 to 1024 characters, non-empty.
  - For **model-invoked** skills: describe both what the skill does and when to use it, including trigger keywords ("Use when the user wants..., mentions..., asks for...").
  - For **user-invoked** skills: a concise human-facing one-line summary for slash-command pickers (strip model trigger lists).
- Optional spec fields:
  - `license`: short license identifier or reference to bundled license file.
  - `compatibility`: 1 to 500 characters indicating environment/tool requirements (omit unless the skill has specific prerequisites).
  - `metadata`: string-to-string key-value map for custom metadata.
  - `allowed-tools`: space-separated list of pre-approved tools (experimental).
- Harness invocation field:
  - `disable-model-invocation: true` for user-invoked skills (paired with `policy.allow_implicit_invocation: false` in `agents/openai.yaml`). See [`.agents/invocation.md`](./.agents/invocation.md).

### Progressive Disclosure & File References

- Keep `SKILL.md` under **500 lines** (< 5,000 tokens recommended).
- Move deep reference tables, templates, or specialized domain guides into `references/`, `scripts/`, or sibling markdown files and link to them using relative paths from the skill root (one level deep).

## Invocation & Cross-Skill Dependencies

Every skill is either **user-invoked** or **model-invoked**. See [`.agents/invocation.md`](./.agents/invocation.md) for the complete rules:

- **User-invoked** skills orchestrate workflows and are triggered only by the human typing `/<skill-name>`.
- **Model-invoked** skills hold reusable disciplines and can be reached by either the model or the human.
- Operative dependencies from one skill to a model-invoked skill must instruct the agent to call the Skill tool explicitly (`Call the Skill tool with "<skill-name>"`), never by relative file paths across skill directories (`../other-skill/...`).
- No skill may ever invoke a user-invoked skill; if a user-invoked skill is a prerequisite, instruct the agent to tell the user to run `/<skill-name>`.

## Tooling & Scripts

- **Scaffold a new skill**: `scripts/new-skill.sh <bucket> <skill-name> [--user-invoked] [--description "..."] [--with-dirs]`
- **Validate all skills and repo invariants**: `scripts/validate-skills.sh`
- **Link skills globally across harnesses**: `scripts/link-skills.sh` (symlinks skills outside `deprecated/` into `~/.agents/skills`, `~/.claude/skills`, `~/.gemini/skills`, `~/.gemini/config/skills`, `~/.gemini/antigravity/skills`, `~/.gemini/antigravity-cli/skills`, and `~/.copilot/skills`)
- **List all skills**: `scripts/list-skills.sh`
- **Sync plugin version with `package.json`**: `node scripts/sync-plugin-version.mjs` (or `--check` in CI)

Always run `scripts/validate-skills.sh` after creating, editing, moving, or removing a skill.
