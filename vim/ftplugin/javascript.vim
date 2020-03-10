" Must be set before ale is loaded
let g:ale_completion_enabled = 0
let g:ale_sign_highlight_linters = 1
" Run fixers when file is saved
let g:ale_fix_on_save = 1

packadd ale

" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']
let b:ale_linters = ['eslint']

setlocal omnifunc=ale#completion#OmniFunc
setlocal formatprg=prettier

nnoremap <buffer> <C-K> :ALEFix<CR>
nnoremap <buffer> <leader>d :ALEGoToDefinition<CR>
nnoremap <buffer> <leader>t :ALEGoToTypeDefinition<CR>
