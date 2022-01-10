(local awful (require "awful"))
(local beautiful (require "beautiful"))
(local gears (require "gears"))
(local naughty (require "naughty"))
(local wibox (require "wibox"))
(local U (require "util"))

(local icon (wibox.widget {
  :image beautiful.awesome_icon
  :resize false
  :widget wibox.widget.textbox
}))

(local bar (wibox.widget {
  :max_value 100
  :value 0
  :forced_width 150
  :forced_height 30
  :shape gears.shape.rounded_rect
  :color "#4aa96c"
  :background_color "#ededd0"
  :widget wibox.widget.progressbar
}))

(local popup (awful.popup {
  :visible false
  :ontop true
  :placement awful.placement.centered
  :shape gears.shape.rounded_rect
  :widget (wibox.widget {
    1 icon
    2 bar
    :layout wibox.layout.align.vertical
  })
}))

(local timer (gears.timer {
  :timeout 3
  :single_shot true
  :callback (fn [] (set popup.visible false))
}))

(awesome.connect_signal "signal::brightness" (fn [volume muted]
  (set popup.visible true)
  (set bar.value (U.?? muted 0 volume))
  (timer:again)))

;; vim: et:sw=2:fdm=marker:tw=80
