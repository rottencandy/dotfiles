(local awful (require "awful"))
(local wibox (require "wibox"))

(local MIN-BAT 25)

(local contents (wibox.widget {
  :text ".."
  :align "center"
  :valign "center"
  :widget wibox.widget.textbox
}))

(local bat-widget (wibox.widget {
  1 contents
  :min_value 0
  :max_value 100
  :value 0
  ; TODO: move all colors to theme file
  :bg "#faf3f3"
  :colors [ "#4aa96c" ]
  :thickness 3
  :rounded_edge true
  :start_angle (* 3 (/ math.pi 2))
  :widget wibox.container.arcchart
}))

(local tooltip (awful.tooltip []))
(tooltip:add_to_object bat-widget)

(awesome.connect_signal "signal::battery" (fn [percentage charging]
  (set bat-widget.value percentage)
  (set contents.text percentage)
  (if charging
    (set tooltip.text "charging")
    (set tooltip.text "discharging"))
  (if (> percentage MIN-BAT)
    (set bat-widget.colors [ "#4aa96c" ])
    (set bat-widget.colors [ "#f55c47" ])
  )))

bat-widget

;; vim: et:sw=2:fdm=marker:tw=80
