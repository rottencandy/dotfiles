local awful = require('awful')

local interval = 30
-- watch charger file
local ram_script = [[
sh -c "free -h | rg Mem | awk '{printf \"%f\", \$3}'"
]]

awful.widget.watch(ram_script, interval, function(widget, stdout)
    local ram = tonumber(stdout)

    awesome.emit_signal('notifs::ram', ram)
end)

-- vim: et:sw=4:fdm=marker:textwidth=80
