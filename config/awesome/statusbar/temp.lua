local wibox = require('wibox')

local prefix = 'Temp: '

-- TODO: add unsafe temp color/notif
local temp_widget = wibox.widget {
    markup = prefix .. '-',
    align = 'left',
    valign = 'center',
    widget = wibox.widget.textbox,
}

awesome.connect_signal('notifs::temp', function(temp)
    temp_widget.markup = prefix .. temp
end)

return temp_widget

-- vim: et:sw=4:fdm=marker:textwidth=80
