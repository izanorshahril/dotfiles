# AGENTS

## Defaults

- Be concise and terse: minimal plans, logs, docs, and answers; no filler, hedging, or repetition; keep technical terms exact.
- Host: Windows 11, GPU RTX3070 8GB VRAM, CPU Ryzen 9 5900HX 64GB DDR4
- Prefer user-space, portable, per-project, self-contained, offline-friendly tooling.
- Avoid privileged installers, kernel features, avoidable online services, and OS-specific assumptions for paths, shells, signals, permissions, file locks, and line endings.
- Pick stacks for environment/deployment constraints before speed, performance, scaling, extension, or refactoring.
- Never use the em dash "—".
  Use plain dash "-" instead.

## Tooling And Dependencies

- Python: `uv run python <script.py>`, `uv run -m <module>`, `uv run pytest`.
- JS runtime/package manager: `bun`, then `pnpm`, then `npm`; avoid `npx`/`bunx` for tools that might fetch remotely.
- New direct deps/tools: exact-pinned; reusable CLIs as devDependencies; run via package scripts/local binaries.
- Use `--ignore-scripts` unless lifecycle scripts are reviewed/needed; isolate production secrets, cloud creds, and keyrings for third-party code/tests/binaries.

## App, CLI, And Automation

- Core: minimal, modular, headless, hackable, integrates easily with other tools, also other apps can integrate with it.
- Use CLI, web UI, or unattended automation as appropriate; keep UX clear, responsive, accessible, professional.
- CLI/automation: non-interactive use, explicit exit codes, machine-readable/structured compact output, stable entry points, explicit args, predictable side effects, concise operator docs.
- Remote processing: keep data temporary, clean promptly, note security/ops tradeoffs.

## Technical Decisions And Quality

- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would encounter it as possible.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.

## Docs, Ops, Git, And Code

- README changes: compact tree and Mermaid flow when structure/behavior changes.
- When writing or substantially editing long Markdown files, put each full sentence on its own line.
  Preserve normal Markdown structure, but avoid wrapping multiple sentences onto one physical line.
- When writing commit messages, NEVER auto-add your agent name as co-author.
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated.
- Prefer streaming, batching, bounded memory; mind CPU, disk, network; clean temp/cache/log artifacts promptly.
- Expose progress, structured logs, clear errors, exit status, debug/latency/evaluation signals when useful.
- Write modular, maintainable, testable, clearly named code; use incremental, verifiable changes for major rework.
- Avoid unnecessary complexity, hidden side effects, fragile assumptions, and wholesale rewrites of working code.

## Multi-Agent Workflows And Herdr Coordination

- Never perform multi-agent parallel work on the same dirty working tree.
  Use dedicated git worktrees (`gwt <branch>`).
- Context Injection: Check `$env:HERDR_WORKSPACE_ID`, `$env:HERDR_TAB_ID`, and `$env:HERDR_PANE_ID`.
- Targeting: When issuing Herdr CLI commands from an agent, always use `--current`, explicit pane IDs, or named agents (`herdr agent prompt <name> ...`).
- Lifecycle Awareness: Recognize settled states (`idle`, `done`, `blocked`).
  Do not loop or busy-wait.
