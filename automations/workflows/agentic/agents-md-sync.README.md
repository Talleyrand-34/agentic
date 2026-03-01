# Workflow: agents-md-sync

**Category**: agentic
**Trigger**: GitHub webhook — push to `main`, paths `agents/**`, `profiles/**`
**Purpose**: Detects when fragments or profiles change in the library repo and opens pull
requests in registered downstream projects to sync the updated configuration.

## What It Does

1. Receives a GitHub push webhook when `agents/**` or `profiles/**` changes on `main`.
2. Reads the "project registry" node — a list of downstream repos and their profiles.
3. For each downstream repo, fetches `.agentic/config.yaml` to get the deployed library commit.
4. Compares deployed fragment SHAs against current library SHAs.
5. For repos with drift, triggers a GitHub Actions workflow dispatch that runs `just compose`
   and opens a PR with the updated files.
6. Posts a Slack summary of which projects were updated.

## Required Credentials (n8n)

| Credential name | Type | Purpose |
|---|---|---|
| `GITHUB_TOKEN` | GitHub OAuth2 / Personal Access Token | Read repos, create PRs, dispatch workflows |
| `SLACK_WEBHOOK_URL` | HTTP Header Auth | Post notifications |

## Environment Variables

See `agents-md-sync.env.example`.

## Project Registry Format

The workflow expects a "Project Registry" node with a JSON array:

```json
[
  {
    "repo": "org/my-service",
    "profile": "typescript-hexagonal-microservice",
    "branch": "main",
    "config_path": ".agentic/config.yaml"
  },
  {
    "repo": "org/another-service",
    "profile": "go-hexagonal-microservice",
    "branch": "main",
    "config_path": ".agentic/config.yaml"
  }
]
```

## Setup Steps

1. Import `agents-md-sync.workflow.json` into your n8n instance (once available).
2. Configure credentials in n8n Settings → Credentials.
3. Update the "Project Registry" node with your downstream repos.
4. Set up a GitHub webhook on this library repo pointing to the n8n webhook URL.
5. Activate the workflow.

## Notes

- The workflow does not auto-merge PRs. A human reviews and merges.
- If the downstream repo does not use this library (no `.agentic/config.yaml`), it is skipped.
- The n8n workflow JSON is not included yet — generate it from your n8n instance after setup.
