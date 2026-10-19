---
name: gauntlet-loop
description: Transform instructions into a Gauntlet Loop prompt with a concrete Objective, blind-comparable Reference or Metric, harsh fresh-context critic, and explicit Boundaries.
disable-model-invocation: true
---

# Gauntlet Loop

Transform a user's initial instructions or goal into a **Gauntlet Loop**—an autonomous builder-versus-critic feedback loop grounded in Matt Shumer's [Claude of Duty](https://github.com/mshumer/Claude-of-Duty) technique, [robonuggets/gauntlet-loop](https://github.com/robonuggets/gauntlet-loop), [duolahypercho/gauntlet-loop](https://github.com/duolahypercho/gauntlet-loop), and the [AI Loop Engineering Three-Elements Framework](https://www.thepromptindex.com/ai-loop-engineering-gauntlet-loop-guide.html#three-elements).

Most agent output stops at "good enough for AI" because the builder grades its own homework against vague words. A Gauntlet Loop replaces one-shot prompting with a persistent cycle built on three core elements:

1. **Objective**: The concrete deliverable and outcome state that must become true.
2. **Reference or Metric (The Bar & Harsh Critic)**: A named, fetchable, side-by-side comparable benchmark—paired with objective tests or metrics where applicable—judged blind by a separate critic with fresh context.
3. **Boundary**: Explicit success criteria, round/stagnation caps, strategy-pivot rules, and safety/permission gates that control when the loop stops or escalates.

---

## Step 1: Identify the Seed Instructions & Context

1. If the user passed instructions inline with `/gauntlet-loop <instructions>`, use those as the seed.
2. If the user invoked `/gauntlet-loop` without arguments during an ongoing conversation, use the current task, plan, or prompt under discussion.
3. If there is no clear task in the message or conversation history, ask the user what they want to build or achieve before proceeding.
4. If the task touches a local codebase or workspace, quickly inspect the directory structure, tech stack, test runner, or build scripts so your proposed defaults reference real project tools and commands.

---

## Step 2: Clarify the Three Loop Elements (Proposing Defaults)

Audit the user's request against the **Three Core Elements** below. Whenever any element is missing, underspecified, or uses a vague quality bar, **ask the user to confirm or adjust the three elements while proposing concrete, opinionated defaults**.

> **Fast-path rule**: If the user already supplied a clear Objective, a specific fetchable Reference/Metric, and clear Boundaries—or explicitly said *"use defaults"* / *"just write the prompt"*—skip asking and proceed directly to Step 3 using your best defaults.

### 1. Objective (What Concrete Outcome Must Become True?)

- Replace vague intentions (*"make the site better"*, *"write a good CLI"*) with an observable outcome state and deliverable (*"Build a responsive SaaS pricing page in Next.js + Tailwind where a first-time visitor can compare all plans and complete checkout on mobile"*).
- **Proposed Default**: Draft a sharpened 1–2 sentence Objective (including the detected or recommended tech stack / format) for the user to approve or tweak.

### 2. Reference or Metric (The Quality Bar & Outside Judge)

Everything in a Gauntlet Loop depends on the quality bar. A valid reference bar **must pass three tests**:

- **Named**: A specific real-world artifact, not an adjective or category. (*"Stripe's live pricing page"* or *"Hades combat screenshots"* works; *"award-winning SaaS design"* or *"AAA quality"* alone fails.)
- **Fetchable / Inspectable**: The critic can actually obtain and inspect it during the run—screenshot the live URL, read the published article, run the binary, or inspect the repository. If the agent cannot fetch the reference, it will hallucinate the comparison and approve mediocre work.
- **Comparable**: Both our actual output and the reference can sit side-by-side with labels stripped so a fresh critic can make a **binary blind A/B pick** (*"Which one wins?"*) and name the **single largest remaining gap**. Never use a 1–10 numerical score, which drifts upward every round.

**Taste + Number beats taste alone**: Whenever the goal has a measurable dimension (unit/integration test suite, p95 latency, Lighthouse/accessibility score, zero horizontal overflow at 360px, benchmark throughput, word count, or primary-source citation trace), pair the qualitative reference bar with an hard objective verifier.

| Goal Type | Reference Bar + Metric That Works |
|---|---|
| **Website, App, UI** | Live URL of a specific best-in-class product (`linear.app`, `stripe.com/pricing`, `vercel.com`) screenshotted at desktop & mobile viewports + zero console/accessibility/overflow errors |
| **Code, CLI, Library** | A named open-source repo or tool's implementation (`ripgrep`, `jq`, `esbuild`) + an automated test suite, property fuzzer, and latency/throughput benchmark script |
| **Game, 3D, Interactive** | Actual gameplay screenshots or footage from a named shipped title (`Call of Duty`, `Hades`, `Brotato`) compared against live in-game frames + target FPS / playability check |
| **Writing, Docs, Explainer** | 2–3 specific published pieces by a named author or publication (e.g. Julia Evans, Stripe Engineering Blog, Gwern) compared blind with bylines stripped + target length/reading-time check |
| **Research, Strategy, Analysis** | A named analyst report, benchmark paper's methods section, or forensic short-seller memo + automated reconciliation of all claims against raw source data |
| **Slide Deck, Deliverable** | A specific public deck or memo from a benchmark firm at the same page/slide count + narrative clarity check |

- **Proposed Default**: Offer **2 to 3 specific, named, fetchable candidate bars** (marking the toughest genuinely reachable one as `(Recommended)`), paired with a concrete objective metric/verifier.

### 3. Boundary (Stop Conditions, Budgets & Safety Gates)

"Loop until utterly perfect" motivates the critic, but an unbounded loop against an unreachable bar can spin forever, burn tokens, or make unsafe changes. Define explicit boundaries across three sub-axes:

- **Success & Convergence Stop**: Exit when every component passes its objective verifier and wins the blind comparison against the reference (or when human-designated "brake" stops the run).
- **Iteration & Stagnation Cap**: Cap rounds per component (default: **max 5 rounds per piece** or **stop after 2 consecutive rounds with no meaningful improvement**). Require the builder to **change strategy** if the exact same gap fails twice in a row.
- **Permissions & Safety Gate**: Allow local reading, drafting, editing, building, rendering, and testing. Forbid irreversible or external actions without explicit human approval (no production deployment, destructive deletions, paid API spend, credential/secret changes, or external messages).

### How to Ask the User

If clarification is needed, present a brief, scannable prompt (or use the harness's structured `ask_question` tool if available) covering only the unresolved elements, with defaults pre-filled so the user can reply with a single shorthand (e.g., *"1, use defaults"*):

1. **Objective**: State your proposed sharpened Objective + stack and ask if anything should change.
2. **Reference & Metric**: List **2–3 named, fetchable candidate bars** (`A`, `B`, `C`, with `A (Recommended)`) plus the proposed objective verifier/test.
3. **Boundary**: Propose the default stop condition (e.g., *Win blind A/B + pass checks, max 5 rounds/piece, pivot strategy after 2 identical failures, local-only edits*) OR *"Human-as-brake (keep looping until I stop it)"*, and ask which mode they prefer.

---

## Step 3: Output the Transformed Gauntlet Loop

Once the Objective, Reference/Metric, and Boundary are chosen (or defaulted), present the result in three parts:

### 1. Gauntlet Loop Design Card

Output a concise summary table locking in the loop architecture:

- **Objective**: The exact outcome and deliverable that must become true.
- **Reference Bar (Taste)**: The named, fetchable artifact and how it will be fetched/inspected prior to building.
- **Objective Metric (Number)**: The automated test, benchmark, layout check, or factual verification required before a critic review.
- **Decomposition Rule**: How the work splits into small, independently judgeable pieces (parallelizing *only* genuinely independent parts; keeping tightly coupled systems under coherent sequential ownership).
- **Critic Protocol**: Separate subagent with fresh context; inspects the real rendered/executed artifact (never the builder's summary); runs a blind A/B comparison with labels stripped; makes a binary pick and names the single largest remaining gap.
- **State & Progress**: The file used to persist loop memory (`GAUNTLET_PROGRESS.md` or a live progress page) recording completed parts, evidence, failed approaches, and remaining gaps so context does not rot.
- **Boundary**: The active stop rules, round caps, and safety gates.

### 2. The Gauntlet Loop Prompt

Output a self-contained, copy-paste-ready prompt inside a fenced `markdown` block. Provide the **Universal Gauntlet Loop Prompt** below (adapted to the user's task, tools, and stack), and if the user wants the ultra-compact 3-paragraph Matt Shumer style or harness-specific loop commands, adapt the closing tail accordingly (see [references/examples.md](references/examples.md)).

```markdown
Build [DELIVERABLE / OBJECTIVE] in [STACK / FORMAT].

## 1. The Quality Bar & Metric (Fetch First)
The quality bar is [NAMED, FETCHABLE REFERENCE]. Before building or judging, fetch and inspect the real reference directly ([HOW TO FETCH: screenshot live URL at desktop & mobile / pull the published text / clone or run the reference implementation])—never compare against a memory or description of it.
Every piece must also pass these objective checks: [OBJECTIVE METRICS / TESTS / BENCHMARKS].

## 2. Decomposition & Ownership
Break the work into the smallest pieces that can be built, verified, and judged on their own: [INITIAL CANDIDATE PIECES].
- Fan out parallel builder subagents ONLY for pieces that are genuinely independent.
- Keep tightly coupled systems under sequential, coherent ownership so components do not collide.

## 3. The Builder vs. Harsh Critic Loop
For each piece, run a builder and a separate critic subagent with fresh context (no access to the builder's chain-of-thought or excuses):
1. **Build & Verify**: The builder creates or revises the piece and runs the objective checks ([TESTS / LINT / BENCHMARK / RENDER]).
2. **Inspect the Real Artifact**: The critic opens and inspects the actual output ([SCREENSHOTS / RUNNING BINARY / TEST LOGS / DRAFT TEXT])—never the builder's summary.
3. **Blind A/B Pick**: The critic places our artifact next to [NAMED REFERENCE] blind with labels stripped, makes a binary pick of which one is better, and—if ours loses—identifies the **single largest remaining gap** with concrete evidence and sends it back to the builder.
4. **No Soft Grading**: The critic must be ruthlessly harsh. Praise and 1–10 numerical scores are forbidden. If ours does not win the blind comparison and pass all objective checks, keep looping.

## 4. State Tracking & Strategy Shifts
Maintain a compact `GAUNTLET_PROGRESS.md` (and/or live progress view) after each round recording: current piece, round number, critic verdict, the single gap targeted, failed approaches, and objective check results. If the same gap fails twice in a row, abandon the current approach and try a structurally different strategy.

## 5. Final Integration Pass & Boundaries
- **Integration Critic**: Once individual pieces win, spawn one fresh integration critic to inspect the complete assembled artifact end-to-end for consistency, seams, performance, and fit with the original objective.
- **Boundaries**: [STOP CONDITIONS: e.g., Stop when all pieces + integration win blind A/B and pass all objective checks, or after N rounds per piece / 2 consecutive rounds with no measurable gain]. Allowed actions: [ALLOWED LOCAL ACTIONS]. Do not [FORBIDDEN ACTIONS: deploy to production, delete data, spend money, or touch credentials] without explicit human approval.
[HARNESS LOOP TAIL: Keep looping until the critic picks ours across every piece, running builders and critics as subagents. / Or for Claude Code: `/loop` on each piece until it wins; fan out subagents and `ultracode`. / Or for Codex: `/goal` until every piece wins.]
```

### 3. Execution Offer

End by asking:
> *"Would you like me to run this Gauntlet Loop right now as the lead orchestrator, tweak any of the three elements (Objective, Reference/Metric, Boundary), or switch the prompt style (Universal Bounded vs. Classic 150-Word Aim Prompt for Claude `/loop` or Codex `/goal`)?"*

If the user says to run it, immediately adopt the generated prompt as your active operating instructions: fetch the reference first, initialize `GAUNTLET_PROGRESS.md`, decompose the pieces, and start Round 1.

---

## What Breaks a Gauntlet Loop (Guardrails)

Never allow these failure modes into a generated Gauntlet prompt:

- **A vague or un-fetchable bar**: *"Make it world-class"* or naming a paywalled/unreachable artifact forces the critic to hallucinate the comparison and rubber-stamp everything.
- **The builder judging its own work**: A builder remembers every compromise it made and rationalizes them. The critic must be a fresh-context subagent (or a clean verification pass stripped of builder justifications).
- **Numerical 1–10 scores instead of a binary pick**: Scores out of 10 drift from 7/10 to 9/10 automatically over rounds. Require a binary blind A/B pick (*"Which one wins?"*) plus the **single largest remaining gap**.
- **Critic reading summaries instead of inspecting the artifact**: A glowing markdown status report is not evidence. The critic must inspect rendered pixels, execute the binary/tests, or read the actual text.
- **Parallelizing tightly coupled code**: Fanning out 10 subagents on the same state loop or shared rendering pipeline causes merge collisions and visual seams. Fan out only independent pieces and mandate a final integration critic.
- **Building loop scaffolding instead of the deliverable**: Do not let the agent spend the run inventing elaborate scoring frameworks or capture farms instead of improving the actual artifact.
