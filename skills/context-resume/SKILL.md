---
name: context-resume
description: Bootstrap a fresh agent session from existing project artifacts.
argument-hint: "What were you working on? (optional — auto-detected from git if omitted)"
disable-model-invocation: true
---

# Context Resume

Bootstrap a fresh agent session by reading existing project artifacts so work can continue seamlessly after switching agents, hitting rate limits, or resuming interrupted work.

This skill is the *reading* counterpart to `/handoff`. `/handoff` is run by the outgoing agent to write a handoff doc. This skill is run by the incoming agent to read project artifacts and rebuild context from what already exists in the repo.

## Process

### 1. Determine Focus

If the user passed a task description argument, use it as the focus, then continue to step 2.

If no argument was given, do a lightweight scan:

```
test -f CONTEXT.md && sed -n '1,160p' CONTEXT.md || true
git log --oneline -10
git status --short
git branch --show-current
```

From this scan, infer what was recently being worked on. Present a one-paragraph summary to the user:

> "It looks like you were working on [inferred task] on branch [name]. Recent changes touch [files]. Is that right, or something else?"

Wait for confirmation, then proceed with the confirmed focus.

### 2. Identify Relevant Artifacts

Based on the focus, decide which artifacts to read. Use the priority list below — read until the context is sufficient, then stop.

**Always read (cheap, high-signal):**
- `CONTEXT.md` — domain language and project overview
- `README.md` — skill index, project philosophy, repo layout
- `AGENTS.md` or `CLAUDE.md` — project instructions

**Read when relevant to the focus:**
- `git diff HEAD~5` or `git diff main` — recent changes
- GitHub issues: `gh issue list --state open` and relevant issue bodies
- PRDs referenced in issues or in `docs/`
- `docs/adr/` — architectural decisions related to the focus area
- `.agents/rules/` — project rules related to the focus area
- Open or recent PRs: `gh pr list --state open`

**Skip when irrelevant:**
- Artifacts unrelated to the stated focus
- Rules and ADRs that don't touch the current work area

### 3. Read And Summarize

Read each identified artifact. Build a working summary in this order:

1. **Project identity**: name, stack, branch
2. **Domain language**: key terms from CONTEXT.md
3. **Current task**: what is being built, fixed, or discussed
4. **Recent progress**: last few commits and what they accomplished
5. **Decisions already made**: choices locked in, with rationale
6. **What's pending**: open questions, unfinished work, blockers
7. **Relevant code**: only files directly related to the current task

Do not dump entire files. Extract the sections that matter for the current focus.

### 4. Present And Confirm

Print a compact summary for the user:

```
## Session Context Loaded

**Project**: [name] ([stack]) — branch [name]
**Task**: [one sentence]
**Done so far**: [2-4 bullet points]
**Pending**: [1-3 bullet points or "none — ready for new tasks"]
**Key decisions**: [only if non-obvious]

Ready to continue. What do you need?
```

If the summary is wrong or incomplete, the user will correct it. Otherwise, the agent is now warmed up and ready to work.

### 5. Handle Missing Artifacts

If the project lacks CONTEXT.md or has minimal documentation:

- Fall back to `README.md` and git history alone
- Tell the user: "This repo has minimal context artifacts. Context resume relied on git history. Consider adding a CONTEXT.md for better session continuity."
- Do not fail — always produce some useful context

## Size Guidance

Target enough context for the agent to be productive on the stated task. If the summary exceeds ~1500 words, the focus is probably too broad — narrow it and suggest the user invoke again for each area.

## Done Means

- The agent understands the project domain, current task, and recent progress
- The user confirmed the summary or corrected it
- The agent can immediately take a useful next step without asking basic setup questions
- No artifacts were read that are irrelevant to the stated focus
