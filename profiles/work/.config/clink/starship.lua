if (clink.version_encoded or 0) < 10020030 then
  error("Starship requires a newer version of Clink; please upgrade to Clink v1.2.30 or later.")
end

local starship_prompt = clink.promptfilter(5)

-- Resolve starship binary dynamically from %USERPROFILE%\.local\bin or system PATH
local userprofile = os.getenv("USERPROFILE") or ""
local local_starship = userprofile .. "\\.local\\bin\\starship.exe"
local starship_exe = "starship"
local f_probe = io.open(local_starship, "r")
if f_probe then
  f_probe:close()
  starship_exe = '"' .. local_starship .. '"'
end

start_time = os.clock()
end_time = 0
curr_duration = 0
is_line_empty = true

local cached_prompt = nil
local last_dir = nil

clink.onbeginedit(function ()
  end_time = os.clock()
  if not is_line_empty then
    curr_duration = end_time - start_time
  end
end)

clink.onendedit(function (curr_line)
  if starship_precmd_user_func ~= nil then
    starship_precmd_user_func(curr_line)
  end
  start_time = os.clock()
  if string.len(string.gsub(curr_line, '^%s*(.-)%s*$', '%1')) == 0 then
    is_line_empty = true
  else
    is_line_empty = false
  end
end)

local function make_cmdline(subcmd)
  local keymap = tostring(rl.getvariable('keymap') or '')
  local status = tostring(os.geterrorlevel() or 0)
  local dur = tostring(math.floor((curr_duration or 0)*1000))
  local width = tostring(console.getwidth() or 80)
  return starship_exe.." "..subcmd
    .." --status="..status
    .." --cmd-duration="..dur
    .." --terminal-width="..width
    .." --keymap="..keymap
end

local function fetch_prompt_async()
  local f = io.popenyield(make_cmdline("prompt"))
  if f then
    local out = f:read("*a")
    f:close()
    return out
  end
  return nil
end

function starship_prompt:filter(prompt)
  if starship_preprompt_user_func ~= nil then
    starship_preprompt_user_func(prompt)
  end

  local cwd = os.getcwd()
  if last_dir ~= cwd then
    last_dir = cwd
    cached_prompt = nil
  end

  if clink.promptcoroutine then
    local new_prompt = clink.promptcoroutine(fetch_prompt_async)
    if new_prompt and new_prompt ~= "" then
      cached_prompt = new_prompt
      return new_prompt
    end
    if cached_prompt then
      return cached_prompt
    end
    -- Instant 0ms placeholder on new directory / first load while starship renders in background
    return "\n" .. cwd .. "> "
  end

  -- Synchronous fallback only if clink.promptcoroutine is unavailable
  local f = io.popen(make_cmdline("prompt"))
  if f then
    local out = f:read("*a")
    f:close()
    cached_prompt = out
    return out
  end

  return prompt
end

function starship_prompt:rightfilter(prompt)
  -- Disabled to avoid 750ms process creation overhead since right_format is unused
  return ""
end

if starship_transient_prompt_func ~= nil then
  function starship_prompt:transientfilter(prompt)
    return starship_transient_prompt_func(prompt)
  end
end

if starship_transient_rprompt_func ~= nil then
  function starship_prompt:transientrightfilter(prompt)
    return starship_transient_rprompt_func(prompt)
  end
end

local characterset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
local randomkey = ""
math.randomseed(os.time())
for i = 1, 16 do
  local rand = math.random(#characterset)
  randomkey = randomkey..string.sub(characterset, rand, rand)
end

os.setenv('STARSHIP_SHELL', 'cmd')
os.setenv('STARSHIP_SESSION_KEY', randomkey)
