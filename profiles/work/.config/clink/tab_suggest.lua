-- Tab: IntelliSense-style dropdown completion when candidates exist,
-- or accept the next word of inline autosuggestion when no completion candidates exist.

function tab_suggest_or_complete(rl_buffer)
    local buf_before = rl_buffer:getbuffer()
    local cur_before = rl_buffer:getcursor()

    -- 1. Invoke interactive dropdown completion (clink-select-complete)
    rl.invokecommand("clink-select-complete")

    -- 2. If completion did not change the input line or cursor position
    -- (meaning there were no completion candidates to display or insert),
    -- accept the next word from the inline ghost-text suggestion.
    if rl_buffer:getbuffer() == buf_before and rl_buffer:getcursor() == cur_before then
        rl_buffer:insertsuggestion("word")
    end
end

rl.setbinding([["\t"]], [["luafunc:tab_suggest_or_complete"]])
