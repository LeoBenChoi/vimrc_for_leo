if exists('g:go_fold_loaded') || &compatible
	finish
else
	let g:go_fold_loaded = 1
endif

setlocal foldmethod=indent
setlocal foldlevel=1
setlocal foldlevelstart=99
setlocal foldenable

augroup go_fold_view
	au!
	autocmd BufReadPost <buffer> silent! loadview
	autocmd BufWritePost,BufWinLeave <buffer> mkview
augroup END

