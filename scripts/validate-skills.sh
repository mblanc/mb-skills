#!/usr/bin/env bash
set -euo pipefail

# Validates all skills in the repository against:
#   1. The Agent Skills Specification (https://agentskills.io/specification)
#   2. Repository invariants defined in AGENTS.md (.claude-plugin/plugin.json, docs/, openai.yaml)

REPO="$(cd "$(dirname "$0")/.." && pwd)"

node - "$REPO" <<'NODE_SCRIPT'
const fs = require("node:fs");
const path = require("node:path");

const repo = process.argv[2];
let errors = 0;
let warnings = 0;

function error(msg) {
  console.error(`ERROR: ${msg}`);
  errors++;
}

function warn(msg) {
  console.warn(`WARN:  ${msg}`);
  warnings++;
}

// Parse simple YAML frontmatter from SKILL.md
function parseFrontmatter(content) {
  const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/);
  if (!match) return null;
  const raw = match[1];
  const fields = {};
  const lines = raw.split(/\r?\n/);
  let currentKey = null;
  for (const line of lines) {
    if (!line.trim() || line.trim().startsWith("#")) continue;
    const topMatch = line.match(/^([a-zA-Z0-9_-]+)\s*:\s*(.*)$/);
    if (topMatch) {
      currentKey = topMatch[1];
      let val = topMatch[2].trim();
      if ((val.startsWith('"') && val.endsWith('"')) || (val.startsWith("'") && val.endsWith("'"))) {
        val = val.slice(1, -1);
      }
      fields[currentKey] = val;
    } else if (currentKey && /^\s+/.test(line)) {
      fields[currentKey] = (fields[currentKey] ? fields[currentKey] + " " : "") + line.trim();
    }
  }
  return fields;
}

// Discover all SKILL.md files under skills/
function findSkillFiles(dir, results = []) {
  if (!fs.existsSync(dir)) return results;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      findSkillFiles(full, results);
    } else if (entry.isFile() && entry.name === "SKILL.md") {
      results.push(full);
    }
  }
  return results;
}

const pluginPath = path.join(repo, ".claude-plugin", "plugin.json");
const pkgPath = path.join(repo, "package.json");

if (!fs.existsSync(pluginPath)) {
  error("Missing .claude-plugin/plugin.json");
}
if (!fs.existsSync(pkgPath)) {
  error("Missing package.json");
}

const plugin = fs.existsSync(pluginPath) ? JSON.parse(fs.readFileSync(pluginPath, "utf8")) : { skills: [] };
const pkg = fs.existsSync(pkgPath) ? JSON.parse(fs.readFileSync(pkgPath, "utf8")) : {};

if (plugin.version !== pkg.version) {
  error(`.claude-plugin/plugin.json version (${plugin.version}) does not match package.json version (${pkg.version})`);
}

const pluginSkills = new Set(Array.isArray(plugin.skills) ? plugin.skills : []);
for (const relPath of pluginSkills) {
  const absPath = path.join(repo, relPath, "SKILL.md");
  if (!fs.existsSync(absPath)) {
    error(`.claude-plugin/plugin.json references "${relPath}", but ${relPath}/SKILL.md does not exist`);
  }
}

const skillFiles = findSkillFiles(path.join(repo, "skills")).sort();
const namePattern = /^[a-z0-9]+(-[a-z0-9]+)*$/;
const allowedFrontmatterKeys = new Set([
  "name",
  "description",
  "license",
  "compatibility",
  "metadata",
  "allowed-tools",
  "disable-model-invocation",
]);

for (const skillFile of skillFiles) {
  const skillDir = path.dirname(skillFile);
  const relDir = "./" + path.relative(repo, skillDir).split(path.sep).join("/");
  const dirName = path.basename(skillDir);
  const bucketName = path.basename(path.dirname(skillDir));
  const content = fs.readFileSync(skillFile, "utf8");
  const lines = content.split(/\r?\n/);

  // Progressive disclosure check (< 500 lines recommended by agentskills.io/specification)
  if (lines.length > 500) {
    warn(`${relDir}/SKILL.md is ${lines.length} lines (Agent Skills spec recommends < 500 lines)`);
  }

  const fm = parseFrontmatter(content);
  if (!fm) {
    error(`${relDir}/SKILL.md is missing valid YAML frontmatter (--- ... ---)`);
    continue;
  }

  for (const key of Object.keys(fm)) {
    if (!allowedFrontmatterKeys.has(key)) {
      warn(`${relDir}/SKILL.md has non-standard frontmatter field "${key}"`);
    }
  }

  // Validate 'name' field
  const name = fm.name;
  if (!name) {
    error(`${relDir}/SKILL.md is missing required frontmatter field "name"`);
  } else {
    if (name.length < 1 || name.length > 64) {
      error(`${relDir}/SKILL.md "name" must be 1-64 characters (got ${name.length})`);
    }
    if (!namePattern.test(name)) {
      error(
        `${relDir}/SKILL.md "name" ("${name}") violates spec: must be lowercase alphanumeric and single hyphens only, no leading/trailing/consecutive hyphens`
      );
    }
    if (name !== dirName) {
      error(`${relDir}/SKILL.md "name" ("${name}") must match parent directory name ("${dirName}")`);
    }
  }

  // Validate 'description' field
  const description = fm.description;
  if (!description || description.length === 0) {
    error(`${relDir}/SKILL.md is missing required non-empty frontmatter field "description"`);
  } else if (description.length > 1024) {
    error(`${relDir}/SKILL.md "description" exceeds 1024 characters (got ${description.length})`);
  }

  // Validate 'compatibility' field if present
  if (fm.compatibility !== undefined) {
    if (fm.compatibility.length < 1 || fm.compatibility.length > 500) {
      error(`${relDir}/SKILL.md "compatibility" must be 1-500 characters when provided`);
    }
  }

  // Validate agents/openai.yaml sync
  const openaiYamlPath = path.join(skillDir, "agents", "openai.yaml");
  const isUserInvoked = fm["disable-model-invocation"] === "true";
  if (!fs.existsSync(openaiYamlPath)) {
    error(`${relDir} is missing agents/openai.yaml`);
  } else {
    const yamlContent = fs.readFileSync(openaiYamlPath, "utf8");
    const hasDisableImplicit = /allow_implicit_invocation\s*:\s*false/.test(yamlContent);
    if (isUserInvoked && !hasDisableImplicit) {
      error(
        `${relDir}/SKILL.md sets disable-model-invocation: true, but ${relDir}/agents/openai.yaml is missing policy.allow_implicit_invocation: false`
      );
    }
    if (!isUserInvoked && hasDisableImplicit) {
      error(
        `${relDir}/agents/openai.yaml sets allow_implicit_invocation: false, but ${relDir}/SKILL.md is missing disable-model-invocation: true`
      );
    }
  }

  // Promoted vs non-promoted bucket invariants
  const isPromoted = bucketName === "engineering" || bucketName === "productivity";
  if (isPromoted) {
    if (!pluginSkills.has(relDir)) {
      error(`Promoted skill ${relDir} is missing from .claude-plugin/plugin.json "skills" array`);
    }
    const docsPage = path.join(repo, "docs", bucketName, `${dirName}.md`);
    if (!fs.existsSync(docsPage)) {
      error(`Promoted skill ${relDir} is missing human-facing docs page at docs/${bucketName}/${dirName}.md`);
    }
  } else {
    if (pluginSkills.has(relDir)) {
      error(`Non-promoted skill ${relDir} (bucket "${bucketName}") must not appear in .claude-plugin/plugin.json`);
    }
  }
}

if (errors > 0) {
  console.error(`\nValidation failed with ${errors} error(s) and ${warnings} warning(s).`);
  process.exit(1);
} else {
  console.log(`Validated ${skillFiles.length} skill(s) successfully (${warnings} warning(s)).`);
}
NODE_SCRIPT
