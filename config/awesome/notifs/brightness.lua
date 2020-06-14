local awful = require('awful')


local function emit_brightness_info()
    awful.spawn.easy_async('xbacklight -get', function(output)
        local brightness = tonumber(output)

        awesome.emit_signal('notifs::brightness', brightness)
    end)
end

local battery_script = [[
sh -c '
inotifywait -e modify -m /sys/class/backlight/intel_backlight/brightness
'
]]

-- Kill old instance
awful.spawn.easy_async_with_shell("ps x | rg \"inotifywait -e modify -m /sys/class/backlight/intel_backlight/brightness\" | rg -v rg | awk '{print $1}' | xargs kill", function()

    awful.spawn.with_line_callback(battery_script, {
            stdout = function()
                emit_brightness_info()
            end
        })
end
)

-- vim: et:sw=4:fdm=marker:textwidth=80
