local theme_assets = require('beautiful.theme_assets')
local xresources = require('beautiful.xresources')
local gears = require('gears')
local gfs = require('gears.filesystem')

local dpi = xresources.apply_dpi
local HOME = os.getenv('HOME')
local CONFIG_DIR = HOME .. '/.config/awesome/'
local ICON_DIR = CONFIG_DIR .. 'icons/'

local T = {}

-- Main {{{

T.wallpaper = HOME .. '/Pictures/wall.jpg'
T.font = 'Hack Nerd Font Mono 12'

-- }}}

-- Windows {{{

-- Borders {{{

T.useless_gap   = dpi(7)
T.border_radius = dpi(5)

T.border_width  = dpi(2)
T.border_normal = '#080808'
T.border_focus  = '#aaccbb'
T.border_marked = '#91231c'

-- }}}

-- Widgets {{{

T.bg_normal     = '#080808'
T.bg_focus      = '#465'
T.bg_urgent     = '#a44'
T.bg_minimize   = '#333'

T.fg_normal     = '#bbb'
T.fg_focus      = '#ccc'
T.fg_urgent     = '#a44'
T.fg_minimize   = '#aaa'

-- }}}

-- Tooltip {{{

-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]

-- }}}

-- Prompt {{{

-- prompt_[fg|bg|fg_cursor|bg_cursor|font]

-- }}}

-- Titlebar {{{

-- titlebar_[bg|fg]_[normal|focus]
T.titlebar_bg_normal = '#080808'
T.titlebar_bg_focus = '#333'

-- }}}

-- }}}

-- Bar {{{

T.wibar_fg = '#ddd'
T.wibar_bg = '#5550'
T.wibar_height = dpi(45)

-- Taglist {{{

-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]

T.taglist_fg_focus = '#494'
T.taglist_bg_focus = '#5550'
T.taglist_fg_occupied = '#789'
T.taglist_fg_urgent = '#a55'
-- Symbols   
T.taglist_names = { '', '', '', '', '', '', '', '', '' }
T.taglist_spacing = dpi(5)

-- Taglist squares:
--local taglist_square_size = dpi(4)
--T.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, T.fg_normal)
--T.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, T.fg_normal)
T.taglist_disable_icon = true

-- }}}

-- Tasklist {{{

-- tasklist_[bg|fg]_[focus|urgent]

-- }}}

-- Systray {{{

T.systray_icon_spacing = dpi(3)
T.bg_systray    = '#13131300'

-- }}}

-- Calendar {{{

T.calendar_spacing = dpi(5)
T.calendar_long_weekdays = true

-- }}}

-- }}}

-- Notifications {{{

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- }}}

-- Menu {{{

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
T.menu_height = dpi(15)
T.menu_width  = dpi(100)

-- }}}

-- Icons {{{

T.layout_floating  = ICON_DIR .. 'floating.png'
T.layout_max = ICON_DIR .. 'max.png'
T.layout_tile = ICON_DIR .. 'tile.png'

-- Generate Awesome icon:
T.awesome_icon = theme_assets.awesome_icon(
    T.menu_height, T.bg_focus, T.fg_focus
)

-- }}}

-- Misc {{{

-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

-- Edge snap
T.snap_bg = '#cdcdcd'
T.snap_border_width = dpi(1)

-- }}}

-- Defaults {{{

-- arcchart\
-- theme.arcchart\_border\_color = nil
-- theme.arcchart\_color = nil
-- theme.arcchart\_border\_width = nil
-- theme.arcchart\_paddings = nil
-- theme.arcchart\_thickness = nil

-- awesome\
-- theme.awesome\_icon = nil

-- bg\
-- theme.bg\_normal = nil
-- theme.bg\_normal = nil
-- theme.bg\_normal = nil
-- theme.bg\_focus = nil
-- theme.bg\_urgent = nil
-- theme.bg\_minimize = nil
-- theme.bg\_systray = nil
-- theme.bg\_normal = nil
-- theme.bg\_systray = nil

-- border\
-- theme.border\_marked = nil
-- theme.border\_width = nil
-- theme.border\_normal = nil
-- theme.border\_focus = nil
-- theme.border\_marked = nil
-- theme.border\_focus = nil
-- theme.border\_normal = nil
-- theme.border\_width = nil

-- calendar\
-- theme.calendar\_style = nil
-- theme.calendar\_font = nil
-- theme.calendar\_spacing = nil
-- theme.calendar\_week\_numbers = nil
-- theme.calendar\_start\_sunday = nil
-- theme.calendar\_long\_weekdays = nil

-- checkbox\
-- theme.checkbox\_border\_width = nil
-- theme.checkbox\_bg = nil
-- theme.checkbox\_border\_color = nil
-- theme.checkbox\_check\_border\_color = nil
-- theme.checkbox\_check\_border\_width = nil
-- theme.checkbox\_check\_color = nil
-- theme.checkbox\_shape = nil
-- theme.checkbox\_check\_shape = nil
-- theme.checkbox\_paddings = nil
-- theme.checkbox\_color = nil

-- column\
-- theme.column\_count = nil

-- cursor\
-- theme.cursor\_mouse\_resize = nil
-- theme.cursor\_mouse\_move = nil

-- enable\
-- theme.enable\_spawn\_cursor = nil

-- fg\
-- theme.fg\_normal = nil
-- theme.fg\_normal = nil
-- theme.fg\_normal = nil
-- theme.fg\_focus = nil
-- theme.fg\_urgent = nil
-- theme.fg\_minimize = nil
-- theme.fg\_normal = nil

-- fullscreen\
-- theme.fullscreen\_hide\_border = nil

-- gap\
-- theme.gap\_single\_client = nil

-- graph\
-- theme.graph\_bg = nil
-- theme.graph\_fg = nil
-- theme.graph\_border\_color = nil

-- hotkeys\
-- theme.hotkeys\_bg = nil
-- theme.hotkeys\_fg = nil
-- theme.hotkeys\_border\_width = nil
-- theme.hotkeys\_border\_color = nil
-- theme.hotkeys\_shape = nil
-- theme.hotkeys\_modifiers\_fg = nil
-- theme.hotkeys\_label\_bg = nil
-- theme.hotkeys\_label\_fg = nil
-- theme.hotkeys\_font = nil
-- theme.hotkeys\_description\_font = nil
-- theme.hotkeys\_group\_margin = nil

-- icon\
-- theme.icon\_theme = nil

-- layout\
-- theme.layout\_cornernw = nil
-- theme.layout\_cornerne = nil
-- theme.layout\_cornersw = nil
-- theme.layout\_cornerse = nil
-- theme.layout\_fairh = nil
-- theme.layout\_fairv = nil
-- theme.layout\_floating = nil
-- theme.layout\_magnifier = nil
-- theme.layout\_max = nil
-- theme.layout\_fullscreen = nil
-- theme.layout\_spiral = nil
-- theme.layout\_dwindle = nil
-- theme.layout\_tile = nil
-- theme.layout\_tiletop = nil
-- theme.layout\_tilebottom = nil
-- theme.layout\_tileleft = nil

-- layoutlist\
-- theme.layoutlist\_fg\_normal = nil
-- theme.layoutlist\_bg\_normal = nil
-- theme.layoutlist\_fg\_selected = nil
-- theme.layoutlist\_bg\_selected = nil
-- theme.layoutlist\_disable\_icon = nil
-- theme.layoutlist\_disable\_name = nil
-- theme.layoutlist\_font = nil
-- theme.layoutlist\_align = nil
-- theme.layoutlist\_font\_selected = nil
-- theme.layoutlist\_spacing = nil
-- theme.layoutlist\_shape = nil
-- theme.layoutlist\_shape\_border\_width = nil
-- theme.layoutlist\_shape\_border\_color = nil
-- theme.layoutlist\_shape\_selected = nil
-- theme.layoutlist\_shape\_border\_width\_selected = nil
-- theme.layoutlist\_shape\_border\_color\_selected = nil

-- master\
-- theme.master\_width\_factor = nil
-- theme.master\_fill\_policy = nil
-- theme.master\_count = nil

-- maximized\
-- theme.maximized\_honor\_padding = nil
-- theme.maximized\_hide\_border = nil

-- menu\
-- theme.menu\_submenu\_icon = nil
-- theme.menu\_font = nil
-- theme.menu\_height = nil
-- theme.menu\_width = nil
-- theme.menu\_border\_color = nil
-- theme.menu\_border\_width = nil
-- theme.menu\_fg\_focus = nil
-- theme.menu\_bg\_focus = nil
-- theme.menu\_fg\_normal = nil
-- theme.menu\_bg\_normal = nil
-- theme.menu\_submenu = nil

-- menubar\
-- theme.menubar\_fg\_normal = nil
-- theme.menubar\_bg\_normal = nil
-- theme.menubar\_border\_width = nil
-- theme.menubar\_border\_color = nil
-- theme.menubar\_fg\_normal = nil
-- theme.menubar\_bg\_normal = nil

-- notification\
-- theme.notification\_font = nil
-- theme.notification\_bg = nil
-- theme.notification\_fg = nil
-- theme.notification\_border\_width = nil
-- theme.notification\_border\_color = nil
-- theme.notification\_shape = nil
-- theme.notification\_opacity = nil
-- theme.notification\_margin = nil
-- theme.notification\_width = nil
-- theme.notification\_height = nil
-- theme.notification\_max\_width = nil
-- theme.notification\_max\_height = nil
-- theme.notification\_icon\_size = nil

-- piechart\
-- theme.piechart\_border\_color = nil
-- theme.piechart\_border\_width = nil
-- theme.piechart\_colors = nil

-- progressbar\
-- theme.progressbar\_bg = nil
-- theme.progressbar\_fg = nil
-- theme.progressbar\_shape = nil
-- theme.progressbar\_border\_color = nil
-- theme.progressbar\_border\_width = nil
-- theme.progressbar\_bar\_shape = nil
-- theme.progressbar\_bar\_border\_width = nil
-- theme.progressbar\_bar\_border\_color = nil
-- theme.progressbar\_margins = nil
-- theme.progressbar\_paddings = nil

-- prompt\
-- theme.prompt\_fg\_cursor = nil
-- theme.prompt\_bg\_cursor = nil
-- theme.prompt\_font = nil
-- theme.prompt\_fg = nil
-- theme.prompt\_bg = nil

-- radialprogressbar\
-- theme.radialprogressbar\_border\_color = nil
-- theme.radialprogressbar\_color = nil
-- theme.radialprogressbar\_border\_width = nil
-- theme.radialprogressbar\_paddings = nil

-- separator\
-- theme.separator\_thickness = nil
-- theme.separator\_border\_color = nil
-- theme.separator\_border\_width = nil
-- theme.separator\_span\_ratio = nil
-- theme.separator\_color = nil
-- theme.separator\_shape = nil

-- slider\
-- theme.slider\_bar\_border\_width = nil
-- theme.slider\_bar\_border\_color = nil
-- theme.slider\_handle\_border\_color = nil
-- theme.slider\_handle\_border\_width = nil
-- theme.slider\_handle\_width = nil
-- theme.slider\_handle\_color = nil
-- theme.slider\_handle\_shape = nil
-- theme.slider\_bar\_shape = nil
-- theme.slider\_bar\_height = nil
-- theme.slider\_bar\_margins = nil
-- theme.slider\_handle\_margins = nil
-- theme.slider\_bar\_color = nil

-- snap\
-- theme.snap\_bg = nil
-- theme.snap\_border\_width = nil
-- theme.snap\_shape = nil

-- snapper\
-- theme.snapper\_gap = nil

-- systray\
-- theme.systray\_icon\_spacing = nil

-- taglist\
-- theme.taglist\_fg\_focus = nil
-- theme.taglist\_bg\_focus = nil
-- theme.taglist\_fg\_urgent = nil
-- theme.taglist\_bg\_urgent = nil
-- theme.taglist\_bg\_occupied = nil
-- theme.taglist\_fg\_occupied = nil
-- theme.taglist\_bg\_empty = nil
-- theme.taglist\_fg\_empty = nil
-- theme.taglist\_bg\_volatile = nil
-- theme.taglist\_fg\_volatile = nil
-- theme.taglist\_squares\_sel = nil
-- theme.taglist\_squares\_unsel = nil
-- theme.taglist\_squares\_sel\_empty = nil
-- theme.taglist\_squares\_unsel\_empty = nil
-- theme.taglist\_squares\_resize = nil
-- theme.taglist\_disable\_icon = nil
-- theme.taglist\_font = nil
-- theme.taglist\_spacing = nil
-- theme.taglist\_shape = nil
-- theme.taglist\_shape\_border\_width = nil
-- theme.taglist\_shape\_border\_color = nil
-- theme.taglist\_shape\_empty = nil
-- theme.taglist\_shape\_border\_width\_empty = nil
-- theme.taglist\_shape\_border\_color\_empty = nil
-- theme.taglist\_shape\_focus = nil
-- theme.taglist\_shape\_border\_width\_focus = nil
-- theme.taglist\_shape\_border\_color\_focus = nil
-- theme.taglist\_shape\_urgent = nil
-- theme.taglist\_shape\_border\_width\_urgent = nil
-- theme.taglist\_shape\_border\_color\_urgent = nil
-- theme.taglist\_shape\_volatile = nil
-- theme.taglist\_shape\_border\_width\_volatile = nil
-- theme.taglist\_shape\_border\_color\_volatile = nil

-- tasklist\
-- theme.tasklist\_fg\_normal = nil
-- theme.tasklist\_bg\_normal = nil
-- theme.tasklist\_fg\_focus = nil
-- theme.tasklist\_bg\_focus = nil
-- theme.tasklist\_fg\_urgent = nil
-- theme.tasklist\_bg\_urgent = nil
-- theme.tasklist\_fg\_minimize = nil
-- theme.tasklist\_bg\_minimize = nil
-- theme.tasklist\_bg\_image\_normal = nil
-- theme.tasklist\_bg\_image\_focus = nil
-- theme.tasklist\_bg\_image\_urgent = nil
-- theme.tasklist\_bg\_image\_minimize = nil
-- theme.tasklist\_disable\_icon = nil
-- theme.tasklist\_disable\_task\_name = nil
-- theme.tasklist\_plain\_task\_name = nil
-- theme.tasklist\_font = nil
-- theme.tasklist\_align = nil
-- theme.tasklist\_font\_focus = nil
-- theme.tasklist\_font\_minimized = nil
-- theme.tasklist\_font\_urgent = nil
-- theme.tasklist\_spacing = nil
-- theme.tasklist\_shape = nil
-- theme.tasklist\_shape\_border\_width = nil
-- theme.tasklist\_shape\_border\_color = nil
-- theme.tasklist\_shape\_focus = nil
-- theme.tasklist\_shape\_border\_width\_focus = nil
-- theme.tasklist\_shape\_border\_color\_focus = nil
-- theme.tasklist\_shape\_minimized = nil
-- theme.tasklist\_shape\_border\_width\_minimized = nil
-- theme.tasklist\_shape\_border\_color\_minimized = nil
-- theme.tasklist\_shape\_urgent = nil
-- theme.tasklist\_shape\_border\_width\_urgent = nil
-- theme.tasklist\_shape\_border\_color\_urgent = nil

-- titlebar\
-- theme.titlebar\_fg\_normal = nil
-- theme.titlebar\_bg\_normal = nil
-- theme.titlebar\_bgimage\_normal = nil
-- theme.titlebar\_fg = nil
-- theme.titlebar\_bg = nil
-- theme.titlebar\_bgimage = nil
-- theme.titlebar\_fg\_focus = nil
-- theme.titlebar\_bg\_focus = nil
-- theme.titlebar\_bgimage\_focus = nil
-- theme.titlebar\_floating\_button\_normal = nil
-- theme.titlebar\_maximized\_button\_normal = nil
-- theme.titlebar\_minimize\_button\_normal = nil
-- theme.titlebar\_minimize\_button\_normal\_hover = nil
-- theme.titlebar\_minimize\_button\_normal\_press = nil
-- theme.titlebar\_close\_button\_normal = nil
-- theme.titlebar\_close\_button\_normal\_hover = nil
-- theme.titlebar\_close\_button\_normal\_press = nil
-- theme.titlebar\_ontop\_button\_normal = nil
-- theme.titlebar\_sticky\_button\_normal = nil
-- theme.titlebar\_floating\_button\_focus = nil
-- theme.titlebar\_maximized\_button\_focus = nil
-- theme.titlebar\_minimize\_button\_focus = nil
-- theme.titlebar\_minimize\_button\_focus\_hover = nil
-- theme.titlebar\_minimize\_button\_focus\_press = nil
-- theme.titlebar\_close\_button\_focus = nil
-- theme.titlebar\_close\_button\_focus\_hover = nil
-- theme.titlebar\_close\_button\_focus\_press = nil
-- theme.titlebar\_ontop\_button\_focus = nil
-- theme.titlebar\_sticky\_button\_focus = nil
-- theme.titlebar\_floating\_button\_normal\_active = nil
-- theme.titlebar\_floating\_button\_normal\_active\_hover = nil
-- theme.titlebar\_floating\_button\_normal\_active\_press = nil
-- theme.titlebar\_maximized\_button\_normal\_active = nil
-- theme.titlebar\_maximized\_button\_normal\_active\_hover = nil
-- theme.titlebar\_maximized\_button\_normal\_active\_press = nil
-- theme.titlebar\_ontop\_button\_normal\_active = nil
-- theme.titlebar\_ontop\_button\_normal\_active\_hover = nil
-- theme.titlebar\_ontop\_button\_normal\_active\_press = nil
-- theme.titlebar\_sticky\_button\_normal\_active = nil
-- theme.titlebar\_sticky\_button\_normal\_active\_hover = nil
-- theme.titlebar\_sticky\_button\_normal\_active\_press = nil
-- theme.titlebar\_floating\_button\_focus\_active = nil
-- theme.titlebar\_floating\_button\_focus\_active\_hover = nil
-- theme.titlebar\_floating\_button\_focus\_active\_press = nil
-- theme.titlebar\_maximized\_button\_focus\_active = nil
-- theme.titlebar\_maximized\_button\_focus\_active\_hover = nil
-- theme.titlebar\_maximized\_button\_focus\_active\_press = nil
-- theme.titlebar\_ontop\_button\_focus\_active = nil
-- theme.titlebar\_ontop\_button\_focus\_active\_hover = nil
-- theme.titlebar\_ontop\_button\_focus\_active\_press = nil
-- theme.titlebar\_sticky\_button\_focus\_active = nil
-- theme.titlebar\_sticky\_button\_focus\_active\_hover = nil
-- theme.titlebar\_sticky\_button\_focus\_active\_press = nil
-- theme.titlebar\_floating\_button\_normal\_inactive = nil
-- theme.titlebar\_floating\_button\_normal\_inactive\_hover = nil
-- theme.titlebar\_floating\_button\_normal\_inactive\_press = nil
-- theme.titlebar\_maximized\_button\_normal\_inactive = nil
-- theme.titlebar\_maximized\_button\_normal\_inactive\_hover = nil
-- theme.titlebar\_maximized\_button\_normal\_inactive\_press = nil
-- theme.titlebar\_ontop\_button\_normal\_inactive = nil
-- theme.titlebar\_ontop\_button\_normal\_inactive\_hover = nil
-- theme.titlebar\_ontop\_button\_normal\_inactive\_press = nil
-- theme.titlebar\_sticky\_button\_normal\_inactive = nil
-- theme.titlebar\_sticky\_button\_normal\_inactive\_hover = nil
-- theme.titlebar\_sticky\_button\_normal\_inactive\_press = nil
-- theme.titlebar\_floating\_button\_focus\_inactive = nil
-- theme.titlebar\_floating\_button\_focus\_inactive\_hover = nil
-- theme.titlebar\_floating\_button\_focus\_inactive\_press = nil
-- theme.titlebar\_maximized\_button\_focus\_inactive = nil
-- theme.titlebar\_maximized\_button\_focus\_inactive\_hover = nil
-- theme.titlebar\_maximized\_button\_focus\_inactive\_press = nil
-- theme.titlebar\_ontop\_button\_focus\_inactive = nil
-- theme.titlebar\_ontop\_button\_focus\_inactive\_hover = nil
-- theme.titlebar\_ontop\_button\_focus\_inactive\_press = nil
-- theme.titlebar\_sticky\_button\_focus\_inactive = nil
-- theme.titlebar\_sticky\_button\_focus\_inactive\_hover = nil
-- theme.titlebar\_sticky\_button\_focus\_inactive\_press = nil

-- tooltip\
-- theme.tooltip\_border\_color = nil
-- theme.tooltip\_bg = nil
-- theme.tooltip\_fg = nil
-- theme.tooltip\_font = nil
-- theme.tooltip\_border\_width = nil
-- theme.tooltip\_opacity = nil
-- theme.tooltip\_shape = nil
-- theme.tooltip\_align = nil

-- useless\
-- theme.useless\_gap = nil

-- wibar\
-- theme.wibar\_stretch = nil
-- theme.wibar\_border\_width = nil
-- theme.wibar\_border\_color = nil
-- theme.wibar\_ontop = nil
-- theme.wibar\_cursor = nil
-- theme.wibar\_opacity = nil
-- theme.wibar\_type = nil
-- theme.wibar\_width = nil
-- theme.wibar\_height = nil
-- theme.wibar\_bg = nil
-- theme.wibar\_bgimage = nil
-- theme.wibar\_fg = nil
-- theme.wibar\_shape = nil

-- }}}

return T

-- vim: et:sw=4:fdm=marker:textwidth=80
