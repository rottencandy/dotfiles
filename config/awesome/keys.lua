local gears = require('gears')
local awful = require('awful')
local naughty = require('naughty')
local hotkeys_popup = require('awful.hotkeys_popup')

local menubar = require('menubar')
-- Menubar configuration
menubar.utils.terminal = TERMINAL -- Set the terminal for applications that require it

local superkey = 'Mod4'
local alt = 'Mod1'
local shift = 'Shift'
local ctrl = 'Control'
local enter = 'Return'
local client_move_dist = 50
local XIDLEHOOK_SOCKET = '/tmp/xidlehook.sock'

local keys = {}

keys.globalkeys = gears.table.join(
    -- {{{ General

    awful.key({ superkey, shift }, 'r', awesome.restart,
        { description = 'reload awesome', group = 'awesome' }),

    awful.key({ superkey, shift }, 'Escape', awesome.quit,
        { description = 'quit awesome', group = 'awesome' }),

    awful.key({ superkey, }, 'q', hotkeys_popup.show_help,
        { description = 'show help', group = 'awesome' }),

    -- }}}

    -- {{{ Notifications

    -- Dismiss all notifications
    awful.key({ ctrl }, 'space', naughty.destroy_all_notifications,
        {description = 'Clear all notifications', group = 'notifications' }),

    -- }}}

    -- {{{ Navigation

    awful.key({ superkey, }, 'k',
        function () awful.client.focus.bydirection('up') end,
        { description = 'focus up', group = 'client' }
    ),
    awful.key({ superkey, }, 'j',
        function () awful.client.focus.bydirection('down') end,
        { description = 'focus down', group = 'client' }
    ),
    awful.key({ superkey, }, 'h',
        function () awful.client.focus.bydirection('left') end,
        { description = 'focus left', group = 'client' }
    ),
    awful.key({ superkey, }, 'l',
        function () awful.client.focus.bydirection('right') end,
        { description = 'focus right', group = 'client' }
    ),

    -- Jump to previous
    awful.key({ superkey, }, '`', awful.tag.history.restore,
        { description = 'previous tag', group = 'tag' }),
    awful.key({ superkey, }, 'Tab',
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = 'previous application', group = 'client' }),

    awful.key({ superkey, }, 'u', awful.client.urgent.jumpto,
        { description = 'jump to urgent client', group = 'client' }),

    awful.key({ superkey, ctrl }, 'j', function () awful.screen.focus_relative(1) end,
        { description = 'focus the next screen', group = 'screen' }),
    awful.key({ superkey, ctrl }, 'k', function () awful.screen.focus_relative(-1) end,
        { description = 'focus the previous screen', group = 'screen' }),

    -- }}}

    -- {{{ Layout manipulation

    awful.key({ superkey }, 'space', function () awful.layout.inc(1) end,
        { description = 'select next layout', group = 'layout' }),
    awful.key({ superkey, shift }, 'space', function () awful.layout.inc(-1) end,
        { description = 'select previous layout', group = 'layout' }),

    -- Gaps
    awful.key({ superkey, shift }, 'minus', function () awful.tag.incgap(5, nil) end,
        { description = 'increment gaps for current tag', group = 'gaps' }),
    awful.key({ superkey }, 'minus', function () awful.tag.incgap(-5, nil) end,
        { description = 'decrement gaps for current tag', group = 'gaps' }),

    awful.key({ superkey, shift }, 'j', function () awful.client.swap.byidx(1) end,
        { description = 'swap with next client by index', group = 'client' }),
    awful.key({ superkey, shift }, 'k', function () awful.client.swap.byidx(-1) end,
        { description = 'swap with previous client by index', group = 'client' }),

    --awful.key({ superkey, alt }, 'l', function () awful.tag.incmwfact( 0.05) end,
    --    { description = 'increase master width factor', group = 'layout' }),
    --awful.key({ superkey, alt }, 'h', function () awful.tag.incmwfact(-0.05) end,
    --    { description = 'decrease master width factor', group = 'layout' }),

    awful.key({ superkey, alt }, 'h', function () awful.tag.incnmaster( 1, nil, true) end,
        { description = 'increase the number of master clients', group = 'layout' }),
    awful.key({ superkey, alt }, 'l', function () awful.tag.incnmaster(-1, nil, true) end,
        { description = 'decrease the number of master clients', group = 'layout' }),

    awful.key({ superkey, alt }, 'k', function () awful.tag.incncol( 1, nil, true) end,
        { description = 'increase the number of columns', group = 'layout' }),
    awful.key({ superkey, alt }, 'j', function () awful.tag.incncol(-1, nil, true) end,
        { description = 'decrease the number of columns', group = 'layout' }),

    awful.key({ superkey }, 'n', function()
        awful.spawn.with_shell('cd ~/nb && ' .. TERMINAL .. ' -e nvim _temp.md')
    end,
        { description = 'useless shortcut', group = 'layout' }),

    -- }}}

    -- {{{ Programs

    -- Terminal
    awful.key({ superkey, }, enter, function() awful.spawn(TERMINAL) end,
        { description = 'spawn terminal', group = 'launcher' }),
    -- Alt terminal
    awful.key({ superkey, shift }, enter, function() awful.spawn(TERMINAL_ALT) end,
        { description = 'spawn alt terminal', group = 'launcher' }),

    -- Screenshot
    awful.key({ superkey, shift }, 's', function()
        awful.spawn.with_shell('maim ~/screenshots/screenshot-$(date +%s).png 2> /dev/null')
        naughty.notify({ title = 'Screenshot Saved', text = 'Screenshot saved!', timeout = 3 })
    end,
        { description = 'Capture screenshot', group = 'launcher' }),

    -- Application launcher
    awful.key({ superkey }, 'r', function () awful.spawn('rofi -show window') end,
        { description = 'run launcher(rofi)', group = 'launcher' }),
    awful.key({ superkey }, 'd', function () awful.spawn('rofi -show drun') end,
        { description = 'run window selector(rofi)', group = 'launcher' }),

    -- Lock screen
    awful.key({ superkey }, 'p',
        function()
            awful.spawn.with_shell(os.getenv('HOME') .. '/.config/sxhkd/lock.sh')
        end,
        { description = 'Lock screen', group = 'awesome' }),

    awful.key({ superkey }, 'x',
        function()
            awful.prompt.run {
                prompt = 'Lua: ',
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. '/history_eval'
            }
        end,
        { description = 'lua execute prompt', group = 'awesome' }),

    -- }}}

    -- {{{ Misc controls

    -- Volume
    awful.key({}, "XF86AudioLowerVolume", function ()
        awful.spawn("amixer -q -D pulse sset Master 5%-", false)
    end,
        { description = 'Lower volume', group = 'volume' }),
    awful.key({}, "XF86AudioRaiseVolume", function ()
        awful.spawn("amixer -q -D pulse sset Master 5%+", false)
    end,
        { description = 'Raise volume', group = 'volume' }),
    awful.key({}, "XF86AudioMute", function ()
        awful.spawn("amixer -D pulse set Master 1+ toggle", false)
    end,
        { description = 'toggle volume', group = 'volume' }),

    -- For non-media keyboards
    awful.key({ superkey }, "F1", function ()
        awful.spawn("amixer -q -D pulse sset Master 5%+", false)
    end,
        { description = 'Raise volume', group = 'volume' }),
    awful.key({ superkey }, "F2", function ()
        awful.spawn("amixer -q -D pulse sset Master 5%-", false)
    end,
        { description = 'Lower volume', group = 'volume' }),
    awful.key({ superkey }, "F3", function ()
        awful.spawn("amixer -D pulse set Master 1+ toggle", false)
    end,
        { description = 'toggle volume', group = 'volume' }),

    -- Brightness
    awful.key({}, "XF86MonBrightnessUp", function ()
        awful.spawn("xbacklight -inc 5%", false)
    end,
        { description = 'Increase brightness', group = 'brightness' }),
    awful.key({}, "XF86MonBrightnessDown", function ()
        awful.spawn("xbacklight -dec 5%", false)
    end,
        { description = 'Decrease brightness', group = 'brightness' })

    -- }}}
)

-- {{{ Clients

keys.clientkeys = gears.table.join(
    awful.key({ superkey, }, 'Up',
        function (c) c:relative_move(0, -client_move_dist, 0, 0) end,
        {description = 'Move client up', group = 'client'}
    ),
    awful.key({ superkey, }, 'Down',
        function (c) c:relative_move(0, client_move_dist, 0, 0) end,
        {description = 'Move client down', group = 'client'}
    ),
    awful.key({ superkey, }, 'Left',
        function (c) c:relative_move(-client_move_dist, 0, 0, 0) end,
        {description = 'Move client left', group = 'client'}
    ),
    awful.key({ superkey, }, 'Right',
        function (c) c:relative_move(client_move_dist, 0, 0, 0) end,
        {description = 'Move client right', group = 'client'}
    ),
    awful.key({ superkey, }, 'f',
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = 'toggle fullscreen', group = 'client'}),
    awful.key({ superkey, shift }, 'q', function (c) c:kill() end,
        {description = 'close', group = 'client'}),
    --awful.key({ superkey, }, 't', awful.client.floating.toggle,
    --    {description = 'toggle floating', group = 'client'}),
    --awful.key({ superkey, ctrl }, enter, function (c) c:swap(awful.client.getmaster()) end,
    --    {description = 'move to master', group = 'client'}),
    --awful.key({ superkey, }, 'o', function (c) c:move_to_screen() end,
    --    {description = 'move to screen', group = 'client'}),
    awful.key({ superkey, }, 'i', function (c) c.ontop = not c.ontop end,
        {description = 'toggle keep on top', group = 'client'}),
    --awful.key({ superkey, }, 'n',
    --    function (c)
    --        -- The client currently has the input focus, so it cannot be
    --        -- minimized, since minimized clients can't have the focus.
    --        c.minimized = true
    --    end,
    --    {description = 'minimize', group = 'client'}),

    --awful.key({ superkey, ctrl }, 'n',
    --    function ()
    --        local c = awful.client.restore()
    --        -- Focus restored client
    --        if c then
    --            c:emit_signal('request::activate', 'key.unminimize', {raise = true})
    --        end
    --    end,
    --    {description = 'restore minimized', group = 'client'}),
    awful.key({ superkey, }, 'm',
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = '(un)maximize', group = 'client'}),
    awful.key({ superkey, ctrl }, 'm',
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        {description = '(un)maximize vertically', group = 'client'}),
    awful.key({ superkey, shift }, 'm',
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        {description = '(un)maximize horizontally', group = 'client'}),
    awful.key({ superkey }, 'y',
        function (c) c:raise() end,
        {description = 'raise window', group = 'client'})
)

-- }}}

-- {{{ Clients(mouse)
keys.clientbuttons = gears.table.join(
    awful.button({ }, 1, function(c)
        c:emit_signal('request::activate', 'mouse_click', {raise = true})
    end),
    awful.button({ superkey }, 1, function(c)
        c:emit_signal('request::activate', 'mouse_click', {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ superkey }, 3, function(c)
        c:emit_signal('request::activate', 'mouse_click', {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- }}}

-- {{{ Tags

-- Bind all key numbers to tags.
for i = 1, 9 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        -- View tag only.
        awful.key({ superkey }, '#' .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = 'view tag #'..i, group = 'tag'}),
        -- Toggle tag display.
        awful.key({ superkey, ctrl }, '#' .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = 'toggle tag #' .. i, group = 'tag'}),
        -- Move client to tag.
        awful.key({ superkey, shift }, '#' .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = 'move focused client to tag #'..i, group = 'tag'}),
        -- Toggle tag on focused client.
        awful.key({ superkey, ctrl , shift }, '#' .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = 'toggle focused client on tag #' .. i, group = 'tag'})
    )
end
-- }}}


return keys

-- vim: et:sw=4:fdm=marker:textwidth=80
