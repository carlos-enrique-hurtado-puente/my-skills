# Spec sources

The spec is optional and works the same in both modes. Follow the steps in order.

1. **File path.** If the spec is a path to a file (`.md`, `.txt`, etc.), read it directly. Paths may be relative to the repo root or contain spaces; strip surrounding quotes and read the file as one path. In local mode the spec file is context, not part of the diff: never report it as a changed file. `Spec source: file <path>`.
2. **URL.** Use any tool available in this session that can read that domain: a connector, an installed CLI, or a web fetch if the page is public. Choose by capability, not by name. `Spec source: <tool used> (<url>)`.
3. **Pasted text.** Text in the message that reads like a spec is used as is. `Spec source: pasted`.
4. **Could not read it** (no capable tool, no access, host does not resolve, file missing): say why in plain words (for example "this session has no tool that can read that site") and ask for the spec as markdown, either a file path or pasted text. Do this before any `BLOCKED`.
   - Local mode: the reason and the request go inside the single confirmation message (see `references/sources/local-git.md`).
   - GitHub mode: reply with that message and stop; the review does not start and there are no findings.
5. **The user does not provide it.** The review is `BLOCKED` (spec cause), unless the user explicitly confirms reviewing without it. Then the review is `COMPLETED` with `Spec reviewed: no` and `Spec source: none`.
6. **Never invent acceptance criteria**, not even "typical" ones for the ticket type or the diff.
7. **No spec given at all:** do not ask for one. Review continues with `Spec reviewed: no` and `Spec source: none`. GitHub mode gains no question.

When a spec was read, check every acceptance criterion against the implementation and set `Spec reviewed: yes`.
