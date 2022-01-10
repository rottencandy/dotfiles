(local awful (require "awful"))
(local U (require "util"))

(var current-vol -1)
(var current-muted -1)

(fn emit-vol-info []
  (awful.spawn.easy_async "pactl list sinks" (fn [output]
    (local volume (tonumber (output:match "(%d+)%%")))
    (local muted  (U.in-bool (output:match "Mute:(%s+)[yes]")))

    (if (or (U.!= current-vol volume) (U.!= current-muted muted))
      (do
        (awesome.emit_signal "signal::volume" volume muted)
        (set current-vol volume)
        (set current-muted muted))))))

(local vol-script "
sh -c '
pactl subscribe 2> /dev/null | rg --line-buffered sink
'")

;; kill old instance
(awful.spawn.easy_async_with_shell "pkill pactl" (fn []
  (awful.spawn.with_line_callback vol-script { :stdout emit-vol-info })))

;; vim: et:sw=2:fdm=marker:tw=80
