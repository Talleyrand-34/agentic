# Vendor Capability Matrix

This document records what each vendor supports so adapter authors know what is possible.

## File Format Support

| Feature | Claude | Copilot | Codex | Gemini |
|---|---|---|---|---|
| Reads AGENTS.md natively | Yes (also CLAUDE.md) | No | Yes | No |
| Custom instructions file | CLAUDE.md | `.github/copilot-instructions.md` | AGENTS.md | `.gemini/systemPrompt.md` |
| Per-file scoping (glob) | No | Yes (`.github/instructions/*.instructions.md`) | No | No |
| Multiple rules files | Yes (`.claude/` dir) | Yes (`.github/instructions/`) | No | No |
| Skills / slash commands | Yes (`.claude/skills/`) | No | No | No |

## Context Window and Limits

| Limit | Claude | Copilot | Codex | Gemini |
|---|---|---|---|---|
| Instruction file size limit | ~200KB practical | ~64KB practical | ~32KB | ~32KB |
| Hard per-file char limit | None documented | None documented | None documented | None documented |
| Notes | Reads multiple files; total context is shared with conversation | Content prepended to every request | Reads AGENTS.md hierarchically | Reads systemPrompt.md once per session |

## Section Type Support

| Section | Claude | Copilot | Codex | Gemini |
|---|---|---|---|---|
| Git conventions | Yes | Yes | Yes | Yes |
| Language rules | Yes | Yes | Yes | Yes |
| Architecture rules | Yes | Yes | Yes | Yes |
| Practice rules | Yes | Yes | Yes | Yes |
| Build/test commands | Yes | Yes | Yes | Yes |
| Skills (native) | Yes | No* | No* | No* |
| Glob-scoped rules | No† | Yes | No | No |
| Domain context | Yes | Yes | Yes | Yes |

`*` Injected as prompt text for non-Claude vendors
`†` Claude Code applies rules globally; scoping is via tool configuration

## Deployment Artifacts per Vendor

### Claude
- `AGENTS.md` (primary, read natively)
- `CLAUDE.md` (symlink or copy of AGENTS.md for backward compatibility)
- `.claude/skills/{skill-name}/` (skill directories)

### GitHub Copilot
- `.github/copilot-instructions.md` (global instructions, always applied)
- `.github/instructions/*.instructions.md` (glob-scoped instructions, optional)

### OpenAI Codex
- `AGENTS.md` (read natively, hierarchically from root and subdirectories)

### Gemini CLI
- `.gemini/systemPrompt.md` (loaded at session start)
- `GEMINI.md` (alternative location at project root)

## Update Log

| Date | Change |
|---|---|
| 2026-03-01 | Initial capability matrix created |
