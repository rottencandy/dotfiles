local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')

local taglist_widget = require('statusbar.taglist')
local tasklist_widget = require('statusbar.tasklist')
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

    -- Center widgets
    -- ================================================================

    -- Create a tasklist widget
    s.mytasklist = tasklist_widget(s)

    -- Right widgets
    -- ================================================================

    -- Keyboard map indicator and switcher
    local mykeyboardlayout = awful.widget.keyboardlayout()

    -- System tray
    local mysystray = wibox.widget.systray()

    -- Time
    local time = wibox.widget.textclock('%l:%M')

    -- Calendar
    local calendar = wibox.widget.textclock(' %a')
    local popup = awful.widget.calendar_popup.month()
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
        layout = wibox.layout.align.horizontal,

        -- Left widgets
        { layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },

        -- Middle widgets
        {
            align = 'center',
            widget = time,
        },

        -- Right widgets
        { layout = wibox.layout.fixed.horizontal,
            calendar,
            ram,
            temp,
            battery,
            --mykeyboardlayout,
            mysystray,
            s.mylayoutbox,
        },
    }
end

-- vim: et:sw=4:fdm=marker:textwidth=80
