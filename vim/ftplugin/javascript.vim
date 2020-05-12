" Must be set before ale is loaded
let g:ale_completion_enabled = 1
let g:ale_sign_highlight_linters = 1
" Run fixers when file is saved
let g:ale_fix_on_save = 1

packadd ale

" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']
let b:ale_linters = ['eslint']

" Do not lint or fix minified files.
let g:ale_pattern_options = {
\ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\}
" To allow reading of above command
let g:ale_pattern_options_enabled = 1

" Disable super annoying automatic linting
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0

setlocal omnifunc=ale#completion#OmniFunc
setlocal formatprg=prettier

nnoremap <buffer> <leader>k <Plug>(ale_fix)
nnoremap <buffer> <leader>l <Plug>(ale_lint)
nnoremap <buffer> <leader>i <Plug>(ale_hover)
nnoremap <buffer> <leader>g <Plug>(ale_go_to_definition)
nnoremap <buffer> <leader>r <Plug>(ale_find_references)
nnoremap <buffer> leader>n <Plug>(ale_next_wrap)
nnoremap <buffer> leader>N <Plug>(ale_previous_wrap)
