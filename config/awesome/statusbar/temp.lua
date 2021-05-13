local wibox = require('wibox')

local prefix = ''

-- TODO: add unsafe temp color/notif
local temp_widget = wibox.widget {
    text = '...',
    align = 'left',
    valign = 'center',
    font = 'Hack Nerd Font Mono 12',
    widget = wibox.widget.textbox,
}

awesome.connect_signal('notifs::temp', function(temp)
    temp_widget.text = prefix .. temp
end)

return temp_widget

-- vim: et:sw=4:fdm=marker:textwidth=80
