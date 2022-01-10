(local awful (require "awful"))
(local gears (require "gears"))
(local wibox (require "wibox"))

(local taglist (require "bar/taglist"))
(local tasklist (require "bar/tasklist"))
(local ram (require "bar/ram"))
(local battery (require "bar/battery"))
(local temp (require "bar/temp"))

(fn [s]
  ;; tag list widget
  (local mytaglist (taglist s))
  (local mytasklist (tasklist s))
  ;; system tray
  (local systray (wibox.widget.systray true))

  ;; calendar
  (local calendar (let [c     (wibox.widget.textclock " %a")
                        popup (awful.widget.calendar_popup.month {:screen s})]
    (popup:attach c "t")
    c))

  ;; Icon indicating active layout
  (local layout-icon (awful.widget.layoutbox s))
  (layout-icon:buttons (gears.table.join
    (awful.button {} 1 (fn [] awful.layout.inc  1))
    (awful.button {} 3 (fn [] awful.layout.inc -1))
    (awful.button {} 4 (fn [] awful.layout.inc  1))
    (awful.button {} 5 (fn [] awful.layout.inc -1))))

  (local mywibox (awful.wibar {:position "top" :screen s}))

  (mywibox:setup {
    ;; left
    1 {
      1 mytaglist
      2 mytasklist
      :layout wibox.layout.fixed.horizontal
    }
    ;; center
    2 {
      :align "center"
      :widget (wibox.widget.textclock "%l:%M")
    }
    ;; right
    3 {
      1 calendar
      2 ram
      3 temp
      4 battery
      5 systray
      6 layout-icon
      :spacing 15
      :layout wibox.layout.fixed.horizontal
    }
    :layout wibox.layout.align.horizontal
  }))

;; vim: et:sw=2:fdm=marker:tw=80
