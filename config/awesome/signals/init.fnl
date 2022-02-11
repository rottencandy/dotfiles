(each [_ m (pairs [:battery :volume :brightness :ram :temp :wifi])]
  (require (.. "signals." m)))

;; vim: et:sw=2:fdm=marker:tw=80
