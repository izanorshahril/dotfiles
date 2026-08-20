# Agent Skills Audit

Review of every skill available to this environment, plus the global agent directives in `agents/CLAUDE.md`.

Reviewed on 2026-08-20.

This is a review only.
Nothing was installed, uninstalled, or edited as a result of it.

## Scope

Installed plugins, from `~/.claude/settings.json`:

- `mattpocock-skills@claude-plugins-official`
- `honey@greenpt` (`Green-PT/honey-for-devs`)
- `impeccable@impeccable` (`pbakaus/impeccable`)
- `i-have-adhd@i-have-adhd` (`ayghri/i-have-adhd`)

Local skill: `~/.claude/skills/no-mistakes`.

Candidate under evaluation: `backnotprop/pstack`, 23 skills and 21 principles.

Baseline directives: `agents/CLAUDE.md`, symlinked to `~/.claude/CLAUDE.md`.

## pstack packaging

pstack is Cursor-packaged, not Claude Code-packaged.

`.cursor-plugin/plugin.json` returns 200.
`.claude-plugin/marketplace.json` and `plugin.json` both return 404.

There is no plugin install path.
Adoption means copying individual `skills/<name>/SKILL.md` directories into `~/.claude/skills/`.

## Environment facts that drive the verdicts

Model `opus`, subagent model `sonnet`, effort `medium`.

Roughly 40 percent of the projects under `D:\Dev` are Python with uv, about 15 percent are Node, the rest are plain git repositories.
This alone disqualifies the TypeScript-specific pstack skills.

Recorded peak usage was 156M tokens in a single day.
Any skill that multiplies full attempts on Opus is expensive here.

## Legend

| Verdict | Meaning |
|---|---|
| EMBED | Fold the rule into `agents/CLAUDE.md` as one to three lines. Do not keep or install the skill file. |
| EXTRACT | Reverse direction. Delete these lines from `agents/CLAUDE.md`, the skill carries it better. |
| STAY | Keep installed and active as-is. |
| ADOPT | Install from pstack unchanged. |
| ADAPT | Install from pstack after the stated edits. |
| REMOVE | Uninstall, or never invoke if it cannot be uninstalled. |

Sources: `MP` mattpocock-skills, `H` honey, `IMP` impeccable, `ADHD` i-have-adhd, `NM` no-mistakes, `PS` pstack, `BI` Anthropic built-in, `CM` `agents/CLAUDE.md`.

## Matrix

| # | Skill or directive | Src | Verdict | Justification |
|---|---|---|---|---|
| 1 | `no-mistakes` | NM | STAY | Only push gate. Machine-readable TOON output matches the CLI output preference. Nothing overlaps it end-to-end. |
| 2 | `honey` core | H | STAY | Primary terseness enforcer. Owns the CLAUDE.md terse rule in practice. |
| 3 | `impeccable` | IMP | STAY | Sole frontend authority. No pstack overlap. Deepest skill installed. |
| 4 | `mattpocock:diagnosing-bugs` | MP | STAY | Owns the debug loop. Its presence is why four pstack skills below are redundant. |
| 5 | `mattpocock:tdd` | MP | STAY | Broader than pstack's, covering features and bugs plus integration tests. Wins the name collision. |
| 6 | `mattpocock:domain-modeling` | MP | STAY | Owns ubiquitous language and ADRs. Nothing else does. |
| 7 | `mattpocock:codebase-design` | MP | STAY | Deep-module vocabulary. Serves the modular, hackable, embeddable core rule. |
| 8 | `mattpocock:writing-for-agents` | MP | STAY | CLAUDE.md and skills are actively maintained here. Directly load-bearing. |
| 9 | `mattpocock:research` | MP | STAY | Primary-source research captured to a repo Markdown file. No overlap. |
| 10 | `mattpocock:grilling` | MP | STAY | Stress-tests plans. Counterweight to honey's bias toward doing less. |
| 11 | `mattpocock:resolving-merge-conflicts` | MP | STAY | Narrow, mechanical, zero overlap. |
| 12 | `mattpocock:prototype` | MP | STAY | Throwaway prototype to settle a design question. Absorbs pstack `exhaust-the-design-space`. |
| 13 | `honey-review` | H | STAY | Bloat and over-engineering axis only. Distinct from correctness review. |
| 14 | `honey-hive` | H | STAY | Context-compression delegation. Cheaper than pstack `arena` or `swarm` on Opus. |
| 15 | `honey-ccr` | H | STAY | Conditional. Real value on the Python log and scan tooling such as `augur` and `yt-research`. |
| 16 | `honey-loop` | H | STAY | Conditional. Only matters when a `/loop` is live, but then it matters a lot. |
| 17 | `honey-compress` | H | STAY, manual only | Useful once. Never let it auto-rewrite CLAUDE.md, which is hand-tuned. |
| 18 | `i-have-adhd` | ADHD | STAY, exclusive | `disable-model-invocation: true`, so it is opt-in. Never run concurrently with honey. See conflicts. |
| 19 | `claude-api` | BI | STAY | Mandatory-trigger reference. Prevents answering model and pricing questions from stale memory. |
| 20 | `/code-review` | BI | STAY | Correctness axis with an `ultra` multi-agent tier. Supersedes pstack `interrogate`. |
| 21 | `anthropic-skills:skill-creator` | BI | STAY | Pairs with `writing-for-agents`. Supersedes pstack `reflect` and `automate-me`. |
| 22 | `docx`, `pdf`, `pptx`, `xlsx`, `dataviz`, `artifact-*` | BI | STAY | Orthogonal output-format tooling. Zero interaction with any skill in this audit. |
| 23 | `update-config`, `keybindings-help`, `schedule`, `loop`, `run`, `init` | BI | STAY | Harness plumbing. No conflicts. |
| 24 | `blast-radius` | PS | ADOPT | Clean frontmatter, no Cursor dependencies. Only impact-radius analysis in the whole stack. |
| 25 | `create-verification-skill` | PS | ADOPT | Many repos with no scripted behavior proof. Generates what `no-mistakes` gates on. |
| 26 | `maintain-verification-skill` | PS | ADOPT | Mandatory companion to 25. Verification skills rot silently against the app. |
| 27 | `show-me-your-work` | PS | ADOPT | Committable TSV decision trail. Nothing else here produces an audit record. |
| 28 | `recall` | PS | ADAPT | High value across many projects. Hardcodes `~/.cursor/projects/.../agent-transcripts/*.jsonl`. Repoint to `~/.claude/projects/<slug>/*.jsonl` and fix the slug convention. |
| 29 | `figure-it-out` | PS | ADAPT | Genuinely additive playbook designer. Strip the poteto-mode registry references so it stands alone. |
| 30 | `swarm` | PS | ADAPT | Parallel slices with an aggregated report. Replace the grok, sol, and fable routing with `sonnet` per `CLAUDE_CODE_SUBAGENT_MODEL`. |
| 31 | `how` | PS | ADAPT | Subsystem walkthrough. Add an explicit clause suspending honey and ADHD for its output, or it fights the terseness layers. |
| 32 | `why` | PS | ADAPT | Design-rationale archaeology, which git history genuinely cannot answer. Same suspension clause as 31. |
| 33 | `unslop`, blocklist only | PS | EMBED | Three lines. The `-` rule already exists; add the banned-vocabulary list. The full skill is a fourth always-on style authority. |
| 34 | `no-comments` | PS | EMBED | One line. Cheaper than a skill plus a subagent spawn. |
| 35 | `principle-prove-it-works` | PS | EMBED | One line strengthening the existing E2E rule to verify against the real artifact, never a self-report. |
| 36 | `principle-guard-the-context-window` | PS | EMBED | One line. `honey-hive` is model-invoked and skippable; CLAUDE.md always loads. |
| 37 | ADHD rules 1 and 8 | ADHD | EMBED | The two rules that do not conflict with honey. Makes them unconditional without running ADHD mode. |
| 38 | CM: `UX: clear, responsive, accessible, professional.` | CM | EXTRACT | `impeccable` auto-triggers on every frontend task and covers this far deeper. Dead weight on the other 90 percent of turns. |
| 39 | CM: pixel perfection during E2E testing | CM | EXTRACT | Belongs to `impeccable` and the adopted verification skills, not an always-loaded global file. |
| 40 | CM: `Be terse...` | CM | KEEP | Do not extract. `honey` is model-invoked and can fail to trigger. This is the guaranteed floor. |
| 41 | CM: Tooling and Dependencies section | CM | KEEP | Highest-value block in the file. No skill in any of the four repos covers dependency hygiene. |
| 42 | CM: README compact tree and Mermaid | CM | KEEP | Nothing covers it. pstack `technical-writing` is a different standard entirely. |
| 43 | `honey-design` | H | REMOVE | Direct conflict with `impeccable`. Both auto-trigger on frontend work and pull opposite ways. |
| 44 | `honey-memory` | H | REMOVE | Second memory system alongside the harness memory directory and CLAUDE.md. Three stores means none stays authoritative. |
| 45 | `honey-chat` | H | REMOVE | Built for claude.ai Projects and Styles. Inert inside Claude Code. |
| 46 | `honey-px` | H | REMOVE | Explicitly Fable-class readers only. This environment runs `opus`. Cannot fire correctly. |
| 47 | `honey-superpowers` | H | REMOVE | Only applies to Superpowers-style orchestration, which is not in use. |
| 48 | `honey-eco` | H | REMOVE | Reports modelled CO2 and savings. No effect on code quality, which CLAUDE.md ranks far above cost. |
| 49 | `honey-gain` | H | REMOVE | Benchmark scoreboard for the plugin itself. Marketing surface, not tooling. |
| 50 | `mattpocock:code-review` | MP | REMOVE | Its Standards axis needs documented repo standards that do not exist here; its Spec axis needs an issue. Six review paths is too many. |
| 51 | `mattpocock:wizard` | MP | REMOVE | Generates interactive bash wizards for third-party dashboards. Fights the non-interactive, offline, and user-space constraints on three axes. |
| 52 | `/simplify` | BI | REMOVE, never invoke | Strict subset of `honey-review`, which also reports the line count each cut saves. |
| 53 | `poteto-mode` | PS | REMOVE | Hard dependencies on Graphite, `cursor-team-kit`, `.cursor` paths, and non-Anthropic model ids. It routes the other 22 skills, so it breaks as a stub. |
| 54 | `setup-pstack` | PS | REMOVE | Configures Cursor per-role model routing. Meaningless in Claude Code. |
| 55 | `automate-me` | PS | REMOVE | Needs Cursor work history. Harder to port than `recall`, and `skill-creator` already covers the output. |
| 56 | `reflect` | PS | REMOVE | Same Cursor transcript dependency. Superseded by `skill-creator` and `writing-for-agents`. |
| 57 | `interrogate` | PS | REMOVE | Needs several different vendors' models to attack a diff. Claude-only subagents give a worse `/code-review ultra`. |
| 58 | `tdd` | PS | REMOVE | Hard name collision with `mattpocock:tdd`, and narrower at bug-fix only. |
| 59 | `arena` | PS | REMOVE | N parallel full attempts on Opus. Recorded peak was already 156M tokens in one day. |
| 60 | `teach` | PS | REMOVE | Explanatory mode is the direct inverse of three terseness layers. `how` and `why` cover the real need. |
| 61 | `architect` | PS | REMOVE | Substantially `mattpocock:codebase-design` with less depth. |
| 62 | `technical-writing` | PS | REMOVE | Diataxis plus Google plus STE plus Global English is a fourth writing-style authority. Parts conflict with the existing Markdown rules. |
| 63 | `bro` | PS | REMOVE | Plain-language restatement. Harmless, but three installed skills exist to make restatement unnecessary. |
| 64 | `typescript-best-practices` | PS | REMOVE | Node is a minority of the project set. Python with uv dominates. Wrong language. |
| 65 | `principle-laziness-protocol` | PS | REMOVE | `honey` core is the same YAGNI and deletion bias, already resident. |
| 66 | `principle-subtract-before-you-add` | PS | REMOVE | Covered twice, by `honey` core and `honey-review`. |
| 67 | `principle-minimize-reader-load` | PS | REMOVE | Covered by `honey` and ADHD rule 5. |
| 68 | `principle-fix-root-causes` | PS | REMOVE | Near-verbatim duplicate of the CLAUDE.md E2E reproduction rule. |
| 69 | `principle-sequence-verifiable-units` | PS | REMOVE | Duplicate of the CLAUDE.md incremental, verifiable changes rule. |
| 70 | `principle-build-the-lever` | PS | REMOVE | `honey` uses the identical lever ladder metaphor and ranks it. |
| 71 | `principle-experience-first` | PS | REMOVE | `impeccable` owns user delight over implementation convenience. |
| 72 | `principle-model-the-domain` | PS | REMOVE | `mattpocock:domain-modeling`, which also maintains the artifact. |
| 73 | `principle-foundational-thinking` | PS | REMOVE | Core types and data structures are domain-modeling's opening move. |
| 74 | `principle-type-system-discipline` | PS | REMOVE | `mattpocock:codebase-design`. Also mostly a TypeScript argument, the wrong language here. |
| 75 | `principle-exhaust-the-design-space` | PS | REMOVE | `mattpocock:prototype` does the competing prototypes concretely. |
| 76 | `principle-encode-lessons-in-structure` | PS | REMOVE | The `no-mistakes` lint, test, and CI gates are the enforcement mechanism this principle asks for. |
| 77 | `principle-never-block-on-the-human` | PS | REMOVE | Conflicts with the harness. Proceeding and letting the human correct afterward pushes against confirm-before-irreversible on git and deploy. |
| 78 | `principle-redesign-from-first-principles` | PS | REMOVE | Contradicts CLAUDE.md, which requires refactoring working code in place rather than rewriting wholesale. |
| 79 | `principle-outcome-oriented-execution` | PS | REMOVE | Phase-boundary discipline for large migrations. No trigger condition, so it is an always-on context tax. |
| 80 | `principle-boundary-discipline` | PS | REMOVE | Generic guidance with no trigger. Read once as prose. |
| 81 | `principle-make-operations-idempotent` | PS | REMOVE | Real principle, but a resident file that never fires is pure cost. |
| 82 | `principle-migrate-callers-then-delete-legacy-apis` | PS | REMOVE | Same. |
| 83 | `principle-separate-before-serializing-shared-state` | PS | REMOVE | Same, and concurrency-specific, which is rare across this project set. |

## Proposed CLAUDE.md delta

Net effect is two lines out and six lines in.

Remove, per rows 38 and 39:

- `UX: clear, responsive, accessible, professional.`
- `Hold the UI to pixel perfection during E2E testing, and fix what clearly looks off even when it is unrelated to the current task.`

Add, per rows 33 to 37:

- Banned AI vocabulary: `delve`, `landscape`, `interplay`, `serves as`, `not just X but Y`, forced threes.
- No explanatory comments unless the code cannot express the intent.
- Verify against the real artifact, never a proxy or a self-report.
- Route bulk reads to subagents and keep only summaries in the main thread.
- Lead every response with the executable action, not context.
- State error cause and fix directly. No "uh oh", no "there seems to be".

## Conflicts worth acting on

### honey-design against impeccable

Both auto-trigger on any HTML or CSS work and pull in opposite directions.
`honey-design` compresses how the design is written.
`impeccable` maximizes craft and iterates in a live browser.
Whichever loads first shapes the output, so results are nondeterministic across sessions.
Disable `honey-design`.

### i-have-adhd against honey

ADHD rule 2 wants numbered lists, rule 9 caps them at five, and rule 5 restates state every turn.
Honey strips exactly that scaffolding as narration.
ADHD is `disable-model-invocation: true`, so it only runs when invoked, which makes this manageable.
Treat them as mutually exclusive modes and say "stop adhd mode" before returning to honey-governed work.
Embedding ADHD rules 1 and 8 into CLAUDE.md, per row 37, keeps the non-conflicting half permanently.

### unslop would make it a three-way conflict

`unslop` frontmatter is `description: Cut AI tells from any writing. Must always apply.` with no `disable-model-invocation`.
It is designed to be permanently resident alongside honey, ADHD, and CLAUDE.md.
Its rule to convert inline-header lists to prose contradicts ADHD rules 2 and 9.
Its rule to add human voice through opinions, rhythm variation, and controlled imperfection contradicts honey outright.
Its em-dash ban agrees with CLAUDE.md, which is the one part worth keeping.
This is why row 33 embeds the blocklist rather than adopting the skill.

### Review-skill pileup

Adopting pstack wholesale would give eight review paths: `no-mistakes`, `mattpocock:code-review`, `honey-review`, `/code-review`, `/simplify`, `interrogate`, `no-comments`, and `blast-radius`.
Trigger selection becomes unreliable well before that.
The matrix keeps four: `no-mistakes` as the gate, `/code-review` for correctness, `honey-review` for bloat, and `blast-radius` for impact.

## Method and caveats

pstack skill inventory came from the repository tree and the README skill and principle tables.

Full `SKILL.md` text was read for four skills only: `poteto-mode`, `recall`, `blast-radius`, and `unslop`.

Rows 65 to 83 rest on the README one-line descriptions plus the overlap analysis, not on each principle file's body.

Packaging claims were verified by HTTP status against `raw.githubusercontent.com`.

`disable-model-invocation` is a Cursor frontmatter field.
Claude Code ignores it, so any adopted pstack skill carrying it will auto-trigger rather than staying invocation-only.
