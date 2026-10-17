---
id: angular
name: Angular
detect:
  dependencies: ["@angular/core"]
  files: ["**/*.component.ts", "**/*.component.html", "angular.json"]
  imports: ["@angular/"]
skills: [angular-developer]
context_fields: [Angular version, Test framework]
---

## Context detection

Fill the `context_fields` from the owning root's `package.json` (the root that holds the changed Angular files); ask only when inference is impossible.

| Mode | How to read it |
|------|----------------|
| Local | `git show HEAD:<root>/package.json` |
| GitHub | `gh api "repos/{owner}/{repo}/contents/<root>/package.json?ref=<headRefName>" --jq .content \| base64 -d` |

- **Angular version:** `@angular/core` in `dependencies`. Judge the diff against what that version supports: `input()`/`output()`/`model()` need 17.1+, `linkedSignal`/`resource` need 19+. Never suggest an API the repo's version lacks.
- **Test framework:** `devDependencies` and the `test` script / `angular.json` builder (Karma + Jasmine, Jest, Vitest). Suggest tests in the project's framework.
- Also note, when visible: standalone vs NgModules, form strategy (typed reactive / template-driven), whether the repo has locales (i18n).

## Checklist

Mark areas the diff does not touch as N/A and skip them. Clean Code, Clean Architecture and PR hygiene live in the core criteria.

| Area | Look for |
|------|----------|
| Angular modern idioms | Standalone components, `inject()`, signal `input()/output()/model()`, `@if/@for/@switch` with `track`, `OnPush`, no `any` |
| Reactivity | `computed`/`linkedSignal` instead of duplicated state; `effect` misused for derived state; subscribes without cleanup (`takeUntilDestroyed`, `async` pipe); nested subscribes; RxJS polling/retry (`switchMap` cancelling slow requests, error handling); state read once or overwritten by a late response (races) |
| Templates | Logic or method calls in templates (incl. getters recomputed every change detection), `track $index` where items hold local state (use a stable id) |
| Security | `bypassSecurityTrust*`, `innerHTML` with user/API data, unescaped HTML built from strings, tokens/secrets in code, blob/file downloads |
| A11y | Labels, roles; custom `role="button"` handles Enter *and* Space (prefer native `<button>`); modals handle Escape, focus and discarding unsaved edits like the project's other modals; pickers/listboxes/comboboxes follow the ARIA pattern (valid child roles, option ids, `aria-activedescendant` when focus stays in another element, keyboard path for every mouse action) |
| Batch / destructive ops | Confirmation before delete, partial failure (`forkJoin` cancels the rest, empty array completes without emitting), shared `loading` flags reset on error and empty paths (`finalize`) |
| Forms / HTTP | Matches the project's form strategy; typed forms; loading, empty and error states handled (controls not usable with empty data after a failed load); no HTTP calls from components |
| Routing | Lazy loading, guards/resolvers as functions, no hard-coded URLs |
| Behavior / contract | Changed semantics (live data to snapshot, defaults sent when untouched), payload changes the backend must support, promises in docs/comments/PR text that the code does not enforce, forward compatibility with newer API data |
| i18n (if the repo has locales) | Same keys in every locale, no orphan keys, valid encoding (check new lines only; pre-existing issues are a `nitpick`; JSON may have a UTF-8 BOM) |
| Tests | New behavior and edge paths covered; assert behavior not implementation; a test for the bug the change says it fixes; no `fit`/`fdescribe`/skipped tests; new specs registered if the repo registers them manually |

Orphaned styles/templates left when a component is removed count as dead code (core Clean Code).

## How to use the skills

`angular-developer` is installed and model-invocable. Before judging idioms, open its reference file(s) for each area the diff touches:

| Diff touches | Reference file(s) |
|--------------|-------------------|
| `signal`/`computed`/`effect`/`linkedSignal`/`resource` | `signals-overview.md`, `effects.md`, `linked-signal.md`, `resource.md` |
| `input()`/`output()`/`model()` | `inputs.md`, `outputs.md` |
| Components, templates, host bindings, pipes | `components.md`, `host-elements.md`, `pipes.md` |
| `inject()`, services, providers | `di-fundamentals.md`, `creating-services.md`, `defining-providers.md`, `injection-context.md`, `hierarchical-injectors.md` |
| `HttpClient`, interceptors | `http-client.md` |
| Forms | `reactive-forms.md`, `template-driven-forms.md`, `signal-forms.md` |
| Routes, guards, resolvers, lazy loading, navigation | `define-routes.md`, `route-guards.md`, `data-resolvers.md`, `loading-strategies.md`, `navigate-to-routes.md` |
| ARIA, focus, keyboard handling | `angular-aria.md` |
| Component styles | `component-styling.md` |
| `.spec.ts`, e2e | `testing-fundamentals.md`, `component-harnesses.md`, `router-testing.md`, `e2e-testing.md` |

File names are relative to the `angular-developer` skill's `references/` folder. Open only the ones for areas the diff touches.

Skipping this is how idioms get missed. If the repo and a reference disagree (for example Vitest vs Karma), the repo's `package.json` and existing code win.

If `angular-developer` is not available in the session, say so in Limitations and review with this checklist only. List a consulted reference under the review's Commands.

## Clean Architecture in this stack

How the 7 rubric points look in Angular (examples, not new rules):
1. Business rules (pricing, totals, validation) run in a plain unit test, with no `TestBed`, component, `HttpClient` or router.
2. Domain and use-case code import nothing from `@angular/*`; components and services depend inward.
3. A use case works the same from a component, a route resolver or a test.
4. Data-access interfaces (abstract class or injection token) live with the use cases; `HttpClient` implementations live in an outer data layer.
5. API DTOs are mapped to domain models at the adapter; components never see raw backend shapes; environment/config read in one place.
6. No cycles between features; no deep imports into another feature's internals (only its public API).
7. One composition root (`app.config.ts` providers, route-level providers) wires implementations; components render and delegate.

Typical violations: business logic or `HttpClient` calls in a component; a feature importing another feature's private files; DTOs used directly in templates.

## Severity notes

Additional `blocking` cases for this stack: an evident subscription leak (a long-lived `subscribe` with no `takeUntilDestroyed`/`async` pipe/unsubscribe in a component or service that is destroyed and recreated); `fit`/`fdescribe` (or committed `.only`-style focus) that skips the suite; an unsanitized `innerHTML`/`bypassSecurityTrust*` with user or API data. Style, naming and architecture preferences stay non-blocking.

## Common mistakes

- Applying APIs or references the repo's Angular version or test framework lacks (for example `linkedSignal` on Angular 17, Vitest idioms in a Karma repo).
- Style nits while missing a subscription leak, a security issue or an undocumented behavior change.
- Asserting something about code outside the diff without reading the full file (false positive); turn it into a `question (non-blocking):` if unverifiable.
- Flagging `track $index` or a template method call without checking whether items hold local state or the call is trivial.
- Skipping the `angular-developer` reference for an area the diff touches.
