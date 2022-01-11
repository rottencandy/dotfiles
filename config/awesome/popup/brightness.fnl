(local beautiful (require "beautiful"))
(local gears (require "gears"))
(local popup (require "popup/popup"))

(local (window bar) (popup.create beautiful.brightness-icon))

(local timer (gears.timer {
  :timeout 3
  :single_shot true
  :callback (fn [] (set window.visible false))
}))

(awesome.connect_signal "signal::brightness" (fn [amt]
  (set window.visible true)
  (set bar.value amt)
  (timer:again)))

;; vim: et:sw=2:fdm=marker:tw=80
