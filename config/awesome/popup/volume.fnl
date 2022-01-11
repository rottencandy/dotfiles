(local beautiful (require "beautiful"))
(local gears (require "gears"))
(local U (require "util"))
(local popup (require "popup/popup"))

(local (window bar icon) (popup.create beautiful.volume-icon))

(local timer (gears.timer {
  :timeout 3
  :single_shot true
  :callback (fn [] (set window.visible false))
}))

(awesome.connect_signal "signal::volume" (fn [volume muted]
  (set window.visible true)
  (set bar.value (U.?? muted 0 volume))
  (set icon.image (U.?? muted beautiful.volume-mute-icon beautiful.volume-icon))
  (timer:again)))

;; vim: et:sw=2:fdm=marker:tw=80
