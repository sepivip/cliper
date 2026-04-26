# CLAUDE.md

Guidance for Claude Code working in this repository.

## This repo is PUBLIC

`sepivip/cliper` is a **public** GitHub repository. Every commit, branch, and PR description is world-readable. Treat all output (commit messages, PR bodies, file contents) as published content.

- No secrets, tokens, env values, or internal infra notes in committed files.
- No personal info beyond what's already in `git log`.
- The repo is also a **fork of `averygan/reclip`**. This affects `gh` CLI defaults (see below).

## `gh` CLI — always pass `--repo sepivip/cliper`

Because this is a fork, `gh pr create` (and several other `gh pr` subcommands) default to opening PRs against the **parent fork** (`averygan/reclip`), not this repo. Always be explicit:

```bash
gh pr create --repo sepivip/cliper --base main ...
gh pr edit <num> --repo sepivip/cliper ...
gh pr merge <num> --repo sepivip/cliper ...
```

Never open PRs against `averygan/reclip` unless explicitly requested by the user.

## Branch policy

- Direct pushes to `main` are blocked by a permissions hook. Open a PR branch instead.
- Default merge style for this repo: GitHub UI / `gh pr merge` after Copilot review.

## Project skills

This repo ships its own Claude Code skill at `.claude/skills/upstream-audit/SKILL.md` for auditing divergence from upstream `averygan/reclip`. Invoke when the user asks to "audit upstream", "check purity", or "what should we port from reclip".

## Stack quick reference

- Python 3.12 + Flask + gunicorn (single-worker, gthread, 16 threads — single-worker is intentional, the in-memory `jobs` dict requires it)
- yt-dlp + ffmpeg for the actual downloading
- Optional Postgres logging via `db.py` (silent no-op if `DATABASE_URL` unset)
- Vanilla HTML/CSS/JS UI in `templates/index.html`, no build step

## Hardening surface (don't regress)

The upstream-audit skill enumerates the protected files/symbols in detail. Short version: `ALLOWED_DOMAINS`, `is_private_host`, `flask_limiter`, `MAX_*` caps, `verify_turnstile`, `cleanup_worker`, `download_semaphore`, `db.log_download`, single-worker gunicorn in Dockerfile.
