(local awful (require "awful"))
(local util (require "util"))

(local interval 30)
(local battery-script "sh -c 'acpi --battery'")

(awful.widget.watch battery-script interval (fn [widget stdout]
  (let [percentage (tonumber (stdout:match "(%d+)%%"))
        charging (util.in-bool (stdout:match "Charging"))]
     (awesome.emit_signal "signal::battery" percentage charging))))

;; vim: et:sw=2:fdm=marker:tw=80
