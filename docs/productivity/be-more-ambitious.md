# be-more-ambitious

## What it does

Transforms a user's prompt, task, or plan into a substantially more ambitious set of agent instructions based on Felix Rieseberg's framework ([How to be more ambitious: A tutorial for humans with models](https://felixrieseberg.com/how-to-be-more-ambitious-a-tutorial-for-humans-with-models/)).

Instead of merely asking the model for **Speed** (doing the same narrow task faster), `/be-more-ambitious` diagnoses the request and rewrites it across three orthogonal dimensions: **Altitude** (stepping up from the immediate task to the durable outcome and decision loop), **Depth** (starting from the rawest data, using real professional instruments, setting audacious targets, challenging assumptions, and mandating an independent outside judge), and **Range** (reframing nouns into verbs and applying concrete methods from multiple disciplines, including an adversarial red team, without falling into role-play).

## When to reach for it

- **Invocation mode.** You invoke this by typing `/be-more-ambitious` (either followed by your prompt, e.g. `/be-more-ambitious <task>`, or right after describing a task in the conversation). The agent will not fire it on its own.
- **Trigger boundary.** Reach for this whenever you catch yourself giving the agent a safe, incremental, or template-filling instruction ("make a slide deck from this CSV", "fix this crash", "speed up this endpoint by 20%", "summarize these logs") and want to see what a frontier-capability version of the task looks like before running it.

## Common questions

### Does it immediately execute the ambitious task, or rewrite the instructions first?

It diagnoses the task and outputs the upgraded, ready-to-run instruction block first, then asks whether you want to execute it immediately or dial a specific axis (Altitude, Depth, or Range) up or down.

### How does it avoid silly persona role-play when adding "Range"?

A common failure mode of multi-perspective prompting is asking the model to "talk like a short seller" or "act like a pirate", which makes the output weird without improving quality. `/be-more-ambitious` enforces Felix Rieseberg's guardrail: it translates nouns into verbs to identify relevant disciplines, then instructs the agent to run the *actual analytical methods and checks* those professionals use (e.g. cohort reconciliation, survivorship-bias audits, property-based fuzzing).

### What if my task is creative rather than operational?

Altitude works best when you are after an operational or decision-making outcome, and less well for pure creative craft where the artifact itself is the goal. The skill calibrates automatically: for creative tasks, it keeps Altitude light and focuses on **Depth** (real rendering/synthesis instruments, primary material, high craft standards) and **Range** (unexpected cross-disciplinary techniques).

## It's working if

- The rewritten instructions start from raw data, logs, or source code rather than pre-digested summaries or templates.
- Surface approximations (like prose guesses or static markdown tables) are replaced by real professional instruments (databases, statistical models, simulations, profilers, property-based tests).
- Every rewritten prompt names a concrete **outside judge** (an executable test, backtest on unseen data, benchmark, or formal check) so the model cannot grade its own homework.
- Cross-disciplinary additions specify concrete methods and adversarial red-team checks rather than theatrical role-play voices.
