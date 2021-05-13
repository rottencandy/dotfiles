local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')

local taglist_widget = require('statusbar.taglist')
local battery = require('statusbar.battery')
local ram = require('statusbar.ram')
local temp = require('statusbar.temp')


return function(s)
    -- Left widgets
    -- ================================================================
    -- Create a taglist widget
    s.mytaglist = taglist_widget(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Right widgets
    -- ================================================================

    -- Keyboard map indicator and switcher
    --local mykeyboardlayout = awful.widget.keyboardlayout()

    -- System tray
    local mysystray = wibox.widget.systray(true)
    mysystray.opacity = 0
    --mysystray:set_screen(s)

    -- Time
    local time = wibox.widget.textclock('%l:%M')

    -- Calendar
    local calendar = wibox.widget.textclock(' %a')
    local popup = awful.widget.calendar_popup.month({ screen = s })
    popup:attach(calendar, 't')

    -- Icon indicating current layout
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    -- Setup
    -- ================================================================
    s.mywibox = awful.wibar({ position = 'top', screen = s })

    s.mywibox:setup {
        -- Left widgets
        {
            s.mytaglist,
            s.mypromptbox,
            layout = wibox.layout.fixed.horizontal,
        },

        -- Middle widgets
        {
            align = 'center',
            widget = time,
        },

        -- Right widgets
        {
            calendar,
            ram,
            temp,
            battery,
            --mykeyboardlayout,
            mysystray,
            s.mylayoutbox,
            spacing = 10,
            layout = wibox.layout.fixed.horizontal,
        },
        layout = wibox.layout.align.horizontal,
    }
end

-- vim: et:sw=4:fdm=marker:textwidth=80
