(local theme_assets (require "beautiful.theme_assets"))
(local xresources (require "beautiful.xresources"))
(local gears (require "gears"))
(local gfs (require "gears.filesystem"))

(local dpi xresources.apply_dpi)
(local ICON_DIR (.. _G.CONFIG_DIR "/icons"))

(local T {})

;; MAIN {{{

(set T.wallpaper (.. _G.HOME "/Pictures/wall.jpg"))
(set T.font "Hack Nerd Font Mono 12")

;; }}}

;; Borders {{{

(set T.useless_gap (dpi 7))
(set T.border_radius (dpi 5))
(set T.border_width (dpi 2))
(set T.border_normal "#080808")
(set T.border_focus "#aaccbb")
(set T.border_marked "#91231c")

;; }}}

;; Widgets {{{

(set T.bg_normal "#080808")
(set T.bg_focus "#446655")
(set T.bg_urgent "#a44")
(set T.bg_minimize "#333")
(set T.fg_normal "#bbb")
(set T.fg_focus "#ccc")
(set T.fg_urgent "#a44")
(set T.fg_minimize "#aaa")

;; }}}

;; Titlebar {{{

(set T.titlebar_bg_normal "#080808")
(set T.titlebar_bg_focus "#333")

;; }}}

;; BAR {{{

(set T.wibar_fg "#ddd")
(set T.wibar_bg "#5550")
(set T.wibar_height (dpi 45))

;; taglist
(set T.taglist_fg_focus "#494")
(set T.taglist_bg_focus "#5550")
(set T.taglist_fg_occupied "#789")
(set T.taglist_fg_urgent "#a55")
(set T.taglist_names [ "" "" "" "" "" "" "" "" "" ])
(set T.taglist_spacing (dpi 5))
(set T.taglist_disable_icon true)
;; Symbols   

;; systray
(set T.systray_icon_spacing (dpi 3))
(set T.bg_systray "#13131300")

;; calendar
(set T.calendar_spacing (dpi 5))
(set T.calendar_long_weekdays true)

;; }}}

;; Menu {{{

(set T.menu_height (dpi 15))
(set T.menu_width (dpi 100))

;; }}}

;; Icons {{{

(set T.layout_floating (.. ICON_DIR "/floating.png"))
(set T.layout_max (.. ICON_DIR "/max.png"))
(set T.layout_tile (.. ICON_DIR "/tile.png"))
(set T.brightness-icon (.. ICON_DIR "/brightness.png"))
(set T.volume-icon (.. ICON_DIR "/volume.png"))
(set T.volume-mute-icon (.. ICON_DIR "/volume-mute.png"))

;; Generate awesome icon
(set T.awesome_icon
  (theme_assets.awesome_icon T.menu_height T.bg_focus T.fg_focus))

;; }}}

;; Misc {{{

;; Edge snap
(set T.snap_bg "#cccccc")
(set T.snap_border_width (dpi 1))

;; }}}

T

;; vim: et:sw=2:fdm=marker:tw=80
