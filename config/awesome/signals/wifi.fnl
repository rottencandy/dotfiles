(local awful (require "awful"))

(local watch-script "
nmcli connection monitor
")

(local wifi-script "
sh -c \"nmcli device | rg -e '\\bconnecting\\b' | awk 'NF{print $NF}'\"
")

(fn emit-wifi-info []
  (awful.spawn.easy_async wifi-script (fn [output]
    (awesome.emit_signal "signal::wifi" output))))

;; kill old instance
(awful.spawn.easy_async_with_shell "pkill nmcli" (fn []
  (awful.spawn.with_line_callback watch-script { :stdout emit-wifi-info })))

;; vim: et:sw=2:fdm=marker:tw=80
