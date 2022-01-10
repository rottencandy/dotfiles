(local awful (require "awful"))
(local gears (require "gears"))

(local modkey :Mod1)

(local buttons (gears.table.join
  (awful.button [] 1 (fn [t] (t:view_only)))

  (awful.button [ modkey ] 1 (fn [t]
    (if client.focus (client.focus:toggle_tag t))))

  (awful.button [] 3 awful.tag.viewtoggle)

  (awful.button [ modkey ] 3 (fn [t]
    (if client.focus (client.focus:toggle_tag t))))

  ;; mouse scroll to switch
  (awful.button [] 4 (fn [t] awful.tag.viewnext t.screen))
  (awful.button [] 5 (fn [t] awful.tag.viewprev t.screen))

))

(fn [s] (awful.widget.taglist {
  :screen s
  :filter awful.widget.taglist.filter.all
  ;; disable mouse controls ...for now
  ;:buttons buttons
}))

;; vim: et:sw=2:fdm=marker:tw=80
