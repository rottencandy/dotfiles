local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')

local taglist_widget = require('statusbar.taglist')
local volume = require('statusbar.volume')
local battery = require('statusbar.battery')


local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal('request::activate', 'tasklist', {raise = true})
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function ()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function ()
        awful.client.focus.byidx(-1)
    end)
    )

return function(s)
    -- Left widgets
    -- ================================================================
    local names = { '一', '二', '三', '四', '五', '六', '七', '八', '九' }
    awful.tag(names, s, awful.layout.layouts[1])
    -- Create a taglist widget
    s.mytaglist = taglist_widget(s)
    --s.mytaglist = awful.widget.taglist {
    --    screen = s,
    --    filter = awful.widget.taglist.filter.all,
    --    buttons = taglist_buttons
    --}
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Center widgets
    -- ================================================================

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Right widgets
    -- ================================================================

    -- Keyboard map indicator and switcher
    local mykeyboardlayout = awful.widget.keyboardlayout()

    -- System tray
    local mysystray = wibox.widget.systray()

    -- Create a textclock widget
    local mytextclock = wibox.widget.textclock()

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
        s.mytasklist,

        -- Right widgets
        { layout = wibox.layout.fixed.horizontal,
            volume,
            battery,
            mykeyboardlayout,
            mysystray,
            mytextclock,
            s.mylayoutbox,
        },
    }
end

-- vim: et:sw=4:fdm=marker:textwidth=80
