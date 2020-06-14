local awful = require('awful')

local interval = 30
-- watch charger file
local temp_script = [[
sh -c "sensors | rg Package | awk '{printf \"%f\", \$4}'"
]]

awful.widget.watch(temp_script, interval, function(widget, stdout)
    local temp = tonumber(stdout)

    awesome.emit_signal('notifs::temp', temp)
end)

-- vim: et:sw=4:fdm=marker:textwidth=80
