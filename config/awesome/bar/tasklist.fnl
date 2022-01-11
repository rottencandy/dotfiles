(local awful (require "awful"))
(local gears (require "gears"))
(local wibox (require "wibox"))
(local U (require "util"))

(local modkey :Mod1)

(local buttons (gears.table.join

  (awful.button [] 1 (fn [c]
    (if (= c client.focus)
      (set c.minimized true)
      (c:emit_signal "request::activate" "titlebar" {:raise true}))))

))

(fn [s] (awful.widget.tasklist {
  :screen s
  :filter awful.widget.tasklist.filter.currenttags
  :buttons buttons
  :layout {
    :spacing_widget {
      1 {
        :forced_width 5
        :forced_height 24
        :thickness 1
        ; TODO: move all colors to theme file
        :color "#777"
        :widget wibox.widget.separator
      }
      :valign "center"
      :halign "center"
      :widget wibox.container.place
    }
    :spacing 1
    :layout wibox.layout.fixed.horizontal
  }
  ; Notice that there is *NO* wibox.wibox prefix, it is a template,
  ; not a widget instance.
  :widget_template {
    1 {
      1 (wibox.widget.base.make_widget)
      :forced_height 5
      :id "background_role"
      :widget wibox.container.background
    }
    2 {
      1 {
        :id "clienticon"
        :widget awful.widget.clienticon
      }
      :margins 5
      :widget wibox.container.margin
    }
    3 nil
    :create_callback (fn [self c index objects]
      (let [child (. (self:get_children_by_id "clienticon") 1)]
        (set child.client c)))
    :layout wibox.layout.align.vertical
  }
}))

;; vim: et:sw=2:fdm=marker:tw=80
