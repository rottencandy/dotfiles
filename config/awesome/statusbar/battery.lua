local wibox = require('wibox')

local MIN_BAT = 25

local contents = wibox.widget {
    text = '...',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
}

local bat_widget = wibox.widget {
    contents,
    min_value = 0,
    max_value = 100,
    value = 0,
    bg = '#faf3f3',
    colors = { '#4aa96c' },
    thickness = 3,
    forced_height = 35,
    forced_width = 35,
    widget = wibox.container.arcchart,
}

awesome.connect_signal('notifs::battery', function(percentage, charging)
    bat_widget.value = percentage
    contents.text = percentage

    if percentage > MIN_BAT then
        bat_widget.colors = { '#4aa96c' }
    else
        bat_widget.colors = { '#f55c47' }
    end
end)

return bat_widget

-- vim: et:sw=4:fdm=marker:textwidth=80
