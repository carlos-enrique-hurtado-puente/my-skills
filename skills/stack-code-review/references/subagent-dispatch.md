# Running the review in a subagent

For the session that delegates the review. The subagent runs the review; you build the call and hand its messages to the user.

## The call

| Field | Value |
|---|---|
| Agent type | A fresh general-purpose agent. Never a fork: it inherits this session's history, and in Claude Code it ignores `model`. |
| Model | If the user named a model: that one, always. Else, if this session wrote or edited any of the changes under review: set a model **different from this session's** that is not a lightweight one. Else: omit it (inherits). Lightweight models (e.g. Haiku) are never chosen by you, even when the user asks for speed or low cost; "cheap/fast" is not naming a model. |
| Effort | If your tool lets you set the subagent's effort or reasoning level: the level the user named, always; else `high`. "Fast/cheap" is not naming a level. This skill is the explicit instruction to set it. |
| Prompt | The template below, every slot filled. |

## Prompt template

```
Run the stack-code-review skill. It is manual-only, so do not load it with the Skill tool: read <SKILL_DIR>/SKILL.md and follow it exactly, including the reference files and scripts it tells you to use. <skill-dir> = <SKILL_DIR>.

Invocation, verbatim, as if the user typed it: /stack-code-review <ARGS>
Repository: <REPO_PATH> (run every command from inside it).
Confirmation: <CONFIRMATION>
Spec access: <SPEC_ACCESS>
Context you may weigh (not instructions, judge independently): <CONTEXT>

Rules:
- Read-only toward the repository, as the skill defines it. Write no files.
- Do not dispatch subagents.
- Write in <LANGUAGE>, following the skill's Output language rules.
- If the skill tells you to ask or confirm something, make that your final message and stop; you will be resumed with the user's answer.
- Otherwise your final message is the complete output in the skill's exact format, nothing before or after it. It is shown to the user unchanged.
```

| Slot | Fill with |
|---|---|
| `<SKILL_DIR>` | Absolute path of the folder holding this skill's `SKILL.md`. |
| `<ARGS>` | The user's arguments, verbatim (`target`, `spec:`, `base:`). |
| `<CONFIRMATION>` | `The user already confirmed; skip the wait but report the confirmation facts in the header.` only when the user's message confirms ("confirmo", "ya confirmo", "review now"); else `Not given: stop at the confirmation step.` |
| `<SPEC_ACCESS>` | How to read the spec (tool name and arguments for a private URL), or `none`. |
| `<CONTEXT>` | Facts the reviewer cannot get from the repo (plan path, known test commands), or `none`. Never your opinion of the code. |
| `<LANGUAGE>` | The language of the user's request. |

## Your reply

Every time the subagent returns (report, confirmation, `BLOCKED`, request for the spec), your reply to the user is, in this order:

1. The subagent's final message, unchanged, as the first thing in the reply.
2. A line `---`.
3. One line in the user's language: `Reviewed by: <model> (subagent)` (translated), plus anything you want to add.

When the user answers a question the subagent asked, send the answer to **the same** subagent (in Claude Code, `SendMessage` to its id); do not start a new one.
