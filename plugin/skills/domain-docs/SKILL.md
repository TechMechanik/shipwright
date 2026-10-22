---
name: domain-docs
description: Keep the project glossary (CONTEXT.md) and architecture decision records (docs/adr/) current. Use when a term is defined or disputed, when a hard-to-reverse decision is made, or when asked to record a decision.
---

# Domain docs

Layout and rules: `docs/agents/domain.md`.

## Glossary entry

Add or update a term in the right `CONTEXT.md` when a domain word gets a precise meaning, two words turn out to mean the same thing, or one word is used for two things.

```markdown
### Term
One or two sentences defining it in business language.
Not to be confused with: <near-synonym>, which means <...>.
Avoid: <words people use loosely for it>.
```

Keep entries alphabetical. Don't add implementation names (class names, tables) unless the business uses them too.

## Decision record

Write an ADR when a decision is hard to reverse, affects several repos or teams, or someone will later ask "why did we do it this way?". Not for routine choices.

File: `docs/adr/NNNN-short-title.md`, numbered after the highest existing one.

```markdown
# NNNN. Title in the active voice

Date: YYYY-MM-DD · Status: accepted | superseded by NNNN · Issue: #<n>

## Context
What forces the decision: constraints, facts, the problem.

## Decision
What we will do, stated plainly.

## Consequences
What becomes easier, what becomes harder, what we must now do or watch.

## Alternatives considered
Each option and the one-line reason it lost.
```

A decision that reverses an earlier ADR gets a new ADR; mark the old one "superseded by NNNN" rather than editing its content.

Put both changes in the same MR/PR as the work they describe, or in their own small MR when there's no code.
