local wibox = require('wibox')

local prefix = 'Bat: '

-- TODO: add color
local bat_widget = wibox.widget {
    markup = prefix .. ' -',
    align = 'left',
    valign = 'center',
    widget = wibox.widget.textbox,
}

awesome.connect_signal('notifs::battery', function(percentage, charging)
    if charging then
        bat_widget.markup = prefix .. percentage .. '%'
    else
        bat_widget.markup = prefix .. percentage .. '%'
    end
end)

return bat_widget

-- vim: et:sw=4:fdm=marker:textwidth=80
