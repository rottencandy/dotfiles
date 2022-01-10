(local wibox (require "wibox"))

(local prefix "")

(local temp-widget (wibox.widget {
  :text ".."
  :align "center"
  :valign "center"
  :widget wibox.widget.textbox
}))

(awesome.connect_signal "signal::temp" (fn [temp]
  (set temp-widget.text (.. prefix temp))))

temp-widget

;; vim: et:sw=2:fdm=marker:tw=80
