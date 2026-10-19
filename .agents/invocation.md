# Model-invoked vs user-invoked

Every `SKILL.md` in this repo is a skill. The single axis that splits them is **invocation**, who can reach it:

- **User-invoked**: reachable **only by the human typing its name** (e.g. `/<skill-name>`). Set `disable-model-invocation: true` in the `SKILL.md` frontmatter and `policy.allow_implicit_invocation: false` in `agents/openai.yaml`. The `description` is **human-facing**: a concise one-line summary read by a person browsing slash commands. Strip model trigger lists ("Use when the user says...").
- **Model-invoked**: reachable by **model or user**. This is the default: omit `disable-model-invocation` from `SKILL.md` and omit the `policy` block from `agents/openai.yaml`. The `description` is **model-facing** and keeps rich trigger phrasing ("Use when the user wants..., mentions..., asks for...") so auto-invocation fires reliably. The test for whether a skill should be model-invoked: _could the model usefully reach for this autonomously?_

Each harness excludes a user-invoked skill from the model's reach in its own way, so nothing but the human can fire it: no other skill can. A user-invoked skill may invoke model-invoked skills, but it can never reach another user-invoked skill.

Every skill carries an `agents/openai.yaml` beside its `SKILL.md`:

```yaml
interface:
  display_name: "Skill Title"
  short_description: "Short UI summary"
policy:
  allow_implicit_invocation: false # Only present for user-invoked skills
```

Keep `SKILL.md` and `agents/openai.yaml` in sync: a skill is user-invoked in both or neither.

Promoted bucket `README.md`s (`skills/engineering/README.md`, `skills/productivity/README.md`) and the top-level `README.md` group entries into **User-invoked** and **Model-invoked**.

## Dependencies between skills

Express operative dependencies as an explicit instruction to **call the Skill tool** with the named skill (`Call the Skill tool with "<skill-name>"`), not deep `../other-skill/FILE.md` cross-references, and not a bare `/skill` mention left for the model to interpret.

- Most harnesses expose skill invocation as a tool or progressive loader the model activates by skill name.
- Dropping the leading `/` keeps operative instructions harness-neutral.
- Shared reference docs live inside the skill that owns them (`references/`); other skills reach that material by activating the skill that owns it, not by linking across skill folders.
- The Skill tool takes one skill per call. If a step requires two model-invoked skills, state that explicitly as two calls.
- Never instruct an agent to call the Skill tool on a **user-invoked** skill. If a user-invoked skill is a precondition, instruct the agent to ask the human to run `/<skill-name>`.
