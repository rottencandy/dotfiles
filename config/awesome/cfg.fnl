(require "global")
(local awful (require "awful"))
(local gears (require "gears"))
(local naughty (require "naughty"))
(local wibox (require "wibox"))
(require "awful.autofocus")

(local beautiful (require "beautiful"))
(beautiful.init (require "theme"))

(require "popup/init")
(require "signals/init")
(local keys (require "keys"))
(local bar (require "bar/init"))

;; CONSTANTS {{{

(local theme (beautiful.get))
(local L awful.layout.suit)

;; }}}

;; STARTUP {{{

(root.keys keys.globalkeys)
(root.buttons keys.mousebuttons)
(awful.spawn.with_shell (.. _G.HOME "/.config/startup.sh"))

(set awful.layout.layouts [L.floating L.tile L.max])
;; All layouts:
;; floating, tile, max, fair, tile.left, tile.bottom, tile.top,
;; fair.horizontal, spiral, spiral.dwindle, max.fullscreen, magnifier,
;; corner.nw, corner.ne, corner.sw, corner.se

(awful.screen.connect_for_each_screen (fn [s]
  ;; TODO or theme.taglist_names
  (let [names (or theme.taglist_names [ :一 :二 :三 :四 :五 :六 :七 :八 :九 ])
        layouts [
                  L.floating
                  L.tile
                  L.floating
                  L.floating
                  L.floating
                  L.floating
                  L.floating
                  L.floating
                  L.floating
                ]]
    (awful.tag names s layouts)
    (bar s))))

;; Garbage collection(for lower memory consumption)
(collectgarbage "setpause" 110)
(collectgarbage "setstepmul" 1000)

;; {{{ Error handling

;; Check if awesome encountered an error and fell back to
;; another config (This code will only ever execute for the fallback config)
(if awesome.startup_errors
  (naughty.notify { :title "Oops, there were errors during startup!"
                    :text awesome.startup_errors }))

;; Handle runtime errors after startup
(do
  (var in-error false)
  (awesome.connect_signal "debug::error"
    (fn [err]
      (if (not in-error)
        (do
          (set in-error true)
          (naughty.notify { :title "Oops, an error occured!"
                             :text (tostring err)})
          (set in-error true))))))

;; }}}

;; }}}

;; UTILS {{{

(fn set-wallpaper [s]
  "Set wallpaper using value from beautiful.wallpaper (can be string or fn)"
  (let [wall (match (type beautiful.wallpaper)
               "function" (beautiful.wallpaper s)
               "string" beautiful.wallpaper)]
    (if wall (gears.wallpaper.maximized wall s true))))

;; }}}

;; Client rules {{{

;; Use `xprop | rg WM_CLASS` to find client class
;; Rules to apply to new clients (through the 'manage' signal).
;;
;; Note that the name property shown in xprop might be set
;; slightly after creation of the client and the name shown there
;; might not match defined rules here.

(set awful.rules.rules [
  ;; All clients will match this rule.
  {
    :rule []
    :properties {
      :border_width beautiful.border_width
      :border_color beautiful.border_normal
      :focus awful.client.focus.filter
      :raise true
      :keys keys.clientkeys
      :buttons keys.clientbuttons
      :screen awful.screen.preferred
      :placement (+ awful.placement.centered awful.placement.no_offscreen)
    }
  }

  ;; Floating only clients
  {
    :rule_any {
      :instance []
      :class [
        :Arandr
        :Blueman-manager
        :Gpick
        "GNU Image Manipulation Program"
        :Gimp
        "Tor Browser"
        :Lxappearance
        :Pavucontrol
        :feh
        :mpv
        :Dwarf_Fortress
      ]
      :name [ "Event Tester" ] ; xev
      :role [
              "AlarmWindow"   ; Thunderbird's calendar
              "ConfigManager" ; Thunderbird's about:config
              "pop-up"        ; e.g. Google Chrome's (detached) Developer Tools
      ]
    }
    :properties { :floating true }
  }
  ;; Add titlebars to normal clients and dialogs
  {
    :rule_any { :type [ :normal :dialog ] }
    :properties { :titlebars_enabled true }
  }
  ;; Clients without titlebar
  {
    :rule_any { :class [:St :Alacritty :Firefox ] }
    :properties { :titlebars_enabled false }
  }
])

;; }}}

;; Signals {{{

;; Add a titlebar if titlebars_enabled is set to true in the rules.
(client.connect_signal "request:titlebars" (fn [c]
  ;; buttons for the titlebar
  (let [buttons (gears.table.join
         (awful.button [] 1 (fn []
           (c:emit_signal "request::activate" "titlebar" {:raise true})
           (awful.mouse.client.move c)))
         (awful.button [] 3 (fn []
           (c:emit_signal "request::activate" "titlebar" {:raise true})
           (awful.mouse.client.resize c))))
        titlebar (awful.titlebar c)]
    (titlebar:setup
      {
        ;; left
        1 {
          :buttons buttons
          :layout wibox.layout.fixed.horizontal
          :widget (awful.titlebar.widget.iconwidget c)
        }
        ;; middle
        2 {
          ;; title
          1 {
            :align :center
            :widget (awful.titlebar.widget.titlewidget c)
          }
          :buttons buttons
          :layout wibox.layout.flex.horizontal
        }
        :layout wibox.layout.align.horizontal
      }))))

;; Signal function to execute when a new client appears
(client.connect_signal "manage" (fn [c]
  (set c.shape gears.shape.rounded_rect)

  ;; Prevent clients from being unreachable after screen count changes
  (if (and awesome.startup
           (not c.size_hints.user_position)
           (not c.size_hints.program_position))
    (awful.placement.no_offscreen c))))

(client.connect_signal "focus" (fn [c]
  (set c.border_color beautiful.border_focus)))
(client.connect_signal "unfocus" (fn [c]
  (set c.border_color beautiful.border_normal)))

;; }}}

;; vim: et:sw=2:fdm=marker:tw=80
