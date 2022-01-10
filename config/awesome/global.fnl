(set _G.HOME (os.getenv "HOME"))
(set _G.TERMINAL "st")
(set _G.EDITOR (or (os.getenv "EDITOR") "vim"))
(set _G.EDITOR_CMD (.. _G.TERMINAL " -e " _G.EDITOR))
(set _G.CONFIG_DIR (.. _G.HOME "/.config/awesome"))

;; vim: et:sw=2:fdm=marker:tw=80
