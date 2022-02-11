(local awful (require "awful"))
(local U (require "util"))

(local interval 30)
;; watch charger file
;; use '{printf \"%f\", \$3}' & tonumber to get number
(local ram-script "
sh -c \"free -h | rg Mem | awk '{print $3}'\"
")

(awful.widget.watch ram-script interval (fn [widget stdout]
  (let [ram (U.trim stdout)]
    (awesome.emit_signal "signal::ram" ram))))

;; vim: et:sw=2:fdm=marker:tw=80
