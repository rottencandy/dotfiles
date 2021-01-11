local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local naughty = require('naughty')
local awful = require('awful')
require('awful.autofocus')


-- Check for luarocks
pcall(require, 'luarocks.loader')

-- Make colors global
x = require('colors')
-- Setup event listeners
require('notifs')
-- Setup popups
require('popups')

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
            title = 'Oops, there were errors during startup!',
        text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal('debug::error', function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                title = 'Oops, an error happened!',
            text = tostring(err) })
        in_error = false
    end)
end

-- }}}

-- {{{ Startup

awful.spawn.with_shell(os.getenv('HOME') .. '/.config/awesome/startup.sh')

-- }}}

-- {{{ Global variable definitions

local config_dir = os.getenv('HOME') .. '/.config/awesome/'

-- Make dpi function global
dpi = beautiful.xresources.apply_dpi

-- Themes define colours, icons, font and wallpapers.
beautiful.init(config_dir .. 'themes/lovelace/theme.lua')

terminal = 'st'
editor = os.getenv('EDITOR') or 'vim'
editor_cmd = terminal .. ' -e ' .. editor

local l = awful.layout.suit
awful.layout.layouts = {
    l.floating,
    l.tile,
    l.max,
    -- l.fair,
    -- l.tile.left,
    -- l.tile.bottom,
    -- l.tile.top,
    -- l.fair.horizontal,
    -- l.spiral,
    -- l.spiral.dwindle,
    -- l.max.fullscreen,
    -- l.magnifier,
    -- l.corner.nw,
    -- l.corner.ne,
    -- l.corner.sw,
    -- l.corner.se,
}

-- }}}

-- Screens setup {{{

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == 'function' then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Reload config when geometry changes (e.g. different resolution)
screen.connect_signal('property::geometry', awesome.restart)
screen.connect_signal('screen::list', awesome.restart)

local mybar = require('statusbar')

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    local names = {
        { '一', '二', '三', '四', '五'},
        {'一', '二', '三', '四', '五', '六', '七', '八', '九' }
    }
    local layouts = {{
            l.floating,
            l.tile,
            l.floating,
            l.floating,
        }, {
            l.floating,
            l.tile,
            l.floating,
            l.floating,
            l.floating,
            l.floating,
            l.floating,
            l.floating,
            l.floating,
    }}

    if screen.count() > 1 then
        awful.tag(names[1], s, layouts[1])
    else
        awful.tag(names[2], s, layouts[2])
    end

    mybar(s)
end)
--- }}}

-- {{{ Key bindings

local keys = require('keys')

root.keys(keys.globalkeys)

-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the 'manage' signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.clientkeys,
            buttons = keys.clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.centered + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                'DTA',  -- Firefox addon DownThemAll.
                'copyq',  -- Includes session name in class.
                'pinentry',
            },
            class = {
                'Arandr',
                'Blueman-manager',
                'Gpick',
                'GNU Image Manipulation Program',
                'Kruler',
                'MessageWin',  -- kalarm.
                'Sxiv',
                'Tor Browser', -- Needs a fixed window size to avoid fingerprinting by screen size.
                'Wpa_gui',
                'veromix',
                'xtightvncviewer'
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                'Event Tester',  -- xev.
            },
            role = {
                'AlarmWindow',  -- Thunderbird's calendar.
                'ConfigManager',  -- Thunderbird's about:config.
                'pop-up',       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { 'normal', 'dialog' } },
        properties = { titlebars_enabled = true }
    },

    -- Set terminal window to not have titlebar
    {
        rule = { name = terminal },
        properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named '2' on screen 1.
    -- { rule = { class = 'Firefox' },
    --   properties = { screen = 1, tag = '2' } },
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal('manage', function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    c.shape = gears.shape.rounded_rect

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal('request::titlebars', function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(awful.button({}, 1, function()
        c:emit_signal('request::activate', 'titlebar', {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
        c:emit_signal('request::activate', 'titlebar', {raise = true})
        awful.mouse.client.resize(c)
    end))

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = 'center',
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        --{ -- Right
        --awful.titlebar.widget.floatingbutton(c),
        --awful.titlebar.widget.maximizedbutton(c),
        --awful.titlebar.widget.stickybutton(c),
        --awful.titlebar.widget.ontopbutton(c),
        --awful.titlebar.widget.closebutton(c),
        --layout = wibox.layout.fixed.horizontal()
        --},
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal('focus', function(c) c.border_color = beautiful.border_focus end)
client.connect_signal('unfocus', function(c) c.border_color = beautiful.border_normal end)

-- }}}

-- Garbage collection(for lower memory consumption)
collectgarbage('setpause', 110)
collectgarbage('setstepmul', 1000)

-- vim: et:sw=4:fdm=marker:textwidth=80
