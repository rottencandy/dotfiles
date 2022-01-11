(local awful (require "awful"))
(local gears (require "gears"))
(local wibox (require "wibox"))

(fn create-popup [img]
  "Create popup window"
  (let [
    icon (wibox.widget {
      :image img
      :forced_width 200
      :forced_height 200
      :widget wibox.widget.imagebox
    })

    bar (wibox.widget {
      :max_value 100
      :value 0
      :forced_width 150
      :forced_height 20
      :shape gears.shape.rounded_rect
      ; TODO: move all colors to theme file
      :color "#4aa96c"
      :background_color "#dde6e8"
      :widget wibox.widget.progressbar
    })

    popup (awful.popup {
      :visible false
      :ontop true
      :opacity 0.7
      :border_width 5
      :placement awful.placement.centered
      :shape gears.shape.rounded_rect
      :widget (wibox.widget {
        1 icon
        2 bar
        :layout wibox.layout.align.vertical
      })
    })
  ]
  (values popup bar icon)))

{ :create create-popup }

;; vim: et:sw=2:fdm=marker:tw=80
