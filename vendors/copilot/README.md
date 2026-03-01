# GitHub Copilot Vendor Adapter

## How Copilot Reads Instructions

GitHub Copilot reads custom instructions from:
1. `.github/copilot-instructions.md` — always applied, global instructions
2. `.github/instructions/*.instructions.md` — scoped by glob pattern via frontmatter

## Output Files

| File | Purpose |
|---|---|
| `.github/copilot-instructions.md` | Global instructions (base fragments, security, conventions) |
| `.github/instructions/typescript.instructions.md` | Applied only to `**/*.ts,**/*.tsx` |
| `.github/instructions/go.instructions.md` | Applied only to `**/*.go` |
| `.github/instructions/python.instructions.md` | Applied only to `**/*.py` |
| `.github/instructions/php.instructions.md` | Applied only to `**/*.php` |

## Skills

Copilot does not have a native skill/slash-command system. Skills from this library are injected
as descriptive text in `copilot-instructions.md` under a "Available Workflows" section.

## Notes

- Copilot reads both the repository-level and organization-level `copilot-instructions.md`.
  This adapter generates only the repository-level file.
- The `applyTo` frontmatter glob pattern is case-insensitive and uses gitignore-style matching.
- Keep `copilot-instructions.md` under 64KB for reliable behavior.
