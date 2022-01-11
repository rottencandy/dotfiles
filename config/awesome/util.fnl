(local naughty (require "naughty"))

(local util {

  :trim (fn [s]
    " Trim whitespace from strings. Source: PIL 20.4"
    (s:gsub "^%s*(.-)%s*$" "%1"))

  :in-bool (fn [v]
    "Cast value to boolean"
    (or (and v true) false))

  :!= (fn [x y]
    "Not equal to"
    (not (= x y)))

  :?? (fn [condition x y]
    "Ternary operator, `condition ? x : y` "
    (or (and condition x) y))

  :notify (fn [title msg]
    "Create quick notification"
    (naughty.notify { :title title :text msg }))

  })

util

;; vim: et:sw=2:fdm=marker:tw=80
