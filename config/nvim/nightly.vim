set encoding=utf8
scriptencoding utf-8
set runtimepath^=~/.config/nvim/nightly runtimepath+=.config/nvim/nightly/after
let &packpath = &runtimepath
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ⡀⢀ ⠄ ⣀⣀  ⡀⣀ ⢀⣀
" ⠱⠃ ⠇ ⠇⠇⠇ ⠏  ⠣⠤
"
"Plugins {{{

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/nightly/plugged')

" Treeshitter
Plug 'nvim-treesitter/nvim-treesitter', { 'branch': '0.5-compat', 'do': ':TSUpdate' }
" Colorschemes
Plug 'bluz71/vim-moonfly-colors'
" File explorer
Plug 'lambdalisue/fern.vim'
" Closing brackets/quotes/... insertion
Plug 'Raimondi/delimitMate'
" Fugitive
Plug 'tpope/vim-fugitive'
" Markdown support
Plug 'plasticboy/vim-markdown'
" Editorconfig
Plug 'editorconfig/editorconfig-vim'
" Prettier
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
" LSP
Plug 'neovim/nvim-lspconfig'
" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Completion
Plug 'nvim-lua/completion-nvim'
" vimkubectl
set rtp+=~/code/vim/vimkubectl
" fzf
set rtp+=~/apps/fzf

" Initialize plugin system
call plug#end()

" }}}

"Appearance {{{

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

"Treesitter {{{

lua <<EOF
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { },  -- list of language that will be disabled
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  },
}
EOF

" Treesitter based folding
"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()

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

  " JS/TS stuff
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact,javascript.jsx,typescript.tsx
        \ exec 'command! -buffer Fmt PrettierAsync' |
        \ exec 'inoreabbrev <buffer> clg console.log()<LEFT>'

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
set statusline+=\ %f              " file name
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

"Key maps {{{

" Start all searches in very magic mode
nnoremap / /\v

let mapleader = ' '             " Leader key
let maplocalleader = ';'        " Local leader key

" Search for selected content
fun! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfun
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

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

" :Rename current buffer
fun! s:rename_file(new_file_path)
  execute 'saveas ' . a:new_file_path
  call delete(expand('#:p'))
  bd #
endfun

command! -nargs=1 -complete=file Rename call <SID>rename_file(<f-args>)

" }}}

"Plugin configs {{{

" % jump to matching xml tags, if/else/endif, etc.
packadd! matchit


let g:vim_markdown_folding_disabled = 1     " Disable vim-markdown folds by default
let g:vim_markdown_frontmatter = 1          " Highlight YAML front matter
let g:vim_markdown_conceal = 1
let g:vim_markdown_conceal_code_blocks = 1

" Vimkubectl configuration
let g:vimkubectl_command = 'oc'

" FZF configuration
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.7 } }
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

let FZF_BAT_CMD = 'bat --style=plain --color=always'

" Open files under current dir using fzf
"nnoremap <silent> <leader>f :FZF<CR>
nnoremap <silent> <Leader>f :call fzf#run(fzf#wrap({
      \   'source':  'fd --type f',
      \   'options': '--preview "' . FZF_BAT_CMD . ' {}"',
      \ }))<CR>

" Select from open buffers using fzf
fun! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfun

fun! s:bufnumber(bufline)
  return matchstr(a:bufline, '^[ 0-9]*')
endfun

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

fun! s:bufclose(buflines)
  if len(a:buflines) == 0
    return
  endif
  for each in a:buflines
    execute 'bdelete ' . s:bufnumber(each)
  endfor
endfun

nnoremap <silent> <Leader>b :call fzf#run(fzf#wrap({
      \   'source':  reverse(<sid>buflist()),
      \   'sink*':   function('<sid>bufopen'),
      \   'options': '--expect=ctrl-t,ctrl-v,ctrl-s --delimiter \" --preview "' . FZF_BAT_CMD . ' {2}"',
      \ }))<CR>

nnoremap <silent> <Leader>B :call fzf#run(fzf#wrap({
      \   'source':  reverse(<sid>buflist()),
      \   'sink*': function('<sid>bufclose'),
      \   'options': '--delimiter \" --preview "' . FZF_BAT_CMD . ' {2}"'
      \ }))<CR>

" Fuzzy directory selection
fun! s:navigate(dir)
  if len(a:dir) == 0
    return
  endif
  execute 'cd ' . a:dir
  echo a:dir
endfun

nnoremap <silent> <Leader>F :call fzf#run(fzf#wrap({
      \   'source': 'fd --type d',
      \   'sink':   function('<sid>navigate'),
      \ }))<CR>

" Interactive fuzzy text search
fun! s:openFileAtLocation(result)
  if len(a:result) == 0
    return
  endif
  let filePos = split(a:result, ':')
  exec 'edit +' . l:filePos[1] . ' ' . l:filePos[0]
endfun

nnoremap <silent> <Leader>s :call fzf#run(fzf#wrap({
      \ 'source': 'rg --line-number ''.*''',
      \ 'options': '--delimiter : --preview "' . FZF_BAT_CMD . ' {1} -H {2}" --preview-window "+{2}/2"',
      \ 'sink': function('<sid>openFileAtLocation'),
      \ }))<CR>

nnoremap <silent> <Leader>S :call fzf#run(fzf#wrap({
      \ 'options': '--disabled --ansi --bind "ctrl-r:reload:rg -i --line-number {q} \|\| true" --delimiter : --preview "' . FZF_BAT_CMD . ' {1} -H {2}" --preview-window "+{2}/2"',
      \ 'sink': function('<sid>openFileAtLocation'),
      \ }))<CR>

" }}}

"LSP {{{

lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  --buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  --buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('v', '<leader>a', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  --buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>n', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>N', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  --buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        "autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        "autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  -- Set up completion
  require('completion').on_attach()
  vim.api.nvim_exec([[
    " Use <Tab> and <S-Tab> to navigate through popup menu
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    " Set completeopt to have a better completion experience
    set completeopt=menuone,noinsert,noselect

    " Avoid showing message extra message when using completion
    set shortmess+=c
  ]], false)
end

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern('.git')
}
-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { 'ccls', 'cssls', 'gopls', 'html', 'jsonls', 'rust_analyzer', 'yamlls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF

" }}}

"Telescope {{{

"nnoremap <leader>f <cmd>Telescope find_files<cr>
"nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>m <cmd>Telescope marks<cr>
nnoremap <leader>q <cmd>Telescope quickfix<cr>
"nnoremap <leader>L <cmd>Telescope loclist<cr>
nnoremap gr <cmd>Telescope lsp_references<cr>
nnoremap <leader>t <cmd>Telescope treesitter<cr>
"nnoremap <leader>S <cmd>Telescope live_grep<cr>
"nnoremap <leader>h <cmd>Telescope help_tags<cr>

" }}}

" vim: fdm=marker:et:sw=2:
