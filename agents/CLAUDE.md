# CLAUDE

## Defaults

- Be terse: minimal plans, logs, docs, and answers; no filler, hedging, or repetition. Keep technical terms, identifiers, and code exact.
- Write "-" instead of the em dash "—".
- Host: Windows 11. Ryzen 9 5900HX, 64GB RAM, RTX 3070 8GB VRAM.
- Prefer tooling that is user-space, portable, per-project, self-contained, and offline-friendly. Assume no privileged installer, no kernel features, no avoidable online service.
- Keep code portable across paths, shells, signals, permissions, file locks, and line endings.
- Pick stacks for environment and deployment constraints first, and for speed, performance, scaling, or refactoring second.

## Tooling And Dependencies

- Python: `uv run python <script.py>`, `uv run -m <module>`, `uv run pytest`.
- JS/TS: `bun` first, then `pnpm`, then `npm` - `bun test`, `bun run build`, `bun dev`. Avoid `npx`/`bunx` for tools that may fetch remotely.
- Rust: `cargo check`, `cargo test`, `cargo build`.
- New deps and tools: exact-pinned; reusable CLIs as devDependencies; run via package scripts or local binaries.
- Install with `--ignore-scripts` unless lifecycle scripts are reviewed and needed. Keep production secrets, cloud creds, and keyrings out of reach of third-party code, tests, and binaries.

## App, CLI, And Automation

- Core: minimal, modular, headless, hackable - easy to drive from other tools and to embed in other apps.
- CLI and automation: non-interactive by default, explicit args, explicit exit codes, structured compact machine-readable output, stable entry points, predictable side effects, concise operator docs.
- Surface progress, structured logs, clear errors, and debug/latency/evaluation signals when useful.
- UX: clear, responsive, accessible, professional.
- Prefer streaming, batching, and bounded memory; mind CPU, disk, and network; clean temp, cache, and log artifacts promptly.
- Remote processing: keep data temporary, clean it promptly, and note the security and ops tradeoffs.

## Technical Decisions And Quality

- Weight quality, simplicity, robustness, scalability, and long-term maintainability far above development cost.
- Fix a bug by first reproducing it E2E, as close to how a real user hits it as possible. Otherwise the fix targets the wrong cause.
- Hold the UI to pixel perfection during E2E testing, and fix what clearly looks off even when it is unrelated to the current task.
- Hold the same bar for lint errors, test failures, and flaky tests: fix them on sight, whoever caused them.
- Make incremental, verifiable changes; keep working code and refactor it in place rather than rewriting wholesale.

## Docs, Git, And Code

- Update the README compact tree and Mermaid flow when structure or behavior changes.
- In long Markdown, put each full sentence on its own line, keeping normal Markdown structure otherwise.
- Commit messages: never add your agent name as co-author.
- Leave CHANGELOG.md and any file marked auto-generated to its generator.
