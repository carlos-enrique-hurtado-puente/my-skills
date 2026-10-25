# Sources

Tags: **primary** = the original author or the body that defines the practice; **vendor** = a tool vendor's study or benchmark, cited as support, not as a rule.

| Source | Tag | Used for |
|---|---|---|
| Wake, *INVEST in Good Stories, and SMART Tasks* (2003): https://xp123.com/invest-in-good-stories-and-smart-tasks/ | primary | Split question 1; SMART development sub-tasks |
| Jeffries, *Card, Conversation, Confirmation* (2001): https://ronjeffries.com/xprog/articles/expcardconversationconfirmation/ | primary | Story is a summary; detail stays in the spec |
| Lawrence, *The Humanizing Work Guide to Splitting User Stories*: https://www.humanizingwork.com/the-humanizing-work-guide-to-splitting-user-stories/ | primary | Split questions 1, 5, 6; layer splits as the exception |
| Cohn, SPIDR: https://www.mountaingoatsoftware.com/blog/five-simple-but-powerful-ways-to-split-user-stories | primary | Split question 5 (split by path or rule) |
| Cohn, five story-splitting mistakes: https://www.mountaingoatsoftware.com/blog/five-story-splitting-mistakes-and-how-to-stop-making-them | primary | Layer splits as the exception |
| DORA, loosely coupled teams: https://dora.dev/capabilities/loosely-coupled-teams/ | primary | Split questions 3 and 4 |
| DORA, working in small batches: https://dora.dev/capabilities/working-in-small-batches/ | primary | One sub-task ≈ one PR |
| LeSS case study (InfoQ): https://less.works/case-studies/infoq-network-gateway-less | primary | Split question 3 (feature vs component teams) |
| Visual Paradigm, stories across teams: https://skills.visual-paradigm.com/?p=1771 | vendor | Split question 2 |
| Google, small CLs: https://google.github.io/eng-practices/review/developer/small-cls.html | primary | One sub-task ≈ one PR |
| Google, CL descriptions: https://google.github.io/eng-practices/review/developer/cl-descriptions.html | primary | Development sub-task: what plus why |
| Google, what to look for in a code review: https://google.github.io/eng-practices/review/reviewer/looking-for.html | primary | Code review "pay attention to" |
| ISTQB test design (Foundation slides): https://www.ii.uib.no/%7Emagne/zinfh11-tekster/Kap4atestdesigntechniquesv2.04eng.pdf | primary | Certification table |
| SmartBear, code review best practices: https://smartbear.com/learn/code-review/best-practices-for-peer-code-review/ | vendor | Review size (200 to 400 lines) |
| LinearB benchmarks via LeadDev: https://leaddev.com/tech/workflow-metrics-make-elite-dev-teams | vendor | PR size of elite teams (about 105 lines) |

## Not verified

- The Scrum.org thread on splitting by API (the page came back empty).
- Wake's "a few person-weeks" size figure (secondary source only).

## Team evidence

The default of one story per spec, the PR as the unit of a development sub-task, and the newer-generation ticket content come from the source team's own specs and tickets (project ITV): ITV-878 and ITV-883 (newer generation), ITV-831 and ITV-835 (spec 42, split), ITV-804, ITV-809, ITV-813, ITV-781, ITV-551. All from one team.
