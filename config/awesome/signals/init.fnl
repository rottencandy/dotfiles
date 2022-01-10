(each [_ m (pairs [:battery :volume :brightness :ram :temp])]
  (require (.. "signals." m)))

;; vim: et:sw=2:fdm=marker:tw=80
