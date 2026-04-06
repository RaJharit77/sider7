-- Module to prevent the game from connecting to network
-- Also, skips LiveUpdate before exhibition matches
-- by Hawke, zlac and juce

local strings = {
    "pes21-x64-gate.cs.konami.net",
    "pes21-x64-stun.cs.konami.net",
}
local replacer = "0.0.0.0"
local content_root = ".\\content\\netblock\\"
local block_check = true

local m = {}
m.version = "0.3"

function m.make_key(ctx, filename)
    if string.match(filename, "common\\script\\flow\\Exhibition\\ExhibiUgcCheck.json") then
        return content_root .. filename
    elseif block_check and string.match(filename, "common\\script\\flow\\Intro\\DataPackApply\\ProcEnd.json") then --log("Invalid filename: " .. tostring(filename))
        block_check = false
        return content_root .. filename
    end
end

function m.get_filepath(ctx, filename, key)
    if key then
        return key
    end
end

function m.init(ctx)
    log("version " .. m.version)
    if content_root:sub(1, 1) == "." then
        content_root = ctx.sider_dir .. content_root
    end

    ctx.register("livecpk_get_filepath", m.get_filepath)
    ctx.register("livecpk_make_key", m.make_key)

    for _, s in ipairs(strings) do
        addr, info = memory.search_process(s .. "\x00")
        if not addr then
            log(string.format('warning: unable to find string: "%s" in memory', s))
        else
            log(string.format('string "%s" found at %s. Replacing with "%s"', s, memory.hex(addr), replacer))
            memory.write(addr, replacer .. string.rep("\x00", #s - #replacer > 0 and #s - #replacer or 0))
        end
    end
end

return m
