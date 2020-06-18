local awful = require('awful')
local wibox = require('wibox')
local naughty = require('naughty')
local gears = require('gears')

local popup = awful.popup {
    visible = false,
    ontop = true,
    placement = awful.placement.centered,
    shape = gears.shape.rounded_rect,
    widget = wibox.widget {
        max_value = 100,
        value = 50,
        shape = gears.shape.rounded_rect,
        forced_width = 100,
        forced_height = 20,
        widget = wibox.widget.progressbar,
    }
}

local timer = gears.timer {
    timeout = 3,
    single_shot = true,
    callback = function()
        popup.visible = false
    end
}

awesome.connect_signal('notifs::brightness', function(percentage)
    popup.visible = true
    popup.widget.value = percentage
    timer:again()
end)

-- vim: et:sw=4:fdm=marker:textwidth=80
