---
name: shape
description: Turn an idea or a vague request into a buildable spec by interviewing the human one question at a time, then write the spec into the issue. Use for `idea` and `needs-info` issues, a new phase whose scope is fuzzy, or when the human asks to think something through.
---

# Shape an idea

The goal is a spec an agent or developer can build without coming back with questions. Commands: the **Operations** table in `docs/agents/issue-tracker.md`; vocabulary: `CONTEXT.md` (see `docs/agents/domain.md`).

1. **Ground yourself first.** Read the issue and its comments, the glossary, ADRs touching the area, and only the code needed to know what exists today. Never ask the human something the code or docs already answer.
2. **Interview.** One question per message, each with your recommended answer and the reason, so the human can reply "yes". Work from the biggest unknowns down:
   - the outcome and who it's for; what is explicitly out of scope
   - behaviour in the normal case, then edge cases and failure cases
   - data: what's stored, where it comes from, what changes shape
   - which repos and services it touches, and in what order they must change
   - how we'll know it works (tests, acceptance checks)
   - risks: security, data loss, performance, operations, rollback
   Push back on answers that contradict the glossary, an ADR or the code, and say which.
3. **Stop** when every item has an answer or is recorded as a deliberate open question. Ten good questions beat thirty.
4. **Write the spec** into the issue (`comment`, or the description for a new issue) under these headings: Outcome · Out of scope · Behaviour · Data · Repos and order · Acceptance criteria · Risks and rollback · Open questions · Decisions (each with its one-line reason).
5. **Update the domain docs** through `/domain-docs` for any new term or hard-to-reverse decision.
6. **Next step:** if the spec is one deliverable, label it `ready-for-agent` or `ready-for-human` (respecting who may set `ready-for-agent`) and size it. If it's bigger, run `/split-tickets`. Leave `idea` issues open until their tickets exist, then close them with a link to the tickets.
