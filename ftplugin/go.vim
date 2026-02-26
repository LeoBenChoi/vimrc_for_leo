" Go 文件类型：缩进、折叠及折叠状态保存/恢复
" 官方风格：用 Tab 缩进，tabstop=8
setlocal tabstop=8
setlocal shiftwidth=8
setlocal noexpandtab
setlocal foldmethod=indent
setlocal foldlevel=99   " 默认不折叠，全部展开

" Go 缓冲区：保存/恢复视图时包含折叠（临时改 viewoptions，不影响其他文件类型）
augroup goViewFold
	au!
	autocmd BufWinLeave <buffer> set viewoptions+=folds | silent! mkview | set viewoptions-=folds
	autocmd BufWinEnter <buffer> set viewoptions+=folds | silent! loadview | set viewoptions-=folds
	autocmd BufWritePost <buffer> set viewoptions+=folds | silent! mkview | set viewoptions-=folds
augroup END
