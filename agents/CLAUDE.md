# CLAUDE.md — Agent Directives for Claude Code & CLI Agents

## Build & Test Commands
- **Python**: `uv run pytest`, `uv run python main.py`
- **TypeScript / JavaScript**: `bun test`, `bun run build`, `bun dev`
- **Rust**: `cargo check`, `cargo test`, `cargo build`

## Code Guidelines
- **Strict Formatting**: Maintain existing indentation and code conventions.
- **Error Handling**: Fail fast with descriptive error messages; never swallow exceptions silently.
- **Git Safety**: Do not commit unreviewed changes or force push. Keep commits atomic.
- **Herdr Integration**: When executing long commands in background panes, inspect status via `herdr pane read` or standard output logs.
