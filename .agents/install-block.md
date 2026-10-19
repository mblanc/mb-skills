# Canonical Install Block

Keep installation instructions consistent across `README.md` and any distribution docs.

## Local Development Symlinks (Recommended for Maintainers)

```bash
./scripts/link-skills.sh
```

Links active skills (`engineering/`, `productivity/`, `in-progress/`) into:
- `~/.agents/skills` (Codex and Agent Skills-compatible harnesses)
- `~/.claude/skills` (Claude Code)
- `~/.gemini/skills` (Gemini CLI)
- `~/.gemini/config/skills` (Antigravity)

## Managed Plugin Installs

### Claude Code

```bash
claude plugin marketplace add mblanc/mb-skills
claude plugin install mb-skills@mblanc
```

### Codex

```bash
codex plugin marketplace add mblanc/mb-skills
codex plugin add mb-skills@mblanc
```

### GitHub Copilot (CLI and VS Code)

```bash
copilot plugin marketplace add mblanc/mb-skills
copilot plugin install mb-skills@mblanc
```

Then, once, add to `~/.copilot/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "mblanc": { "source": { "source": "github", "repo": "mblanc/mb-skills" }, "autoUpdate": true }
  }
}
```

## Manual Copy Installs

### Gemini CLI

```bash
gemini skills install https://github.com/mblanc/mb-skills.git --path skills/engineering
gemini skills install https://github.com/mblanc/mb-skills.git --path skills/productivity
```

### skills.sh (All Harnesses / Single Skill)

```bash
npx skills@latest add mblanc/mb-skills -a <agent>
```

Single skill:

```bash
npx skills@latest add mblanc/mb-skills --skill=<name>
npx skills@latest update <name>
```
