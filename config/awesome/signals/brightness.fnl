(local awful (require "awful"))

(fn emit-brightness-info []
  (awful.spawn.easy_async "xbacklight -get" (fn [output]
    (let [brightness (tonumber output)]
      (awesome.emit_signal "signal::brightness" brightness)))))

(local battery-script "
sh -c '
inotifywait -e modify -m /sys/class/backlight/intel_backlight/brightness
'")

;; kill old instance
(awful.spawn.easy_async_with_shell "ps x | rg \"inotifywait -e modify -m
/sys/class/backlight/intel_backlight/brightness\" | rg -v rg | awk '{print $1}'
| xargs kill" (fn []
  (awful.spawn.with_line_callback battery-script {
    :stdout emit-brightness-info })))

;; vim: et:sw=2:fdm=marker:tw=80
