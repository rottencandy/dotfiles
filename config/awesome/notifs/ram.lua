local awful = require('awful')
local util = require('../util')

local interval = 30
-- watch charger file
-- use '{printf \"%f\", \$3}' & tonumber to get number
local ram_script = [[
sh -c "free -h | rg Mem | awk '{print \$3}'"
]]

awful.widget.watch(ram_script, interval, function(widget, stdout)
    local ram = util.trim(stdout)

    awesome.emit_signal('notifs::ram', ram)
end)

-- vim: et:sw=4:fdm=marker:textwidth=80
