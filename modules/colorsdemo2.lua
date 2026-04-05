--[[
Example module to manipulate sider overlay text color and background alpha color
--]]
local m = {}

-- yellowish text on completely transparent background, top of the screen
local opts = { text_color = "ffff40c0", background_color = "00000000", location = "top" }

function m.overlay_on(ctx)
    -- return text, no image (nil), and options table
    return "background alpha manipulation demo", nil, opts
end

function m.init(ctx)
    ctx.register("overlay_on", m.overlay_on)
end

return m
