local wibox = require('wibox')

-- TODO: add color
local vol_widget = wibox.widget {
    markup = 'Vol: -',
    align = 'left',
    valign = 'center',
    widget = wibox.widget.textbox,
}

local muted_text = 'mute'
local prefix = 'Vol: '

awesome.connect_signal('notifs::volume', function(volume, muted)
    if muted then
        vol_widget.markup = muted_text
    else
        vol_widget.markup = prefix .. volume .. '%'
    end
end)

return vol_widget

-- vim: et:sw=4:fdm=marker:textwidth=80
