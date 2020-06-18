local wibox = require('wibox')

local prefix = 'Bri: '

-- TODO: add color
local brightness_widget = wibox.widget {
    markup = prefix .. '-',
    align = 'left',
    valign = 'center',
    widget = wibox.widget.textbox,
}

awesome.connect_signal('notifs::brightness', function(percentage)
    brightness_widget.markup = prefix .. percentage .. '%'
end)

return brightness_widget

-- vim: et:sw=4:fdm=marker:textwidth=80
