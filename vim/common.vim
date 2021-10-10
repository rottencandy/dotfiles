set encoding=utf8
scriptencoding utf-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ⡀⢀ ⠄ ⣀⣀  ⡀⣀ ⢀⣀
" ⠱⠃ ⠇ ⠇⠇⠇ ⠏  ⠣⠤
"

"Plugins {{{

" vimkubectl
set rtp+=~/code/vim/vimkubectl
" fzf
set rtp+=~/apps/fzf

" % jump to matching xml tags, if/else/endif, etc.
packadd! matchit


let g:vim_markdown_folding_disabled = 1     " Disable vim-markdown folds by default
let g:vim_markdown_frontmatter = 1          " Highlight YAML front matter
let g:vim_markdown_conceal = 1
let g:vim_markdown_conceal_code_blocks = 1

" }}}

"Appearance {{{

" Enable 24-bit RGB color
if (has('termguicolors'))
  set termguicolors
endif

" Set and configure the color scheme
syntax enable           " enable syntax highlighting
colorscheme moonfly
" Highlight embedded lua in .vim
let g:vimsyn_embed = 'l'
" Transparent background
"autocmd vimenter * hi! Normal ctermbg=NONE guibg=NONE
"autocmd vimenter * hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

set background=dark
set number              " Show line numbers
set relativenumber      " Relative line numbering
set showcmd             " Display partially typed command
set lazyredraw          " Do not redraw on macro/regs/untyped commands
set showmatch           " Highlight matching [{()}]
set hlsearch            " Highlight search matches
set scrolloff=0         " Scroll offset
set conceallevel=2      " Enable text conceal (for vim-markdown)

" Disable all error bells
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Make active buffer more obvious
augroup BufFocus
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END

" {{{ Transparency

"hi Normal ctermbg=NONE 
"function! AdaptColorscheme()
"  highlight clear CursorLine
"  highlight Normal ctermbg=none
"  highlight LineNr ctermbg=none
"  highlight Folded ctermbg=none
"  highlight NonText ctermbg=none
"  highlight SpecialKey ctermbg=none
"  highlight VertSplit ctermbg=none
"  highlight SignColumn ctermbg=none
"endfunction
"autocmd ColorScheme * call AdaptColorscheme()
"
"hi Normal guibg=NONE ctermbg=NONE
"hi CursorColumn cterm=NONE ctermbg=NONE ctermfg=NONE
"hi CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE
"hi CursorLineNr cterm=NONE ctermbg=NONE ctermfg=NONE
"hi clear SignColumn
"highlight cursorline ctermbg=none
"highlight cursorlineNR ctermbg=none
"highlight clear LineNr
"highlight clear SignColumn
"
"set cursorline
"set noshowmode
"" Enable CursorLine
"set nocursorline
"" Default Colors for CursorLine
"hi CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE
"
"" Change Color when entering Insert Mode
"autocmd InsertEnter * set nocursorline
"
"" Revert Color to default when leaving Insert Mode
"autocmd InsertLeave * set nocursorline

" }}}

" }}}

"Behavior {{{

filetype plugin indent on " Load filetype-specific configuration
set modeline              " Read vim modeline configs
" Swap files directory
set directory=$HOME/.vim/swapfiles//
set backupdir=$HOME/.vim/swapfiles//

set nrformats="bin,hex" " define bases for <C-a> and <C-x> math operations
set history=1000        " Remember more stuff
set tabpagemax=50       " Max tab pages

" Backspace works on autoindent, line break and start of insert
set backspace=indent,eol,start
set autoindent
set wrap

set ffs=unix,dos,mac    " Standard file type as Unix
set autoread            " automatically read when file is changed from outside
set wildmenu            " Completion dropdown-thing
set hidden              " Hide unsaved buffers instead of closing
"set confirm             " Prompt if exiting without saving
set mouse=a             " Use mouse for all modes
set regexpengine=0      " Explicitly disable old regex engine

set incsearch           " Search as characters are entered
set ignorecase          " Ignore case
set smartcase           " Except if there is a capital letter

set splitbelow          " New split goes below
set splitright          " and to right
set foldenable          " Enable code folding
set foldnestmax=10      " Max 10 nested folds
set foldlevel=0         " Close all folds by default
set formatoptions+=j    " Delete comment character when joining commented lines
set shortmess+=c        " Do not pass messages to ins-completion-menu

" Break line joins into multiple edits
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
"inoremap <CR> <C-G>u<CR>

" :h :mkview
set sessionoptions-=options
set viewoptions-=options

fun! FoldText()
  let line = getline(v:foldstart)
  let line = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')  " }}}

  let offset = 16
  let space = repeat(' ', winwidth(0) - strdisplaywidth(line) - offset) 
  let lines = v:foldend-v:foldstart + 1

  return line . space . lines
endfun
set foldtext=FoldText()

" Use ripgrep when available
if executable('rg')
  set grepprg=rg\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" }}}

"Filetype {{{

augroup filetype_settings
  autocmd!
  " set filetypes as typescriptreact, for vim-jsx-typescript
  autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

  " GLSL
  autocmd BufNewFile,BufRead *.glslx
        \ set ft=glsl

  " JS/TS stuff
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact,javascript.jsx,typescript.tsx
        \ exec 'command! -buffer Fmt PrettierAsync' |
        \ exec 'inoreabbrev <buffer> clg console.log()<LEFT>'

  " Web stuff
  autocmd FileType json,yaml,css,scss
        \ exec 'command! -buffer Fmt PrettierAsync'

  " Use phtml as ft for html files
  "autocmd BufRead,BufNewFile *.html set ft=phtml

  " Lua stuff
  autocmd Filetype lua
        \ setlocal expandtab tabstop=4 shiftwidth=4

augroup END

" }}}

"Status line {{{

" 
set laststatus=2                " Always show statusline

let currentmode = {
      \ 'n'  : '  NORMAL ',
      \ 'i'  : '  INSERT ',
      \ 'v'  : '  VISUAL ',
      \ 'V'  : '  V·LINE ',
      \ '' : '  V·BLOCK ',
      \ 'Rv' : '  V·RPLACE ',
      \ 'R'  : '  RPLACE ',
      \ 'no' : '  NORM·OP ',
      \ 's'  : '  SELECT ',
      \ 'S'  : '  S·LINE ',
      \ '^S' : '  S·BLOCK ',
      \ 'c'  : '  COMMAND ',
      \ 'r'  : '  PROMPT ',
      \ 'rm' : '  MORE ',
      \ 'r?' : '  CONFIRM ',
      \ 'cv' : '  VIM EX ',
      \ 'ce' : '  EX ',
      \ '!'  : '  SHELL ',
      \ 't'  : '  TERMINAL ',
      \}

" |hitest.vim|

set statusline=
set statusline+=%#DiffAdd#%{currentmode[mode()]}

set statusline+=%#Cursor#
set statusline+=\ %n\             " buffer number
set statusline+=%{&paste?'\ PASTE\ ':''}
set statusline+=%{&spell?'\ SPELL\ ':''}
set statusline+=%R                " readonly flag
set statusline+=%M                " modified [+] flag
set statusline+=%#CursorLine#     " separator
set statusline+=\ %{ShortFile()}  " file name
set statusline+=%=                " right align

set statusline+=\ %Y\ \          " file type
set statusline+=%#Folded#         " color
set statusline+=%{FugitiveHead()}
set statusline+=%#CursorLine#     " color
set statusline+=\ %3l:%-2c        " line + column
set statusline+=%#Cursor#         " color
set statusline+=%3p%%\            " percentage

" }}}

"netrw {{{

nnoremap - :Fern . -reveal=%<CR>
"let g:netrw_banner = 0          " Top banner
"let g:netrw_liststyle = 3       " Directory list view
"let g:netrw_browse_split = 0    " File open behaviour
"let g:netrw_preview = 1         " Open preview files vertically
"let g:netrw_altv = 1
"let g:netrw_winsize = 17        " Size of opened buffer

" }}}

" Utils {{{

" Runs callback with visually selected text as string argument
fun! s:withSelection(callback)
  let temp = @@
  norm! gvy
  call a:callback(@@)
  let @@ = temp
endfun

" Shortened file path
fun! ShortFile()
  return pathshorten(fnamemodify(expand('%:p'), ':~:.'))
endfun

" Shortened CWD path
fun! ShortPath()
  let short = pathshorten(fnamemodify(getcwd(), ':~:.'))
  return empty(short) ? '~/' : short . (short =~ '/$' ? '' : '/')
endfun

" }}}

"Key maps {{{

" Start all searches in very magic mode
nnoremap / /\v

let mapleader = ' '             " Leader key
let maplocalleader = ';'        " Local leader key

" Search for selected content
fun! s:VSetSearch(text)
  let @/ = '\V' . substitute(escape(a:text, '\'), '\n', '\\n', 'g')
endfun
vnoremap * :<C-u>call <SID>withSelection(function('<SID>VSetSearch'))<CR>//<CR>
vnoremap # :<C-u>call <SID>withSelection(function('<SID>VSetSearch'))<CR>??<CR>

" Yank to clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

" Map redraw-screen to also clear search highlights
nnoremap <silent> <C-L> :nohl<CR>:mat<CR><C-L>

" Quickly edit and reload vimrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
"nnoremap <leader>sv :source $MYVIMRC<CR>

" Highlight trailing whitespace
nnoremap <leader>w :match Error /\v\s+$/<CR>

" Navigate panes
nnoremap <silent> <leader>h :wincmd h<CR>
nnoremap <silent> <leader>j :wincmd j<CR>
nnoremap <silent> <leader>k :wincmd k<CR>
nnoremap <silent> <leader>l :wincmd l<CR>

" Grep for word under cursor in cwd and open matched files in quickfix window
"nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<CR>:copen<CR>

" }}}

"Commands {{{

" Save file with elevated permissions
command W w !sudo tee % > /dev/null

" cd to directory of current file
command Fcd silent! lcd %:p:h

" :Move rename/move current buffer
fun! s:move_file(new_file_path)
  execute 'saveas ' . a:new_file_path
  call delete(expand('#:p'))
  bd #
endfun

command! -nargs=1 -complete=file Move call <SID>move_file(<f-args>)

" }}}

"Plugin configs {{{

" Vimkubectl configuration
let g:vimkubectl_command = 'oc'

" FZF configuration
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.7 } }
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }

let BAT_CMD = 'bat --style=plain --color=always'
let BAT_CMD_SHORT = BAT_CMD . ' --line-range :500'
let BASIC_PREVIEW = '--preview "' . BAT_CMD_SHORT . ' {}"'
let BUFLINE_PREVIEW = '--delimiter \" --preview "' . BAT_CMD_SHORT . ' {2}"'
let RG_PREVIEW = '--delimiter
      \ : --preview "' . BAT_CMD . ' {1} --highlight-line {2}"
      \ --preview-window "+{2}/2"'

" List open buffers
fun! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfun

" Get bufno from bufline
fun! s:bufnumber(bufline)
  return matchstr(a:bufline, '^[ 0-9]*')
endfun

" Open buffer
fun! s:bufopen(bufline)
  if len(a:bufline) != 2
    return
  endif
  let cmd = get({'ctrl-s': 'sbuffer',
        \ 'ctrl-v': 'vert sbuffer',
        \ 'ctrl-t': 'tabnew | buffer'},
        \ a:bufline[0], 'buffer')
  execute cmd s:bufnumber(a:bufline[1])
endfun

" Close buffer
fun! s:bufclose(buflines)
  if len(a:buflines) == 0
    return
  endif
  for each in a:buflines
    execute 'bdelete ' . s:bufnumber(each)
  endfor
endfun

" Move to dir
fun! s:navigate(dir)
  if len(a:dir) == 0
    return
  endif
  execute 'cd ' . a:dir
  echo a:dir
endfun

" Open file
fun! s:openFileAtLocation(result)
  if len(a:result) == 0
    return
  endif
  let filePos = split(a:result, ':')
  exec 'edit +' . l:filePos[1] . ' ' . l:filePos[0]
endfun

fun! s:startFuzzySearch(initialQuery)
  " VimL can't do var scopes smh... :/
  let BAT_CMD = 'bat --style=plain --color=always'
  let RG_PREVIEW = '--delimiter
        \ : --preview "' . BAT_CMD . ' {1} --highlight-line {2}"
        \ --preview-window "+{2}/2"'
  let opts = {}
  let opts.source = 'rg --line-number ''.*'''
  let opts.sink = function('<sid>openFileAtLocation')
  let opts.options = '--query "' . a:initialQuery . '" ' . RG_PREVIEW
  call fzf#run(fzf#wrap(opts))
endfun

fun! s:RgWithFzf(initialQuery)
  " VimL can't do var scopes smh... :/
  let BAT_CMD = 'bat --style=plain --color=always'
  let RG_PREVIEW = '--delimiter
        \ : --preview "' . BAT_CMD . ' {1} --highlight-line {2}"
        \ --preview-window "+{2}/2"'
  let opts = {}
  let opts.options = '--disabled
        \ --ansi
        \ --bind "ctrl-r:reload:rg -i --line-number {q} || true"
        \ --query "' . a:initialQuery . '"
        \ --header="Run search with CTRL+r"
        \ ' . RG_PREVIEW
  let opts.sink = function('<sid>openFileAtLocation')
  call fzf#run(fzf#wrap(opts))
endfun

" Open files
nnoremap <silent> <Leader>f :call fzf#run(fzf#wrap({
      \   'source':  'fd --type f',
      \   'options': BASIC_PREVIEW,
      \ }))<CR>
"nnoremap <silent> <leader>f :FZF<CR>

" Select from open buffers
nnoremap <silent> <Leader>b :call fzf#run(fzf#wrap({
      \   'source':  reverse(<sid>buflist()),
      \   'sink*':   function('<sid>bufopen'),
      \   'options': '--expect=ctrl-t,ctrl-v,ctrl-s ' . BUFLINE_PREVIEW,
      \ }))<CR>

" Close buffers
nnoremap <silent> <Leader>B :call fzf#run(fzf#wrap({
      \   'source':  reverse(<sid>buflist()),
      \   'sink*': function('<sid>bufclose'),
      \   'options': BUFLINE_PREVIEW,
      \ }))<CR>

" Directory selection
nnoremap <silent> <Leader>F :call fzf#run(fzf#wrap({
      \   'source': 'fd --type d',
      \   'sink':   function('<sid>navigate'),
      \ }))<CR>

" Interactive fuzzy text search
nnoremap <silent> <Leader>s :call <SID>startFuzzySearch('')<CR>
vnoremap <silent> <Leader>s :call <SID>withSelection(function('<SID>startFuzzySearch'))<CR>

" Use fzf as frontend for ripgrep
nnoremap <silent> <Leader>S :call <SID>RgWithFzf('')<CR>
vnoremap <silent> <Leader>S :call <SID>withSelection(function('<SID>RgWithFzf'))<CR>

" }}}

" vim: fdm=marker:et:sw=2: