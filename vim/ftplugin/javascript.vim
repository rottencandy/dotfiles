packadd ale

" Fix files with prettier, and then ESLint.
let b:ale_fixers = ['prettier', 'eslint']
let g:ale_fix_on_save = 1

" Fix syntax
nnoremap <C-K> :ALEFix<CR>