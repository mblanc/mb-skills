# Worked Examples & Prompt Variants for Gauntlet Loop

Grounded in:
- Matt Shumer's original [Claude of Duty](https://github.com/mshumer/Claude-of-Duty/blob/main/prompt.md) Gauntlet Loop prompt
- Jay E / RoboNuggets' [robonuggets/gauntlet-loop](https://github.com/robonuggets/gauntlet-loop) (the 3 Bar Tests: Named, Fetchable, Comparable; Taste + Number)
- [duolahypercho/gauntlet-loop](https://github.com/duolahypercho/gauntlet-loop) (3-paragraph aim skeleton & harness overlays for Claude Code `/loop` + `ultracode` vs. Codex `/goal`)
- The Prompt Index's [AI Loop Engineering & Gauntlet Loop Guide](https://www.thepromptindex.com/ai-loop-engineering-gauntlet-loop-guide.html#three-elements) (Objective, Metric/Reference, Boundary + integration pass)

---

## Prompt Style Variants

Depending on the user's preference and harness, `/gauntlet-loop` can output either:

1. **Universal Bounded Gauntlet Prompt (Default)**: Combines the concrete reference bar, blind A/B fresh-context critic, objective test/metric verifiers, state file (`GAUNTLET_PROGRESS.md`), strategy-shift rule, final integration critic, and explicit stop/safety boundaries.
2. **Classic 150-Word Aim Prompt (Matt Shumer / RoboNuggets style)**: Short, punchy prose with minimal prescription and human-as-brake (or a single budget line), adapted to the target harness's loop verb:

| Harness | Loop Verb | Closing Tail |
|---|---|---|
| **Portable (Any Agent)** | `Keep looping` | `Run the builders and critics as parallel subagents.` |
| **Claude Code** | `/loop` | `/loop until it wins. Fan out subagents and ultracode.` |
| **Codex** | `/goal` | `/goal until it wins. Fan out subagents.` |

---

## Example 1: Web UI & Product Page

### Original User Instruction
> `/gauntlet-loop build a pricing page for my developer tools SaaS`

### Step 2: Clarifying Questions with Proposed Defaults
- **1. Objective (Default)**: Build a responsive developer-SaaS pricing page in Next.js + Tailwind CSS featuring plan comparison (Free, Pro, Enterprise), monthly/annual billing toggle, interactive usage estimator, FAQ accordion, and complete mobile-friendly checkout CTA flow.
- **2. Reference Bar & Metric**:
  - *Candidate Bar A (Recommended)*: **Linear's pricing page (`linear.app/pricing`)** — screenshotted at 1440px desktop and 375px mobile viewports.
  - *Candidate Bar B*: **Vercel's pricing page (`vercel.com/pricing`)** — best for usage-based calculator + tier matrix clarity.
  - *Candidate Bar C*: **Raycast's pricing page (`raycast.com/pricing`)** — best for dark-mode craft, micro-interactions, and typography.
  - *Objective Metric (Default)*: Zero console/build errors, zero horizontal overflow at 360px–1440px, all interactive toggle/calculator tests pass, and zero automated WCAG contrast/landmark violations.
- **3. Boundary (Default)**: Stop when all sections + full-page integration win blind A/B comparison against the reference and pass all layout/interaction checks, or after **max 5 rounds per section** (pivoting strategy if the same visual gap fails twice). Local file edits and headless browser rendering allowed; no deployment or external spend without approval.

### Step 3: Output (Assuming Defaults / Bar A)

#### Gauntlet Loop Design Card
| Element | Specification |
|---|---|
| **Objective** | Responsive developer-SaaS pricing page (Next.js + Tailwind) with plan cards, billing toggle, usage slider, comparison table, and FAQ |
| **Reference Bar (Taste)** | `https://linear.app/pricing` captured at 1440×900 (desktop) and 375×812 (mobile) before building |
| **Objective Metric (Number)** | Build passes, 0 console errors, 0 horizontal overflow at 360px/768px/1440px, interactive toggle + slider assertions pass |
| **Decomposition** | Hero & billing toggle, Tier cards, Usage calculator, Feature matrix, FAQ, Mobile layout (shared design tokens owned sequentially first) |
| **Critic Protocol** | Fresh-context critic opens real browser screenshots at matching viewports, compares blind A/B against `linear.app/pricing`, makes binary pick + names single largest gap |
| **Boundary** | Max 5 rounds/piece; pivot after 2 stagnant rounds; local dev server only; no deploy without approval |

#### Transformed Gauntlet Loop Prompt (Universal Bounded)
```markdown
Build a responsive developer-SaaS pricing page in Next.js and Tailwind CSS where a first-time visitor can compare Free, Pro, and Enterprise tiers, toggle monthly/annual billing, estimate usage costs, and complete the signup CTA on desktop and mobile.

## 1. The Quality Bar & Metric (Fetch First)
The quality bar is Linear's live pricing page (`https://linear.app/pricing`). Before writing application code, open `https://linear.app/pricing` in a headless browser and capture full-page and viewport screenshots at 1440x900 (desktop) and 375x812 (mobile). Compare against those real screenshots directly—never against a memory or description of Linear's style.
Every piece must also pass these objective checks: zero build or console errors, zero horizontal overflow at 360px, 768px, and 1440px, working keyboard navigation, and passing interaction checks for the billing toggle and usage slider.

## 2. Decomposition & Ownership
Establish the shared typography, color tokens, and grid system first under a single owner. Then break the page into the smallest pieces that can be built and judged on their own:
1. Hero header & monthly/annual billing toggle
2. Three-tier pricing cards & CTA hierarchy
3. Interactive usage estimator
4. Sticky feature comparison table
5. FAQ accordion & mobile responsive polish

Fan out parallel builder subagents only on independent sections that consume the locked design tokens.

## 3. The Builder vs. Harsh Critic Loop
For each piece, run a builder and a separate critic subagent with fresh context:
1. **Build & Verify**: The builder implements the section, renders it in a real browser at 1440x900 and 375x812, and verifies all layout and interaction checks pass.
2. **Inspect the Real Artifact**: The critic inspects the actual rendered screenshots (desktop and mobile)—never the builder's code description.
3. **Blind A/B Pick**: The critic places our section screenshot next to the corresponding `linear.app/pricing` screenshot blind with labels stripped, states which one looks and reads better, and—if ours loses—names the **single largest remaining gap** (typography rhythm, border contrast, spacing hierarchy, motion, or density) and returns it to the builder.
4. **No Soft Grading**: The critic must be a harsh critic. Praise and 1–10 scores are forbidden. If ours does not win the blind pick, keep going.

## 4. State Tracking & Strategy Shifts
Record every round in `GAUNTLET_PROGRESS.md` (piece, round, objective check status, blind A/B winner, single gap targeted, and failed approaches). If the same visual gap fails two rounds in a row, change the layout or styling approach rather than tweaking the same CSS values.

## 5. Final Integration Pass & Boundaries
- **Integration Critic**: Once individual sections win, run one fresh full-page integration critic at desktop and mobile viewports to eliminate visual seams between sections and verify end-to-end visual rhythm against `linear.app/pricing`.
- **Boundaries**: Stop when all pieces and the full-page integration win the blind comparison and pass all objective checks, or after 5 rounds per piece / 2 consecutive rounds with no meaningful improvement. Work locally only; do not deploy or modify production config without explicit approval.
Keep looping until the critic picks ours, running builders and critics as fresh subagents.
```

---

## Example 2: Software Engineering / CLI Tool (Taste + Benchmark)

### Original User Instruction
> `/gauntlet-loop build a CLI tool in Rust or Go that formats and filters structured JSON logs`

### Step 2: Clarifying Questions with Proposed Defaults
- **1. Objective (Default)**: Build a fast, zero-config CLI tool in Rust (`logfmt-rs`) that reads newline-delimited JSON (NDJSON) logs from stdin or files, auto-detects timestamp/level/message/fields, pretty-prints colorized human-readable output, and supports key/level filtering (`--level`, `--filter key=val`).
- **2. Reference Bar & Metric**:
  - *Candidate Bar A (Recommended)*: **`hl` (`pamburus/hl`) + `jq`** — compared against `hl` for terminal readability/ergonomics (`--help` UX, color hierarchy, error messages) and benchmarked against `jq` on a 100k-line NDJSON fixture.
  - *Candidate Bar B*: **Charmbracelet `gum` / `glow` CLI UX + `pino-pretty`** — judged on terminal aesthetics and JSON log formatting ergonomics.
  - *Objective Metric (Default)*: 100% pass rate on unit + malformed-line fuzz tests (10,000 mutated lines with 0 panics) + streaming throughput beating `jq -C '.'` on a 100k-line NDJSON file with < 30MB peak RSS.
- **3. Boundary (Default)**: Stop when all CLI ergonomics win blind comparison against the reference and all fuzz + throughput benchmarks pass, or after 5 rounds per module. Local build/test/benchmark only.

### Step 3: Transformed Gauntlet Loop Prompt (Classic Compact Variant)
```markdown
Build a fast CLI tool in Rust that streams NDJSON logs from stdin or files, auto-detects timestamp, severity level, message, and structured fields, pretty-prints scannable terminal output, and filters by level and field expressions.

The bar has two halves: `pamburus/hl` for terminal readability and `--help` ergonomics, and `jq` for streaming throughput. Fetch `hl`'s real output formats and benchmark against `jq` on a generated 100,000-line realistic NDJSON fixture—never compare against a description of them. Every round must also pass a 10,000-input malformed-JSON fuzz test with zero panics and beat `jq` throughput with under 30MB RSS.

Break this into the smallest pieces that can be improved and judged on their own—CLI flag/help UX, streaming NDJSON parser & fault tolerance, colorized terminal renderer & field alignment, filter engine, and throughput benchmark suite. For each piece, fan out a builder and a separate harsh critic with fresh context. The critic runs the real binary on dirty log fixtures, puts our terminal output and benchmark numbers next to the bar blind with labels stripped, says which one wins, and names the single biggest remaining gap. Then it goes back to the builder.

Praise is not useful. If ours does not win both the blind output pick and the benchmark, keep going. Record each round and failed approach in `GAUNTLET_PROGRESS.md`, change strategy if the same bottleneck fails twice, and finish with a fresh end-to-end integration critic. Stop when every piece wins and passes all benchmarks, or after 5 rounds per piece.
```

---

## Example 3: Technical Writing & Explanation

### Original User Instruction
> `/gauntlet-loop write a 2000-word explainer on vector databases and HNSW indexing for smart non-engineers`

### Step 3: Transformed Gauntlet Loop Prompt
```markdown
Write a 2,000-word explainer on vector databases and HNSW indexing for readers who are smart decision-makers but not software engineers.

## 1. The Quality Bar & Metric (Fetch First)
The quality bar is Julia Evans' technical explainers (`jvns.ca`). Before drafting, fetch 3 of her actual published explainers on systems topics and inspect how she opens with a concrete question, builds intuition before jargon, uses plain ASCII/visual diagrams, and keeps sentences tight.
Every draft must also meet these objective checks: 1,800–2,200 words, zero undefined acronyms, at least 2 self-contained visual/ASCII mental-model diagrams, and 100% factual accuracy on how embeddings, cosine distance, and hierarchical navigable small world (HNSW) graphs work.

## 2. Decomposition
Break the piece into independently judgeable sections:
1. The hook & concrete problem (why keyword search fails on meaning)
2. Embeddings explained without linear-algebra jargon
3. The scaling bottleneck (why brute-force nearest-neighbor search is slow)
4. How HNSW works (the express-train / layered skip-list mental model + diagram)
5. Practical trade-offs (recall vs. latency vs. memory) & closing takeaway

## 3. The Writer vs. Harsh Critic Loop
For each section, run a writer and a separate critic subagent with fresh context:
1. The critic reads the actual drafted section alongside a comparable Julia Evans passage blind with bylines stripped.
2. The critic makes a binary pick on which passage a smart non-engineer would understand faster and enjoy more, and verifies that no hand-wavy or factually wrong claims crept in.
3. If ours loses, the critic names the **single largest remaining gap** (abstract throat-clearing, ungrounded analogy, dense paragraph, or missing diagram) and sends it back to the writer. Praise and 1–10 scores are forbidden.

## 4. State Tracking, Integration & Boundaries
Track rounds and rejected angles in `GAUNTLET_PROGRESS.md`. If a section loses twice for the same reason, rewrite the analogy from scratch. Finish with a fresh whole-article integration critic that reads all 2,000 words aloud for transitions, pacing, and repetition. Stop when every section and the full piece win the blind comparison and pass all word-count and accuracy checks, or after 5 rounds per section.
```

---

## Example 4: Original Matt Shumer "Claude of Duty" Prompt (Reference)

For users who ask for the original 152-word unfiltered Matt Shumer aim prompt ([`mshumer/Claude-of-Duty`](https://github.com/mshumer/Claude-of-Duty/blob/main/prompt.md)):

```text
I want you to build [THING] at the level of [REFERENCE]. It should be utterly perfect, [LOOK], with every single thing done at [TIER] quality—from [AREA_1] to [AREA_2] to anything you could think of.

Fan out sub-agents and have sub-agents tackle each one individually so that the [THING] is utterly perfect. You should [LOOP_VERB] on each item and have a separate sub-agent check it [CHECK] to ensure it looks [TIER]. That separate sub-agent should be a really harsh critic, and if it doesn't look [TIER], it should keep going.

Don't stop until each sub-agent is utterly wowed with the quality when compared with the actual [REFERENCE]. It should literally compare them side by side blind and say which one looks better. Do this in [STACK]. [LOOP_VERB] until it's utterly perfect. Fan out sub-agents[CLOSING_TAIL].
```
