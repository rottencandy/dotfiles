local wibox = require('wibox')

local prefix = ''

-- TODO: add color
local ram_widget = wibox.widget {
    text = '...',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
}

awesome.connect_signal('notifs::ram', function(ram)
    ram_widget.text = prefix .. ram
end)

return ram_widget

-- vim: et:sw=4:fdm=marker:textwidth=80
