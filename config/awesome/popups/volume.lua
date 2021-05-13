local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local naughty = require('naughty')
local gears = require('gears')

local icon = wibox.widget {
    image = beautiful.awesome_icon,
    resize = false,
    widget = wibox.widget.textbox,
}

local bar = wibox.widget {
    max_value = 100,
    value = 0,
    forced_width = 150,
    forced_height = 30,
    shape = gears.shape.rounded_rect,
    color = '#4aa96c',
    background_color = '#ededd0',
    widget = wibox.widget.progressbar,
}

local popup = awful.popup {
    visible = false,
    ontop = true,
    placement = awful.placement.centered,
    shape = gears.shape.rounded_rect,
    widget = wibox.widget {
        icon,
        bar,
        layout = wibox.layout.align.vertical
    }
}

local timer = gears.timer {
    timeout = 3,
    single_shot = true,
    callback = function()
        popup.visible = false
    end
}

awesome.connect_signal('notifs::volume', function(volume, muted)
    popup.visible = true
    bar.value = muted and 0 or volume
    timer:again()
end)

-- vim: et:sw=4:fdm=marker:textwidth=80
