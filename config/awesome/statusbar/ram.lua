local wibox = require('wibox')

local prefix = 'Ram: '

-- TODO: add color
local ram_widget = wibox.widget {
    markup = prefix .. '-',
    align = 'left',
    valign = 'center',
    widget = wibox.widget.textbox,
}

awesome.connect_signal('notifs::ram', function(ram)
    ram_widget.markup = prefix .. ram .. 'G'
end)

return ram_widget

-- vim: et:sw=4:fdm=marker:textwidth=80
