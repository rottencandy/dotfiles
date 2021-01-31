if has('nvim-0.5')
	source ~/.config/nvim/nightly.vim
else
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
	let &packpath = &runtimepath
	source ~/.vim/vimrc
endif
