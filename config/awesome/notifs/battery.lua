local awful = require('awful')

local interval = 30
-- watch charger file
local battery_script = [[
sh -c 'acpi --battery'
]]

awful.widget.watch(battery_script, interval, function(widget, stdout)
    local percentage = tonumber(stdout:match('(%d+)%%'))
    local charging = stdout:match('Charging') and true or false

    awesome.emit_signal('notifs::battery', percentage, charging)
end)

-- vim: et:sw=4:fdm=marker:textwidth=80
