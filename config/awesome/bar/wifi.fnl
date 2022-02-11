(local awful (require "awful"))
(local wibox (require "wibox"))

(local wifi-widget (wibox.widget {
  :text "睊"
  :align "center"
  :valign "center"
  :widget wibox.widget.textbox
}))

(local tooltip (awful.tooltip {
  :objects [ wifi-widget ]
  :text :Disconnected
}))

(awesome.connect_signal "signal::wifi"
  (fn [value] (set tooltip.text (or value :Disconnected))))

wifi-widget

;; vim: et:sw=2:fdm=marker:tw=80
