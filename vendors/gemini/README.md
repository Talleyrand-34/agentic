# Gemini Vendor Adapter

## How Gemini Reads Instructions

Gemini CLI loads agent instructions from:
1. `.gemini/systemPrompt.md` — loaded at session start as the system prompt
2. `GEMINI.md` at the project root — alternative location

This adapter generates `.gemini/systemPrompt.md`.

## Output Files

| File | Purpose |
|---|---|
| `.gemini/systemPrompt.md` | System prompt loaded by Gemini CLI |

## Notes

- Gemini does not support glob-scoped rules — all instructions are always-on.
- All sections from AGENTS.md are concatenated into the single system prompt file.
- Keep the system prompt focused — Gemini's context window is shared with the conversation.
- Skills are injected as descriptive text sections ("Available Workflows") within the system prompt.
- The `.gemini/` directory is gitignored by Gemini CLI's default `.gitignore` pattern —
  explicitly un-ignore `systemPrompt.md` in your project's `.gitignore` to commit it.
