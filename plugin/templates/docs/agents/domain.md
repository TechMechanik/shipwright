# Domain docs

The project's shared language and its big decisions live in two places. Read them before exploring code, naming things or proposing changes.

## Where they are

- **Glossary:** `CONTEXT.md` at the repo root. A repo with several bounded contexts has `CONTEXT-MAP.md` at the root instead, pointing to one `CONTEXT.md` per context; read the ones your change touches.
- **Decisions:** `docs/adr/NNNN-title.md`. In a multi-context repo, context-specific decisions sit next to that context's `CONTEXT.md`, and system-wide ones stay in `docs/adr/`.

Missing files are normal in a young repo. Don't stop or complain; `/domain-docs` creates them when the first term or decision needs recording.

## Speak the glossary

Issue titles, specs, branch names, test names and code identifiers use the glossary's terms, not synonyms it lists under "Avoid". If you need a concept the glossary doesn't have, either you are inventing language the business doesn't use (reconsider) or the glossary has a gap (add it with `/domain-docs`).

## Respect decisions

Before proposing something, check the ADRs for that area. If your proposal goes against one, say so up front: "Goes against ADR-0007 (orders are event-sourced) because …". Reversing a decision means a new ADR, agreed by a human, not a quiet change in code.
