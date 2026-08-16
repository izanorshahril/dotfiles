# AGENTS.md — Principal Agentic Engineering Guidelines
# Optimized for Multi-Agent Workflows, Herdr Multiplexer, and Windows 11

## 1. Executive Philosophy (L8 Principal Mindset)
- **Terse & Exact**: Output minimal explanations, zero pleasantries, and exact technical terminology. Conserve context tokens.
- **Direct Action Over Discussion**: Plan concisely, make verifiable atomic edits, run tests, and report status.
- **Worktree Isolation**: Never perform multi-agent parallel work on the same dirty working tree. Use dedicated git worktrees (`gwt <branch>`).

## 2. Environment & System Rules (Windows 11)
- **Shell**: PowerShell 7 (`pwsh.exe`) with UTF-8 encoding. Avoid OS-specific unixisms unless inside WSL.
- **Tooling**:
  - Python: `uv run python <script.py>`, `uv run pytest`, `uv pip`.
  - Node / JS: `bun`, `pnpm`, `npm`. Never use remote `npx` when local dependencies exist.
  - Rust / CLI: `cargo`, `ripgrep` (`rg`), `fzf`.
- **Paths**: Always use platform-safe paths or forward slashes in tooling. Respect Windows line endings (`autocrlf = input`).

## 3. Multiplexer & Herdr Coordination
- **Context Injection**: Check `$env:HERDR_WORKSPACE_ID`, `$env:HERDR_TAB_ID`, and `$env:HERDR_PANE_ID`.
- **Targeting**: When issuing Herdr CLI commands from an agent, always use `--current`, explicit pane IDs, or named agents (`herdr agent prompt <name> ...`).
- **Lifecycle Awareness**: Recognize settled states (`idle`, `done`, `blocked`). Do not loop or busy-wait.

## 4. Code Quality & Verification Gates
- **Incremental & Verifiable**: Make focused changes with immediate test verification.
- **No Side-Effects**: Avoid altering unrelated configuration, dependencies, or formatting.
- **Verification First**: Always run the relevant test suite (`pytest`, `bun test`, `cargo test`) before signaling task completion.
