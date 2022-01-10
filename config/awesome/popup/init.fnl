(each [_ m (pairs [:volume :brightness])]
  (require (.. "popup." m)))

;; vim: et:sw=2:fdm=marker:tw=80
