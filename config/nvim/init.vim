let &packpath = &runtimepath

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ⡀⢀ ⠄ ⣀⣀  ⡀⣀ ⢀⣀
" ⠱⠃ ⠇ ⠇⠇⠇ ⠏  ⠣⠤
"

"Plugins {{{

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

" Treeshitter
Plug 'nvim-treesitter/nvim-treesitter', { 'branch': '0.5-compat', 'do': ':TSUpdate' }
" Colorschemes
Plug 'bluz71/vim-moonfly-colors'
Plug 'mhartington/oceanic-next'
" File explorer
Plug 'lambdalisue/fern.vim'
" Closing brackets/quotes/... insertion
Plug 'Raimondi/delimitMate'
" Fugitive
Plug 'tpope/vim-fugitive'
" Markdown support
Plug 'plasticboy/vim-markdown'
" GLSL support
Plug 'tikhomirov/vim-glsl'
" Editorconfig
Plug 'editorconfig/editorconfig-vim'
" Prettier
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
" LSP
Plug 'neovim/nvim-lspconfig'
" Completion
Plug 'nvim-lua/completion-nvim'

" Initialize plugin system
call plug#end()

" }}}

source ~/.vim/common.vim

"Treesitter {{{

lua <<EOF
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,  -- false will disable the whole extension
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

"LSP {{{

lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- peek definition
  local function preview_location_callback(_, _, result)
    if result == nil or vim.tbl_isempty(result) then
      return nil
    end
    vim.lsp.util.preview_location(result[1])
  end
  function PeekDefinition()
    local params = vim.lsp.util.make_position_params()
    return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
  end

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>K', '<cmd>lua PeekDefinition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  --buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  --buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('v', '<leader>a', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
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
local servers = { 'ccls', 'cssls', 'gopls', 'html', 'jsonls', 'rust_analyzer', 'yamlls', 'eslint' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF

" }}}

" vim: fdm=marker:et:sw=2:
