(local gears (require "gears"))
(local awful (require "awful"))
(local naughty (require "naughty"))
(local hotkeys-popup (require "awful.hotkeys_popup"))

;; enable additional help for supported apps
(require "awful.hotkeys_popup.keys")

(local menubar (require "menubar"))
(set menubar.utils.terminal _G.TERMINAL)

;; Constants {{{

(local superkey :Mod4)
(local alt :Mod1)
(local shift :Shift)
(local ctrl :Control)
(local enter :Return)
(local client-move-dist 50)
(local XIDLEHOOK_SOCKET "/tmp/xidlehook.sock")
;; `pactl list [sinks|sources] short` to list sinks or sources
(local VOLUME_UP "sh -c 'pactl set-sink-mute 43 false ; pactl set-sink-volume 43 +5%'")
(local VOLUME_DOWN "sh -c 'pactl set-sink-mute 45 false ; pactl set-sink-volume 43 -5%'")
(local VOLUME_TOGGLE "pactl set-sink-mute 43 toggle")
(local MIC_TOGGLE "pactl set-source-mute 44 toggle")
(local APPS "rofi -show drun")
(local EXECUTABLES "rofi -show run")
(local RUNNING-APPS "rofi -show window")

;; }}}

;; Utils {{{

(fn show-help []
  (hotkeys-popup.show_help nil (awful.screen.focused)))

(fn open-launcher []
  (awful.spawn APPS))

;; }}}

(local keys {})

(set keys.globalkeys (gears.table.join 
  ;; General {{{

  (awful.key [superkey shift] :r
    awesome.restart
    {:description "reload awesome" :group "awesome" })
  (awful.key [superkey shift] :Escape
    awesome.quit
    {:description "quit awesome" :group "awesome" })
  (awful.key [superkey] :w
    show-help
    {:description "show help" :group "awesome" })

  ;; Notifications
  (awful.key [ctrl] :space
    naughty.destroy_all_notifications
    {:description "Clear all notifications" :group "awesome" })

  ;; }}}

  ;; Navigation {{{

  (awful.key [superkey] :k
    (fn [] (awful.client.focus.global_bydirection :up))
    {:description "focus up" :group "navigation" })
  (awful.key [superkey] :j
    (fn [] (awful.client.focus.global_bydirection :down))
    {:description "focus down" :group "navigation" })
  (awful.key [superkey] :h
    (fn [] (awful.client.focus.global_bydirection :left))
    {:description "focus left" :group "navigation" })
  (awful.key [superkey] :l
    (fn [] (awful.client.focus.global_bydirection :right))
    {:description "focus right" :group "navigation" })

  ;; Jumping
  (awful.key [superkey] "`"
    awful.tag.history.restore
    {:description "previous tag" :group "navigation" })
  (awful.key [superkey] :Tab
    (fn []
      (awful.client.focus.history.previous)
      (if client.focus
        (client.focus:raise)))
    {:description "previous application" :group "navigation" })

  (awful.key [superkey] :u
    awful.client.urgent.jumpto
    {:description "jump to urgent client" :group "navigation" })
  (awful.key [superkey ctrl] :j
    (fn [] (awful.screen.focus_bydirection :down))
    {:description "focus on bottom screen" :group "navigation" })
  (awful.key [superkey ctrl] :k
    (fn [] (awful.screen.focus_bydirection :up))
    {:description "focus on top screen" :group "navigation" })
  (awful.key [superkey ctrl] :h
    (fn [] (awful.screen.focus_bydirection :left))
    {:description "focus on left screen" :group "navigation" })
  (awful.key [superkey ctrl] :l
    (fn [] (awful.screen.focus_bydirection :right))
    {:description "focus on right screen" :group "navigation" })

  ;; }}}

  ;; Layout {{{

  (awful.key [superkey] :space
    (fn [] (awful.layout.inc 1))
    {:description "select next layout" :group "layout" })
  (awful.key [superkey shift] :space
    (fn [] (awful.layout.inc -1))
    {:description "select prev layout" :group "layout" })

  ;; Gaps
  (awful.key [superkey shift] :minus
    (fn [] (awful.tag.incgap 5 nil))
    {:description "increment gaps for current tag" :group "layout" })
  (awful.key [superkey] :minus
    (fn [] (awful.tag.incgap -5 nil))
    {:description "decrement gaps for current tag" :group "layout" })

  (awful.key [superkey shift] :j
    (fn [] (awful.client.swap.byidx 1))
    {:description "swap with next client by index" :group "layout" })
  (awful.key [superkey shift] :k
    (fn [] (awful.client.swap.byidx -1))
    {:description "swap with prev client by index" :group "layout" })

  ;; }}}

  ;; Programs {{{

  ;; Terminal(s)
  (awful.key [superkey] enter
    (fn [] (awful.spawn.with_shell "WINIT_X11_SCALE_FACTOR=1 alacritty"))
    {:description "spawn terminal" :group "programs" })
  (awful.key [superkey shift] enter
    (fn [] (awful.spawn _G.TERMINAL))
    {:description "spawn alt terminal" :group "programs" })

  ;; Scrot
  (awful.key [superkey shift] :s
    (fn []
      (awful.spawn.with_shell
        "maim ~/screenshots/screenshot-$(date +%s).png 2> /dev/null")
      (naughty.notify
        { :title "Screenshot saved" :text "Screenshot saved" :timeout 3 }))
    {:description "take screenshot" :group "programs" })

  ;; Launcher
  (awful.key [superkey] :d
    open-launcher
    {:description "App launcher(rofi)" :group "programs" })
  (awful.key [superkey] :r
    (fn [] (awful.spawn RUNNING-APPS))
    {:description "App selector(rofi)" :group "programs" })
  (awful.key [superkey] :e
    (fn [] (awful.spawn EXECUTABLES))
    {:description "Executable runner(rofi)" :group "programs" })

  ;; Lock
  (awful.key [superkey] :p
    (fn [] (awful.spawn.with_shell (.. _G.HOME "/.scripts/lockscreen")))
    {:description "Lock screen" :group "programs" })

  (awful.key [superkey] :n
    (fn []
      (awful.spawn.with_shell
        "cd ~/nb && WINIT_X11_SCALE_FACTOR=1 alacritty -e nvim _temp.md"))
    {:description "Useless shortcut" :group "programs" })

  ;; }}}

  ;; Hardware controls {{{

  ;; Volume
  (awful.key [] :XF86AudioRaiseVolume
    (fn [] (awful.spawn VOLUME_UP false))
    {:description "Raise volume" :group "hardware" })
  (awful.key [] :XF86AudioLowerVolume
    (fn [] (awful.spawn VOLUME_DOWN false))
    {:description "Lower volume" :group "hardware" })
  (awful.key [] :XF86AudioMute
    (fn [] (awful.spawn VOLUME_TOGGLE false))
    {:description "Toggle volume" :group "hardware" })
  (awful.key [] :XF86AudioMicMute
    (fn [] (awful.spawn MIC_TOGGLE false))
    {:description "Toggle mic" :group "hardware" })

  ;; Non-media keyboards
  (awful.key [superkey] :F1
    (fn [] (awful.spawn VOLUME_UP false))
    {:description "Raise volume" :group "hardware" })
  (awful.key [superkey] :F2
    (fn [] (awful.spawn VOLUME_DOWN false))
    {:description "Lower volume" :group "hardware" })
  (awful.key [superkey] :F3
    (fn [] (awful.spawn VOLUME_TOGGLE false))
    {:description "Toggle volume" :group "hardware" })
  (awful.key [superkey] :F4
    (fn [] (awful.spawn MIC_TOGGLE false))
    {:description "Toggle mic" :group "hardware" })

  ;; Brightness
  (awful.key [] :XF86MonBrightnessUp
    (fn [] (awful.spawn "xbacklight -inc 5%" false))
    {:description "Increase brightness" :group "hardware" })
  (awful.key [] :XF86MonBrightnessDown
    (fn [] (awful.spawn "xbacklight -dec 5%" false))
    {:description "Decrease brightness" :group "hardware" })

  ;; }}}
))

;; Client {{{

(set keys.clientkeys (gears.table.join
  ;; Move client
  (awful.key [superkey] :Up
    (fn [c] (c:relative_move 0 (- client-move-dist) 0 0))
    {:description "move client up" :group "navigation" })
  (awful.key [superkey] :Down
    (fn [c] (c:relative_move 0 client-move-dist 0 0))
    {:description "move client down" :group "navigation" })
  (awful.key [superkey] :Left
    (fn [c] (c:relative_move (- client-move-dist) 0 0 0))
    {:description "move client left" :group "navigation" })
  (awful.key [superkey] :Right
    (fn [c] (c:relative_move client-move-dist 0 0 0))
    {:description "move client right" :group "navigation" })

  ;; Fullscreen
  (awful.key [superkey] :f
    (fn [c]
      (set c.fullscreen (not c.fullscreen))
      (c:raise))
    {:description "toggle fullscreen" :group "navigation" })
  (awful.key [superkey] :m
    (fn [c]
      (set c.maximized (not c.maximized))
      (c:raise))
    {:description "toggle maximize" :group "navigation" })

  ;; Kill client
  (awful.key [superkey shift] :q
    (fn [c] (c:kill))
    {:description "close" :group "navigation" })

  ;; Pin
  (awful.key [superkey] :t
    (fn [c]
      (set c.ontop (not c.ontop)))
    {:description "toggle pin to top" :group "navigation" })))

;;; }}}

;; Mouse {{{

(local mousemenu
  (awful.menu { :items [
    [ :Terminal _G.TERMINAL ]
    [ :Apps open-launcher ]
    [ :Help show-help ]
    [ :Awesome [
      [ :Restart awesome.restart ]
      [ :Quit awesome.quit ]
    ]]
  ]}))

;; root binds
(set keys.mousebuttons (gears.table.join
  (awful.button [] 1 (fn [] (mousemenu:hide)))
  (awful.button [] 3 (fn [] (mousemenu:toggle)))))

;; client binds
(set keys.clientbuttons (gears.table.join
  (awful.button [] 1
    (fn [c] (c:emit_signal "request::activate" "mouse_click" {:raise true})))
  (awful.button [superkey] 1
    (fn [c]
      (c:emit_signal "request::activate" "mouse_click" {:raise true})
      (awful.mouse.client.move c)))
  (awful.button [superkey] 3
    (fn [c]
      (c:emit_signal "request::activate" "mouse_click" {:raise true})
      (awful.mouse.client.resize c)))))
; TODO: move client(jump) to cursor
; look at awful.placement.no_offscreen

;;; }}}

;; Tags {{{

(for [i 1 9]
  (set keys.globalkeys (gears.table.join
    keys.globalkeys

    (awful.key [superkey] (.. "#" (+ i 9))
      (fn []
        (let [screen (awful.screen.focused)
              tag (. screen.tags i)]
          (if tag (tag:view_only))))
      ;{:description (.. "view tag #" i) :group "tag"}
      )

    (awful.key [superkey shift] (.. "#" (+ i 9))
      (fn []
        (if client.focus
          (let [tag (. client.focus.screen.tags i)]
            (if tag
              (client.focus:move_to_tag tag)))))
      ;{:description (.. "move to tag #" i) :group "tag"}
      ))))

;; }}}

keys

;; vim: et:sw=2:fdm=marker:fdl=0:tw=80
