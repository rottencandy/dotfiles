" Handle formatting
setlocal formatprg=prettier

" Must be set before ale is loaded
let g:ale_completion_enabled = 1
let g:ale_sign_highlight_linters = 1

packadd ale

" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']

let b:ale_linters = ['eslint']

" Run fixers when file is saved
let g:ale_fix_on_save = 1

" Max suggestions
let g:ale_completion_max_suggestions = 25

" Fix syntax
nnoremap <C-K> :ALEFix<CR>
