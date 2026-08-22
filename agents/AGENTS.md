# AGENTS

## Defaults

- Keep technical terms, identifiers, and code exact. Write "-" instead of the em dash "—".
- Host: Windows 11. Ryzen 9 5900HX, 64GB RAM, RTX 3070 8GB VRAM.
- Prefer tooling that is user-space, portable, per-project, self-contained, and offline-friendly. Assume no privileged installer, no kernel features, no avoidable online service.
- Keep code portable across paths, shells, signals, permissions, file locks, and line endings.
- Pick stacks for environment and deployment constraints first, and for speed, performance, scaling, or refactoring second.

## Output

Two lanes. Compress the loop, not the answer.

- Agentic loop - internal reasoning, subagent prompts, handoffs, tool plans: maximum compression, id-keyed data over prose, no narration or restatement. Keep code, commands, identifiers, paths, and safety-critical steps exact and uncompressed.
- Final answer to the user: TLDR first, plain human words, short.
- Lead with the answer or the next executable action. Reasoning goes below it, and only when it changes what to do.
- Plain terms over jargon; expand an acronym on first use. No AI tells: `delve`, `landscape`, `interplay`, `tapestry`, `serves as`, `not just X but Y`, forced groups of three, and closing paragraphs that restate what was just said.
- Cap the answer near 200 words unless asked to go deeper. Cap lists at 5 items and split or link the rest.
- Number multi-step work and end with one line of state: what is done, what is next. Attention will be lost mid-task, so the thread must be resumable from that line alone.
- State errors matter-of-factly: cause, fix, current state. No apology preamble, no alarm.

## Tooling And Dependencies

- Go through the project runner, never a bare interpreter: Python `uv run python <script.py>` / `uv run -m <module>` / `uv run pytest`; JS/TS `bun`, then `pnpm`, then `npm`; Rust `cargo`. Avoid `npx`/`bunx` for tools that may fetch remotely.
- New deps and tools: exact-pinned; reusable CLIs as devDependencies; run via package scripts or local binaries.
- Install with `--ignore-scripts` unless lifecycle scripts are reviewed and needed. Keep production secrets, cloud creds, and keyrings out of reach of third-party code, tests, and binaries.

## App, CLI, And Automation

- Core: minimal, modular, headless, hackable - easy to drive from other tools and to embed in other apps. UX: clear, responsive, accessible, professional.
- CLI and automation: non-interactive by default, explicit args and exit codes, compact structured output, stable entry points, predictable side effects, concise operator docs. Surface progress, logs, errors, and debug/latency/evaluation signals when useful.
- Prefer streaming, batching, and bounded memory; mind CPU, disk, and network; clean temp, cache, and log artifacts promptly, including data sent for remote processing - and note its security and ops tradeoffs.

## Technical Decisions And Quality

- Weight quality, simplicity, robustness, scalability, and long-term maintainability far above development cost.
- Fix a bug by first reproducing it E2E, as close to how a real user hits it as possible. Otherwise the fix targets the wrong cause.
- Fix lint errors, test failures, flakiness, and visibly-off UI on sight, whoever caused them. Hold E2E UI to pixel perfection.
- Make incremental, verifiable changes; keep working code and refactor it in place rather than rewriting wholesale.

## Subagents And Research

- Spawn research and codebase-exploration subagents on the cheapest current-generation model (e.g. `sonnet-5`, `gpt-5.6-luna`), reasoning effort matched to the task rather than maxed.
- Scope research to the last month of releases, news, papers, videos, posts, and projects; rank by traction (downloads, stars, views) and reputation (active maintainers, known authors, virality, sentiment).
- Present comparisons as a compact decision matrix: options as rows, criteria as columns.

## Docs, Git, And Code

- Update the README compact tree and Mermaid flow when structure or behavior changes.
- In long Markdown, put each full sentence on its own line, keeping normal Markdown structure otherwise.
- Commit messages: never add your agent name as co-author. Leave CHANGELOG.md and any file marked auto-generated to its generator.
