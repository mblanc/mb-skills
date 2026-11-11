# ambition-calibrator

## What it does

Decides whether an incoming task is under-ambitious, and when triggered, rewrites and executes a **deeper, not bigger** version of the exact same task across **Altitude** (the durable outcome beyond the task), **Depth** (raw material, real professional instruments, and an independent outside judge), and **Range** (concrete procedures from adjacent disciplines rather than persona role-play).

Its defining constraint is strict scope discipline and honest verification: it skips trivial or ceiling-constrained tasks (`Ambition check: bypassed`), gates scope/cost/access increases on user confirmation before running, and verifies the result with an external check whose unedited output is shown—or explicitly marks the work `UNVERIFIED: no external judge available` instead of grading itself.

## When to reach for it

- **Invocation mode.** Type `/ambition-calibrator`, or let the agent reach for it automatically when a request fits (model-invoked).
- **Trigger boundary.** Fires when you ask to go deeper or be more ambitious (*"go deeper"*, *"as good as you can"*, *"why is the output shallow"*) or hand over an outcome-type deliverable (a report, deck, analysis, plan, audit, or performance goal). Routine single-step edits, quick commands, or requests with an explicit ceiling (*"just"*, *"quick"*, *"only"*) are bypassed. Use [`/be-more-ambitious`](./be-more-ambitious.md) when you explicitly want a standalone prompt-transformation breakdown on demand, and [`/gauntlet-loop`](./gauntlet-loop.md) when you want a multi-round builder-vs-critic loop against a blind reference bar.

## Common questions

### How does it avoid bloating the scope into work I didn't ask for?

Stage 1 enforces a **deeper, not bigger** guard: an expansion may upgrade raw inputs, analytical instruments, targets, and proof, but cannot add unrequested deliverables, widen the audience, or touch unrelated systems. Any new index, migration, cache, scheduled job, or dependency is split out under *Out of scope / optional follow-ups* and gated on your confirmation.

### When does it pause to ask for confirmation?

Before executing Stage 6, it presents the **Ambition Rewrite** and asks for confirmation whenever the expansion widens scope, adds material time or token cost, requires new access or package installs, writes outside working files, reads large/sensitive data, or is hard to reverse. In non-interactive runs, it stops at the gate marked `awaiting confirmation`.

### How does it handle tasks that have no automated test or external verifier?

It ranks outside judges from strongest to weakest (executable tests/queries/reconciliations → held-out data → fresh-context reviewer → exact human verification questions). If no external judge is available—common for creative or judgment-heavy work—it never invents a score and instead reports `UNVERIFIED: no external judge available` with what would verify it.

## It's working if

- Small edits or ceiling-constrained requests record `Ambition check: bypassed (<reason>)` immediately without unnecessary ceremony.
- Expanded tasks produce the three-rung Goal Ladder (or `Altitude: not applicable`), four Depth answers grounded in real available inputs, and lenses that each perform a concrete check without persona voice.
- An **Ambition Rewrite** is shown—and confirmed if scope, cost, access, or side effects increase—before execution.
- An outside judge runs and its unedited command/output is pasted in the handoff, or gaps are explicitly listed under `Unverified`.
