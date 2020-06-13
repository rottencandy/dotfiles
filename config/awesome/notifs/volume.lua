local awful = require('awful')

local current_vol = -1
local current_muted = -1

local function emit_vol_info()
    awful.spawn.easy_async('pactl list sinks', function(output)
        local volume = tonumber(output:match('(%d+)%% /'))
        local muted = output:match('Mute:(%s+)[yes]') and true or false

        if current_vol ~= volume or current_muted ~= muted then
            awesome.emit_signal('notifs::volume', volume, muted)
            current_vol = volume
            current_muted = muted
        end
    end)
end

local vol_script = [[
 sh -c '
 pactl subscribe 2> /dev/null | rg --line-buffered sink
'
]]

-- Kill old instance
awful.spawn.easy_async_with_shell('pkill pactl', function()

    awful.spawn.with_line_callback(vol_script, {
            stdout = function()
                emit_vol_info()
            end
        })
end
)

-- vim: et:sw=4:fdm=marker:textwidth=80
