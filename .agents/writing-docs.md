# Writing docs pages

Every promoted skill in `skills/engineering/` and `skills/productivity/` has a human-facing **docs page** at `docs/<bucket>/<skill-name>.md`. The `docs/` tree mirrors those two promoted bucket folders under `skills/`. Skills in `skills/in-progress/` and `skills/deprecated/` ship no docs page.

Most user-invoked skills are never fired automatically by the agent, so the human is the index that has to remember they exist and when to reach for them. The job of a docs page is to relieve that cognitive load: to orient a reader around one skill so they know what it does, when to reach for it, and how to tell it is working.

Create or re-sync a skill's docs page whenever a skill in `engineering/` or `productivity/` is added, renamed, moved between buckets, or has its behavior changed.

## Page structure

Follow the template below, keeping its section order. The core sections (`## What it does`, `## When to reach for it`, `## Common questions`, `## It's working if`) appear on every finished docs page; `## Prerequisites` is included only when the skill requires prior setup or tools.

```markdown
# <skill-name>

## What it does

One or two plain-language paragraphs. Lead with the skill's one-sentence job, then state the single defining constraint that makes this skill behave differently from the obvious default.

## When to reach for it

- **Invocation mode.** State whether the human types `/<skill-name>` (user-invoked) or the agent also reaches for it automatically when a task fits (model-invoked).
- **Trigger boundary.** When to reach for this skill, and which sibling skill to use instead when responsibilities are adjacent.

## Prerequisites

Optional: include only when the skill requires specific CLI tools, environment variables, or repository setup. Omit this section entirely if none apply.

## Common questions

Answer concrete questions a user hits before or during a session with this skill (e.g., how it interacts with existing files, what happens if a step fails, when to stop).

## It's working if

Observable signs during or after a session that confirm the skill is doing its job properly.
```
