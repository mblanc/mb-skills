# mb-skills

Curated agentic skills built on the [Agent Skills Specification](https://agentskills.io/specification), structured for composability, progressive disclosure, and multi-harness compatibility.

Inspired by [`mattpocock/skills`](https://github.com/mattpocock/skills), these skills are designed to be small, easy to adapt, and composable across coding agents (Antigravity, Gemini CLI, Claude Code, Codex, GitHub Copilot, Cursor, OpenCode, and any Agent Skills-compatible harness).

## Installation

A plugin updates itself automatically. [skills.sh](https://skills.sh) or local symlinking gives you editable files or direct local links. Pick one installation method per agent harness so skills are not registered twice.

<details>
<summary><strong>Global Symlinks (Antigravity, Gemini CLI, Claude Code, Codex, Copilot)</strong></summary>

Link every active skill in this repository directly into your global agent skill directories (`~/.agents/skills`, `~/.claude/skills`, `~/.gemini/skills`, `~/.gemini/config/skills`, `~/.gemini/antigravity/skills`, `~/.gemini/antigravity-cli/skills`, `~/.copilot/skills`):

```bash
./scripts/link-skills.sh
```

Each entry is a symlink into this repository, so a `git pull` or local edit immediately updates your installed skills.

</details>

<details>
<summary><strong>Claude Code</strong></summary>

```bash
claude plugin marketplace add mblanc/mb-skills
claude plugin install mb-skills@mblanc
```

</details>

<details>
<summary><strong>Codex</strong></summary>

```bash
codex plugin marketplace add mblanc/mb-skills
codex plugin add mb-skills@mblanc
```

Updates itself at startup.

</details>

<details>
<summary><strong>GitHub Copilot</strong> (CLI and VS Code)</summary>

```bash
copilot plugin marketplace add mblanc/mb-skills
copilot plugin install mb-skills@mblanc
```

Then, once, add to `~/.copilot/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "mblanc": { "source": { "source": "github", "repo": "mblanc/mb-skills" }, "autoUpdate": true }
  }
}
```

In VS Code, run **Chat: Install Plugin From Source** and enter `https://github.com/mblanc/mb-skills`.

</details>

<details>
<summary><strong>Gemini CLI</strong> (manual updates)</summary>

```bash
gemini skills install https://github.com/mblanc/mb-skills.git --path skills/engineering
gemini skills install https://github.com/mblanc/mb-skills.git --path skills/productivity
```

Re-run both commands to update.

</details>

<details>
<summary><strong>Any other agent, or editable files</strong> (skills.sh)</summary>

```bash
npx skills@latest add mblanc/mb-skills -a <agent>  # cursor, opencode, devin, windsurf, amp, pi; omit -a to choose
```

To update, run `npx skills@latest update`, and re-run `add` to pick up new skills.

</details>

## Authoring & Managing Skills

This repository includes scaffolding and validation scripts in [`scripts/`](./scripts):

```bash
# Scaffold a new skill (creates SKILL.md, agents/openai.yaml, docs page, and updates plugin.json)
./scripts/new-skill.sh engineering my-skill --description "Describe what the skill does and when to use it."

# Scaffold a user-invoked slash command skill with optional scripts/, references/, assets/ dirs
./scripts/new-skill.sh productivity my-workflow --user-invoked --with-dirs --description "Run my workflow."

# Validate all skills against the Agent Skills Specification and repo invariants
./scripts/validate-skills.sh

# Symlink all active skills into local agent directories
./scripts/link-skills.sh

# List all skills in the repository
./scripts/list-skills.sh
```

See [`AGENTS.md`](./AGENTS.md) and [`.agents/`](./.agents) for complete authoring rules, invocation conventions, and documentation templates.

## Reference

Skills split on one axis: who can invoke them. **User-invoked** skills are reachable only when you type them (e.g. `/<skill-name>`); their job is to orchestrate. **Model-invoked** skills can be invoked by you _or_ reached for automatically by the agent when the task fits; they hold reusable discipline. A user-invoked skill may invoke model-invoked skills, but never another user-invoked one.

### Engineering

Skills for software engineering and daily code work ([`skills/engineering/`](./skills/engineering/README.md)).

**User-invoked**

_No user-invoked engineering skills yet. Run `./scripts/new-skill.sh engineering <name> --user-invoked` to add one._

**Model-invoked**

_No model-invoked engineering skills yet. Run `./scripts/new-skill.sh engineering <name>` to add one._

### Productivity

General workflow tools, not code-specific ([`skills/productivity/`](./skills/productivity/README.md)).

**User-invoked**

- **[be-more-ambitious](./skills/productivity/be-more-ambitious/SKILL.md)**: Transform a prompt or task into a more ambitious version across Altitude (outcome over task), Depth (frontier rigor, raw data, and an outside judge), and Range (cross-disciplinary methods and red-teaming), based on [Felix Rieseberg's tutorial](https://felixrieseberg.com/how-to-be-more-ambitious-a-tutorial-for-humans-with-models/).
- **[gauntlet-loop](./skills/productivity/gauntlet-loop/SKILL.md)**: Transform instructions into a Gauntlet Loop prompt with a concrete Objective, blind-comparable Reference or Metric, harsh fresh-context critic, and explicit Boundaries.

**Model-invoked**

_No model-invoked productivity skills yet. Run `./scripts/new-skill.sh productivity <name>` to add one._
