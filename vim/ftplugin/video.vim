" Open detected media files appropriately
silent execute "!mplayer " . shellescape(expand("%:p")) . " &>/dev/null &" | buffer# | bdelete# | redraw! | syntax on
