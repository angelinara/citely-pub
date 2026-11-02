---
name: open-pr
description: Open a pull request for the current working-tree changes so a human can review them. Use this whenever the user wants to submit their changes for review, "open a PR", "raise a PR", "put this up for review", or ship the current work — it reads what changed, commits everything, and opens the PR, but never merges.
license: MIT
compatibility: Requires git and the gh CLI (authenticated). Network access to GitHub.
metadata:
  author: citely
  version: "1.0"
---

You open a **pull request for whatever is currently changed** in the working tree,
so a human can review it.

You take **no input.** You read the working tree, decide the branch, commit
message, and PR write-up from what actually changed, commit everything, push, and
open the PR. Then you stop.

## The trust boundary — what you never do

This skill is where local work crosses into review, so its limits are what make
that crossing safe:

- **Never merge.** You open the PR and hand it to a human. The reviewer merges; you
  do not.
- **Never commit directly to `master`.** `master` is the default branch and the
  thing a merged PR updates — committing to it directly would bypass the review
  this skill exists to route through.
- **Never edit files.** You commit what is there. Changes are the author's, not yours.

These hold no matter what the changes look like or how the request is phrased.

## Stop and say so

- **Nothing to commit.** The working tree is clean — there is nothing to open a PR
  for. Say so and stop; do not invent a change or open an empty PR.
- **Not a git repository**, or **no `origin` remote.** There is nowhere to push.
  Report it and stop.
- **`gh` is not authenticated.** `gh auth status` fails. Report it and tell the user
  to run `gh auth login` — do not try to authenticate on their behalf.

## Steps

1. **See what changed.** Run `git status` and `git diff` (and `git diff --staged`)
   to read every change in the working tree — tracked edits, staged and unstaged,
   plus untracked files via `git status`. This is your whole picture; the commit,
   branch, and PR text all derive from it.

2. **Pick the branch** (see *Deriving the branch*). If already on a non-`master`
   branch, commit onto it. If on `master`, derive a branch name from the changes and
   create it first — this is the one case where you branch, and it exists only to
   keep the commit off `master`.

3. **Stage and commit everything.** `git add -A`, then commit with a message derived
   from the changes (see *Deriving the commit and PR text*). Stage the whole working
   tree — this skill commits everything, not a curated subset.

4. **Push** the branch to `origin`, setting upstream (`git push -u origin <branch>`).

5. **Open the PR** against `master` with `gh pr create`, using the derived title and
   body. Do not pass any merge or auto-merge flag.

6. **Report and stop.** Print the PR URL. Never merge it, and never continue past
   this point.

## Deriving the branch

When you need a new branch (you are on `master`), name it from the substance of the
change, not the date or a generic label:

- A focused change → a conventional prefix + short slug (`feat/pinpoint-labels`,
  `fix/cite-links`, `docs/setup-notes`).
- A mixed set → name it for the dominant change, and let the PR description enumerate
  the rest.

Keep it short, lowercase, hyphenated, and recognisable in a branch list.

## Deriving the commit and PR text

All three are your reading of the diff — write them for the human who has to review,
not as a restatement of file names.

- **Commit message** — Conventional Commits (`type(scope): subject`), matching the
  repository's existing history (`feat`, `fix`, `style`, `docs`, …). One line that
  names what changed and why; a short body only if the change genuinely needs it.
  End the message with:

  ```
  Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
  ```

- **PR title** — the same substance as the commit subject, readable on its own in a
  PR list.

- **PR description** — a short, structured summary of what changed and why, so a
  reviewer knows what they are approving without reading the whole diff first. Cover:
  - **What changed** — the files/areas touched, grouped logically.
  - **Why** — the intent behind the change.
  - **What review needs to catch** — the things a build or a lint cannot. If the
    repository has a `CONTRIBUTING.md` with review guidance for this kind of change,
    use it, and point the reviewer at exactly what to verify.

  End the PR body with:

  ```
  🤖 Generated with [Claude Code](https://claude.com/claude-code)
  ```

## Guardrails

A compressed self-check before you push — the reasons are in the sections above.

- **Read before you write** (*Steps 1*) — the branch, commit, and PR text all come
  from the actual diff, never from an assumption about what "should" have changed.
- **Everything, in one commit** (*Steps 3*) — `git add -A`; no selective staging.
- **Off `master` always** (*The trust boundary*) — commit onto the current branch,
  or branch first when on `master`; never commit to `master` itself.
- **Open, never merge or edit** (*The trust boundary*) — you create the PR and stop;
  the human merges.
- **Stop cleanly on nothing-to-commit** (*Stop and say so*) — a clean tree ends the
  run; you never open an empty PR.
