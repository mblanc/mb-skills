# gauntlet-loop

## What it does

Transforms a user's instructions or goal into a **Gauntlet Loop** prompt—an autonomous builder-versus-critic feedback loop grounded in Matt Shumer's [Claude of Duty](https://github.com/mshumer/Claude-of-Duty) technique, [robonuggets/gauntlet-loop](https://github.com/robonuggets/gauntlet-loop), [duolahypercho/gauntlet-loop](https://github.com/duolahypercho/gauntlet-loop), and the [AI Loop Engineering Three-Elements Framework](https://www.thepromptindex.com/ai-loop-engineering-gauntlet-loop-guide.html#three-elements).

Instead of accepting a single-pass draft where the model grades its own homework against vague adjectives, `/gauntlet-loop` clarifies and locks in three loop elements—**Objective** (the concrete outcome state), **Reference or Metric** (a named, fetchable benchmark for blind A/B comparison plus objective tests, judged by a harsh critic with fresh context), and **Boundary** (stop conditions, round/stagnation caps, strategy-pivot rules, and safety gates)—proposing opinionated defaults whenever any element is missing.

## When to reach for it

- **Invocation mode.** You invoke this by typing `/gauntlet-loop` (either followed by your goal, e.g. `/gauntlet-loop build a SaaS pricing page`, or during an ongoing conversation). The agent will not fire it on its own.
- **Trigger boundary.** Reach for `/gauntlet-loop` when you want an agent to iteratively build, inspect, compare against a real-world benchmark, and improve an artifact across multiple rounds without you manually writing follow-up critique prompts. If you instead want to expand the *scope and ambition* of a one-shot analytical or engineering problem across Altitude, Depth, and Range before deciding how to run it, use [`/be-more-ambitious`](./be-more-ambitious.md). (You can also run `/be-more-ambitious` first to elevate the problem, then `/gauntlet-loop` to wrap the execution in a builder-vs-critic loop.)

## Common questions

### What if I don't know what reference bar or boundaries to pick?

The skill proposes concrete defaults for all three elements before locking in the prompt:
1. **Objective**: A sharpened deliverable and outcome statement tailored to your stack.
2. **Reference or Metric**: 2 to 3 specific, named, fetchable candidate bars (`A (Recommended)`, `B`, `C`) that pass the **Named, Fetchable, Comparable** test, paired with an objective metric or test suite ("taste plus a number").
3. **Boundary**: Sensible stop conditions (e.g., win blind A/B + pass checks, max 5 rounds per piece, pivot strategy after 2 identical failures, local-only edits with no unapproved deploy or spend) alongside a "human-as-brake" option.

You can customize any element or simply reply *"use defaults"*.

### Why does it insist on a binary blind A/B pick instead of a 1–10 score?

When an AI critic grades work on a 1–10 scale or against a self-written rubric, scores naturally drift upward from 7/10 to 9/10 after a couple of rounds—even when the artifact is still mediocre. By forcing a separate critic with fresh context to inspect the actual output (screenshots, running binary, or draft text) alongside a fetched real-world reference with labels stripped, the critic has a binary job: **pick which one is better** and name the **single largest remaining gap**.

### Does it just generate the prompt, or can it execute the loop too?

It outputs the **Gauntlet Loop Design Card** and a copy-paste-ready **Gauntlet Loop Prompt** first, then offers to either run the loop immediately in the current session as the lead orchestrator, tweak any of the three elements, or switch the loop tail for a specific harness (Portable subagents, Claude Code `/loop` + `ultracode`, or Codex `/goal`).

## It's working if

- The skill catches vague quality bars (*"make it look professional"*, *"AAA quality"*) and replaces them with a **named, fetchable, side-by-side comparable** reference plus an objective test or metric.
- Clarifying questions for missing **Objective**, **Reference/Metric**, or **Boundary** elements always come with concrete, ready-to-use defaults.
- The generated prompt separates the **builder** from a **fresh-context harsh critic** that inspects the real rendered/executed output rather than the builder's summary.
- Tightly coupled systems are kept under coherent sequential ownership rather than blindly parallelized, and the loop finishes with a whole-artifact **integration critic** pass.
- Explicit **boundaries** (stagnation pivots, round caps, and permission gates) prevent the loop from spinning endlessly on the same failed approach or taking unsafe external actions.
