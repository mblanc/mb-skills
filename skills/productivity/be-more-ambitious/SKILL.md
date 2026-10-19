---
name: be-more-ambitious
description: Transform a prompt or task into a more ambitious version across Altitude, Depth, and Range.
disable-model-invocation: true
---

# Be More Ambitious

Transform a user's initial instructions or task into a substantially more ambitious version, grounded in Felix Rieseberg's framework ([How to be more ambitious: A tutorial for humans with models](https://felixrieseberg.com/how-to-be-more-ambitious-a-tutorial-for-humans-with-models/)).

When a human gives an agent a task, they usually ask for **Speed** (doing the exact same narrow task faster), which only executes their first-pass guess at how to reach an outcome. This skill expands the instructions along three axes: **Altitude**, **Depth**, and **Range**.

## Step 1: Identify the Target Instructions

1. If the user passed instructions inline with `/be-more-ambitious <instructions>`, use those as the seed.
2. If the user invoked `/be-more-ambitious` without arguments during an ongoing conversation, use the current task, plan, or prompt under discussion.
3. If there is no clear task in the message or conversation history, ask the user what task or instructions they want to make more ambitious before proceeding.

If the task touches a codebase or workspace, quickly inspect the available tools, raw data, logs, tests, or scripts in the environment so your upgraded instructions reference real instruments rather than generic placeholders.

## Step 2: Diagnose Across the Three Ambition Axes

Before rewriting the prompt, run a concise diagnostic across the three axes below. Output this diagnostic briefly so the user can see *how* and *why* the task is being elevated.

### 1. Altitude (Go Up in Abstraction: Outcome Over Task)

Ask: **What do we want to happen next? What is the goal beyond the goal?**

- **Feed raw context, not pre-digested templates**: Instead of filling in a template or fixing one isolated symptom, instruct the agent to ingest the broadest relevant raw data/history to explain *what changed, why, and what to do about it*.
- **Drive to decisions**: If the output feeds human judgment or a meeting, instruct the agent to identify the 3 most urgent decisions forced by the findings and lay out concrete directions with rigorous for/against arguments.
- **Design a durable loop**: Ask whether the one-off task can be turned into a continuous, automated mechanism or guardrail (e.g. moving from "fix this crash" to "build a reproduction and verification loop that keeps the app crash-free", or backtesting a better mechanism against historical data and running it alongside the current one).
- *Calibration note*: Push Altitude hard when the user wants an operational, analytical, or engineering outcome. Keep Altitude restrained on purely creative craft where the specific artifact *is* the goal.

### 2. Depth (Go One Layer Deeper: Frontier Rigor & Outside Judge)

Ask: **How would a field-leading expert execute this, starting from raw material and proving it with an independent judge?**

Answer these four questions explicitly before rewriting:
1. **Unasked expert move**: What would a top professional in this field do here that the original prompt is not asking for?
2. **Rawest material**: What is the rawest source of truth available (raw logs, database tables, git history, ASTs, packet captures, primary sources) to start from instead of pre-digested summaries?
3. **Real instruments**: What specific professional tools and methods should the agent use instead of surface approximations? (When a model reaches for prose or markdown tables, insist on real instruments: SQL/DuckDB, statistical models, simulations, profilers, property-based tests, formal solvers, headless browsers, or 3D/rendering tools.)
4. **Outside judge**: What independent validator (other than the model's own self-assessment or the user's eyeballs) will prove the result is right? Insist on an executable feedback loop: a test suite, benchmark, backtest on held-out data, compiler/typecheck, or simulation.

Also apply these Depth levers where relevant:
- **Pick unreasonable targets and treat them as solvable**: Replace incremental goals (e.g. "load in 5s instead of 10s") with audacious engineering targets (e.g. "200ms"), instructing the agent that the goal is solvable and to keep iterating until verified.
- **Adversarially test existing beliefs**: Identify assumptions embedded in the user's request ("we think X is caused by Y") and instruct the agent to try to falsify or reproduce them directly from raw data.
- **Produce new knowledge**: Once inside the raw data or system, instruct the agent to find blind spots or predictive signals nobody asked about yet, and validate them on unseen data.

### 3. Range (Go Across Fields: Verbs & Multi-Disciplinary Methods)

Ask: **What other fields solve the underlying verb of this problem, and what methods would a world-class crew bring?**

- **Replace nouns with verbs**: Reframe the deliverable noun ("a QBR deck", "a migration plan", "a dashboard", "a CLI tool") into the active verb phrase describing what it must accomplish in the world (e.g. "get busy people to believe a story about cause and effect, and decide under uncertainty, in 30 minutes").
- **Assemble the crew (methods, NEVER role-play)**:
  - Pick 2 to 4 distinct fields that bring high-leverage perspectives to those verbs, including **builders/synthesizers** (e.g. systems engineer, statistician, investigative journalist, motion designer) and an **adversarial red team** (e.g. short seller, forensic accountant, chaos engineer, security researcher).
  - **Crucial guardrail**: Never instruct the model to *role-play* or *write in the voice of* a persona ("write like a short seller"). Role-play makes transcripts weird without improving the work. Instead, instruct the model to **execute the concrete methods and checks** those specialists use (e.g. "run the forensic accounting and short-seller research checks: reconcile top-line claims against raw cohort cash/usage flows and hunt for survivorship bias").

See [references/examples.md](references/examples.md) for concrete before/after transformations across engineering, data/strategy, and product tasks.

## Step 3: Output the Transformed Instructions

Present the result in three clean parts:

1. **Ambition Diagnosis**:
   - **Verb Reframe**: 1 sentence translating the noun deliverable into the real-world verb.
   - **Altitude**: How the scope moves from task to outcome/loop.
   - **Depth**: Answers to the 4 Depth questions (Expert Move, Rawest Material, Real Instruments, Outside Judge) + any assumption-testing or unreasonable target.
   - **Range**: The selected disciplines and the specific methods borrowed from each (including the red-team check).

2. **The Upgraded Prompt / Instructions** (inside a fenced `markdown` block so the user can copy it or tell you to run it):
   - Write a complete, self-contained, action-oriented instruction set that the agent can execute immediately using its computer, shell, code, and data tools.
   - Structure it clearly with:
     - **Objective & Outcome (Altitude)**
     - **Raw Inputs, Instruments & Rigor (Depth)**
     - **Cross-Disciplinary & Red-Team Methods (Range)**
     - **Verification & Outside Judge (Definition of Done)**

3. **Execution Offer**:
   - End by asking: *"Would you like me to execute these upgraded instructions right now, or dial any axis (Altitude, Depth, Range) up or down first?"*
