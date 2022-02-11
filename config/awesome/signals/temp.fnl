(local awful (require "awful"))

(local interval 30)
;; watch charger file
(local temp-script "
sh -c \"sensors | rg Package | awk '{printf \\\"%f\\\", $4}'\"
")

(awful.widget.watch temp-script interval (fn [widget stdout]
  (let [temp (tonumber stdout)]
    (awesome.emit_signal "signal::temp" temp))))

;; vim: et:sw=2:fdm=marker:tw=80
