(local awful (require "awful"))
(local wibox (require "wibox"))

(local ON "")
(local OFF "")

(local notif-widget
  (wibox.widget
    {
     :text ON
     :align "center"
     :valign "center"
     :widget wibox.widget.textbox}))


(awesome.connect_signal "signal::notification"
  (fn [is-suspended] (set notif-widget.text (if is-suspended OFF ON))))

notif-widget
