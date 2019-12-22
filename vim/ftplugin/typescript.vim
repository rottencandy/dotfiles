" Must be set before ale is loaded
let g:ale_completion_enabled = 1
packadd ale
" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']
" Run fixers when file is saved
let g:ale_fix_on_save = 1
" Automatically import ts modules
let g:ale_completion_tsserver_autoimport = 1

" Fix syntax
nnoremap <C-K> :ALEFix<CR>
