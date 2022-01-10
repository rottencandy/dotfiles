(local wibox (require "wibox"))

(local prefix "")

;; TODO add color
(local ram-widget (wibox.widget {
  :text "..."
  :align "center"
  :valign "center"
  :font "Hack Nerd Font Mono 12"
  :widget wibox.widget.textbox
}))

(awesome.connect_signal "signal::ram" (fn [ram]
  (set ram-widget.text (.. prefix ram))))

ram-widget

;; vim: et:sw=2:fdm=marker:tw=80
