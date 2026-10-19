# Productivity

General workflow tools, not code-specific.

## User-invoked

Reachable only when you type them (`disable-model-invocation: true` in `SKILL.md`; `policy.allow_implicit_invocation: false` in `agents/openai.yaml`).

- **[be-more-ambitious](./be-more-ambitious/SKILL.md)**: Transform a prompt or task into a more ambitious version across Altitude, Depth, and Range.
- **[gauntlet-loop](./gauntlet-loop/SKILL.md)**: Transform instructions into a Gauntlet Loop prompt with a concrete Objective, blind-comparable Reference or Metric, harsh fresh-context critic, and explicit Boundaries.

## Model-invoked

Model- or user-reachable (rich trigger phrasing so the model can reach for them autonomously).

_None yet. Add one with `./scripts/new-skill.sh productivity <skill-name>`._
