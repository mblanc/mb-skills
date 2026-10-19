# Worked Examples: Transforming Instructions into Ambitious Prompts

Grounded in Felix Rieseberg's [How to be more ambitious: A tutorial for humans with models](https://felixrieseberg.com/how-to-be-more-ambitious-a-tutorial-for-humans-with-models/).

---

## Example 1: Quarterly Business Review (Data & Strategy)

### Original User Instruction
> "Update our Q3 QBR slide deck template with the latest revenue and churn numbers from the CSV export."

### Ambition Diagnosis
- **Verb Reframe**: Not "filling in a QBR slide deck", but "getting busy decision-makers to believe a causal story about what changed this quarter and commit to resource-allocation decisions under uncertainty in 30 minutes."
- **Altitude**: Move from updating template numbers to diagnosing what changed and why, surfacing the 3 most urgent leadership decisions with for/against trade-offs, and designing a continuous early-warning mechanism backtested against past quarters.
- **Depth**:
  1. *Unasked expert move*: Cohort survival analysis, causal decomposition of churn vs. expansion, and predictive early-signal discovery.
  2. *Rawest material*: Raw event logs, subscription ledger events, and support/onboarding traces rather than pre-aggregated summary tables.
  3. *Real instruments*: SQL/DuckDB + Python statistical modeling (`lifelines` / `statsmodels`) instead of hand-calculated markdown tables.
  4. *Outside judge*: Out-of-sample backtest showing the model reproduces the past year's churn from raw logs and predicts held-out cohort retention accurately.
- **Range**:
  - *Investigative journalist & editor*: Lead with the non-obvious headline finding supported by primary evidence; cut every chart that does not drive a decision.
  - *Short seller & forensic accountant (Red Team)*: Try to falsify the team's default narrative ("churn is just an onboarding issue") against raw cohort data and check for metric flattering or survivorship bias.

### Upgraded Instructions
```markdown
## Objective & Outcome (Altitude)
Don't just fill in the QBR template numbers. Using all available raw customer, revenue, and product usage data:
1. Determine what meaningfully changed this quarter, why it changed, and what we should do about it.
2. Identify the 3 most urgent resource-allocation or product decisions leadership must make based on these findings, and lay out concrete options for each with rigorous for/against arguments.
3. The QBR exists so leadership catches problems early and moves people and capital to the right places. Design an automated continuous early-warning check that catches these shifts sooner than a quarterly deck, backtest it against our historical data to prove it would have flagged this quarter's inflection points earlier, and output a runnable script we can run weekly alongside the QBR.

## Raw Inputs, Instruments & Rigor (Depth)
- Start from the rawest data available (raw transaction/event logs and cohort records, not just top-line summary CSVs).
- Use real data-science instruments: load the raw data into DuckDB/SQLite and run Python statistical scripts (cohort retention curves, hazard/survival models, and decomposition of net revenue retention). Do not eyeball numbers or rely on surface markdown tables.
- Challenge our existing assumptions: test the hypothesis that "churn is an onboarding problem" directly against raw cohort behavior and try to falsify it.
- Produce new knowledge: build a behavioral model from the logs that reproduces the last 12 months of retention, identify the earliest statistically significant leading indicator of churn we aren't currently tracking, and measure its predictive power.

## Cross-Disciplinary & Red-Team Methods (Range)
- **Forensic Accountant & Short-Seller Red Team**: Audit every headline metric for survivorship bias, mix shifts, or cohort masking. Explicitly list the strongest counter-arguments a skeptical short seller would raise against our growth/retention story and test whether the raw data supports their skepticism.
- **Investigative Journalist & Editor**: Structure the final narrative around cause, effect, and decision urgency so a busy executive grasps the core trade-offs in under 30 minutes.

## Verification & Outside Judge (Definition of Done)
- Validate all statistical claims and early-warning signals against a held-out time window (train on earlier quarters, verify prediction accuracy on the most recent quarter).
- Reconcile all bottom-up cohort queries against top-line financial totals with zero discrepancy via automated assertions in the analysis script.
```

---

## Example 2: Fixing a Bug or Crash (Software Engineering)

### Original User Instruction
> "Fix this TypeError crash in the checkout handler when `discountCode` is null, and make the checkout page load faster (around 5 seconds instead of 10 seconds)."

### Ambition Diagnosis
- **Verb Reframe**: Not "patching one null pointer and shaving a few seconds off a page", but "eliminating an entire class of runtime boundary failures while making checkout feel instantaneous."
- **Altitude**: Step up from patching one crash to building an automated crash-reproduction and boundary-verification harness that keeps the checkout flow crash-free across edge cases.
- **Depth**:
  1. *Unasked expert move*: Parse-don't-validate boundary schema enforcement, property-based fuzzing of checkout payloads, and critical-path waterfall elimination.
  2. *Rawest material*: Raw error traces, git blame/history of the checkout module, network waterfall traces, and database query execution plans (`EXPLAIN ANALYZE`).
  3. *Real instruments*: Automated test runner, property-based testing (`fast-check` / `hypothesis`), profiler / flamegraphs, and headless browser performance traces.
  4. *Outside judge*: Automated reproduction test suite + property fuzzer (1,000+ generated malformed/edge payloads with 0 unhandled exceptions) + benchmark script asserting p95 checkout latency under 200ms.
- **Range**:
  - *Type-System / Formal Methods Engineer*: Make illegal states unrepresentable at the module boundary rather than scattering defensive `if (x != null)` checks.
  - *Chaos / Adversarial Security Engineer (Red Team)*: Feed adversarial inputs (race conditions, double-submits, negative quantities, expired/corrupted codes) to break the handler.

### Upgraded Instructions
```markdown
## Objective & Outcome (Altitude)
1. Fix the immediate `discountCode` crash, then go one level higher: make the entire checkout pipeline resilient against malformed, partial, or unexpected state so this class of crash cannot recur.
2. Instead of aiming for a 5-second load time (down from 10s), treat a **sub-200ms server response / sub-500ms interactive checkout** as a solvable engineering constraint and eliminate the underlying bottlenecks.

## Raw Inputs, Instruments & Rigor (Depth)
- Start from raw material: inspect the full stack trace, git history of recent checkout regressions, and actual runtime profiling / SQL query plans rather than guessing where time is spent.
- Use real engineering instruments:
  - Build a deterministic reproduction test that fails on the current commit before touching implementation code.
  - Profile the checkout path using real timing instrumentation / query `EXPLAIN` plans to find the exact N+1 queries, serial network waterfalls, or blocking computations.
  - Replace ad-hoc null checks with strict boundary parsing (parse, don't validate) so internal checkout functions only receive validated domain types.

## Cross-Disciplinary & Red-Team Methods (Range)
- **Chaos & Security Red Team**: Write a property-based fuzz test suite that bombards the checkout handler with boundary mutations (nulls, unicode, negative numbers, concurrent duplicate requests, expired promotions, stale cart state) to uncover latent bugs we haven't hit in production yet.
- **High-Frequency Systems Engineering**: Audit every synchronous I/O call on the critical path; parallelize independent fetches, precompute or cache static pricing metadata, and move non-critical post-checkout work off the request thread.

## Verification & Outside Judge (Definition of Done)
- Do not self-certify. Run the test suite, property-based fuzzer, typechecker, and a repeatable latency benchmark script.
- Only consider the task complete when the outside judges confirm: (1) the original crash test passes, (2) 1,000+ fuzzed boundary payloads produce zero unhandled exceptions, and (3) the benchmark script measures p95 execution under the target threshold.
```
