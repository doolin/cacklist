# Planning and recording execution

This file explains the guiding principles for planning work
which is complex, may require specific sequencing, and benefits
from incremental implementation.

## How to plan

- Use a template to create a plan.
- Create a short, descriptive name for the plan
- Store the plan in an appropriately name file in the `plans` directory.


## Plan Template

Use this as the body of a new file in `plans/`. Name the file with a
short **kebab-case** slug that matches the plan (for example
`add-password-reset.md`).

Agents and humans: read `AGENTS.md` and this directory when picking up a plan so expectations stay aligned.

```markdown
# <Title>

## Goal
One or two sentences: outcome and why we want it.

## Scope
- **In:** …
- **Out:** …

## Context
Links, related issues/commits, assumptions, or constraints.

## Steps
1. …
2. …
(Order matters when it does; otherwise a flat list is fine.)

## Definition of done
What “finished” means: tests, `./bin/rubocop`, CI, manual checks, etc.

## Follow-ups
Optional: deferred work, open questions, or risks to track later.
```

