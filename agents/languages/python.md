## Python

### Version and Runtime

- Target Python 3.12+. Use `pyproject.toml` (not `setup.py`) for all project metadata.
- Use `uv` as the package manager and virtual environment tool (fastest, lockfile-based).
- Pin the Python version in `.python-version` (for pyenv/mise compatibility).

### Type Annotations

Always annotate function signatures and public APIs:

```python
def find_user(user_id: UserId) -> User | None:
    ...

async def transfer(
    from_account: AccountId,
    to_account: AccountId,
    amount: Money,
) -> None:
    ...
```

- Use `from __future__ import annotations` for forward references.
- Use `TypeAlias` for semantic type aliases: `UserId: TypeAlias = UUID`
- Use `Protocol` for structural typing (duck typing with type checking).
- Run `mypy --strict` in CI. Fix all type errors — do not use `# type: ignore` without a comment
  explaining why.

### Naming Conventions

| Construct | Convention |
|---|---|
| Variables, functions, modules | `snake_case` |
| Classes | `PascalCase` |
| Constants | `SCREAMING_SNAKE_CASE` |
| Private | prefix `_`: `_internal_helper` |
| Abstract base classes | `Abstract` prefix or `ABC` suffix |
| Test files | `test_*.py` |

### Project Structure

```
src/
└── {package_name}/
    ├── domain/          # Entities, value objects, exceptions, repository protocols
    ├── application/     # Use cases, command/query handlers
    ├── infrastructure/  # SQLAlchemy repos, HTTP clients, adapters
    └── ports/           # FastAPI/Django routers, CLI commands, event consumers
tests/
├── unit/
├── integration/
└── conftest.py
pyproject.toml
```

Always use `src/` layout to prevent import confusion between installed and development code.

### Error Handling

- Define custom exception classes in `domain/exceptions.py`.
- Use specific exceptions, not bare `Exception`.
- Use `contextlib.suppress` only for truly ignorable errors, with a comment why.
- Log exceptions with `logger.exception(...)` to capture the traceback automatically.

### Code Style

- Format with `ruff format`. Lint with `ruff check` (replaces flake8, isort, pyupgrade).
- Max line length: 100 characters.
- Use dataclasses or Pydantic models for structured data — avoid raw dicts in domain code.
- Prefer `pathlib.Path` over `os.path` for all file operations.
- Write `async` code consistently: don't mix sync/async in the same layer without justification.
