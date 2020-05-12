" Must be set before ale is loaded
let g:ale_completion_enabled = 1
let g:ale_sign_highlight_linters = 1
" Run fixers when file is saved
let g:ale_fix_on_save = 1

" Enable automatic TS module import
let g:ale_completion_tsserver_autoimport = 1

packadd ale

" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']
let b:ale_linters = ['eslint']

" Disable super annoying automatic linting
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0

setlocal omnifunc=ale#completion#OmniFunc
setlocal formatprg=prettier\ --parser\ typescript

nnoremap <buffer> <leader>k <Plug>(ale_fix)
nnoremap <buffer> <leader>l <Plug>(ale_lint)
nnoremap <buffer> <leader>i <Plug>(ale_hover)
nnoremap <buffer> <leader>g <Plug>(ale_go_to_definition)
nnoremap <buffer> <leader>t <Plug>(ale_go_to_type_definition)
nnoremap <buffer> <leader>r <Plug>(ale_find_references)
nnoremap <buffer> leader>n <Plug>(ale_next_wrap)
nnoremap <buffer> leader>N <Plug>(ale_previous_wrap)
