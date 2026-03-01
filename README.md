# agentic

A centralized, vendor-agnostic library of agentic configurations.

## Mental Model

This repo is to agentic configs what a design system is to UI components —
a library you **compose from**, not use directly.

Fragments from this repo are assembled into a single `AGENTS.md` and deployed
into target project repositories. Vendor-specific files (CLAUDE.md, Copilot
instructions, Cursor rules, Gemini system prompts) are generated from that
canonical `AGENTS.md` and never edited manually.

```
agentic/ (this repo)
    agents/languages/typescript.md  ─┐
    agents/architecture/hexagonal.md ─┤──► compose ──► AGENTS.md ──► vendor-gen ──► target-project/
    agents/practices/tdd.md         ─┘                                              ├── AGENTS.md
                                                                                    ├── CLAUDE.md
                                                                                    ├── .github/copilot-instructions.md
                                                                                    ├── .cursor/rules/
                                                                                    └── .gemini/systemPrompt.md
```

## Structure

| Directory | Purpose |
|---|---|
| `agents/base/` | Universal fragments, always included |
| `agents/languages/` | Language-specific rules (TypeScript, Go, Python, PHP) |
| `agents/frameworks/` | Framework-specific rules |
| `agents/architecture/` | Architectural patterns (Hexagonal, DDD, CQRS, BFF, ...) |
| `agents/practices/` | Cross-cutting practices (TDD, API design, observability) |
| `agents/domains/` | Business-domain context (fintech, healthcare, saas) |
| `skills/` | Reusable agent skill definitions |
| `automations/` | n8n workflow exports and templates |
| `vendors/` | Vendor adapter configs and output templates |
| `profiles/` | Named composition presets (YAML) |
| `tooling/` | Assembly scripts (called via `just`) |
| `schemas/` | JSON Schemas for all structured files |
| `index/` | Auto-generated searchable indexes |

## Prerequisites

- [just](https://github.com/casey/just) — command runner (`brew install just`)
- bash (macOS system `/bin/bash` 3.2+ works — no extra install needed)
- [yq](https://github.com/mikefarah/yq) — YAML processor (`brew install yq`)
- [jq](https://stedolan.github.io/jq/) — JSON processor (`brew install jq`)

## Quick Start

```bash
# List what's available
just list-profiles
just list-skills

# Compose AGENTS.md for a TypeScript hexagonal microservice project
just compose typescript-hexagonal-microservice /path/to/my-project

# Generate vendor files from the composed AGENTS.md
just vendor-gen /path/to/my-project

# Or do it all in one step
just deploy typescript-hexagonal-microservice /path/to/my-project

# Validate an assembled config
just validate /path/to/my-project

# Check if a project's config has drifted from the library
just sync-check /path/to/my-project
```

## Adding a New Fragment

1. Create `agents/{group}/{name}.md` — start with a single `## Heading`
2. Keep it self-contained (no cross-references, no hardcoded values)
3. Run `just index` to rebuild the fragment index
4. Add it to a profile or use it in a custom composition

## Adding a New Skill

1. Create `skills/{group}/{name}/SKILL.md` with valid frontmatter
2. Run `just index` to rebuild the skill index
3. Reference it by name when deploying: `just deploy PROFILE TARGET --skills name`

## Vendor Support

| Vendor | Native format | Adapter status |
|---|---|---|
| Claude (Claude Code) | `AGENTS.md` / `CLAUDE.md` | Supported |
| GitHub Copilot | `.github/copilot-instructions.md` | Supported |
| OpenAI Codex | `AGENTS.md` (native) | Supported (passthrough) |
| Gemini CLI | `.gemini/systemPrompt.md` | Supported |

## License

MIT
