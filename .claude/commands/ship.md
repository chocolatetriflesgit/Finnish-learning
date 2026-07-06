---
description: Ship this repo's changes straight to main and refresh the GitHub Pages site - no branches or PRs here (project override of the global /ship).
---

# /ship - Finnish learning (project override)

This repo is the deliberate exception to the global /ship golden rule. It is a solo learning project: every change is a generated worksheet or tutoring state, nothing needs review, and GitHub Pages publishes from `main`. So here, work ships **directly to main**. Narrate each step in plain English. Commit messages in **pure ASCII**.

## Steps

1. **Detect the remote**: `git remote get-url origin`. **STOP** if there is none - tell Malcolm to publish the repo once via GitHub Desktop (File -> Add local repository -> Publish repository), then rerun /ship.
2. **Sync first**: `git fetch origin` then `git rev-list --left-right --count origin/main...main`. If GitHub is ahead (LEFT > 0), run `git pull --rebase origin main` before committing. Normally this machine is the only writer, so expect `0  0`.
3. **Commit everything**: `git add -A`, then a why-first Conventional Commits message, e.g. `feat(worksheet): add 2026-07-07 practice (past-tense focus)`.
4. **Push**: `git push origin main` (`-u` the first time).
5. **Confirm**: GitHub Pages rebuilds in about a minute. Give Malcolm the front-door URL and, if a worksheet was added, its direct URL.

If a push is rejected (non-fast-forward), fetch and rebase once, then retry; anything stranger, stop and explain rather than improvising.
