" Go 语言折叠：按缩进折叠函数体、类型体等
if exists('b:go_fold_loaded') || &compatible
	finish
else
	let b:go_fold_loaded = 1
endif

setlocal foldmethod=indent
setlocal foldlevel=1
setlocal foldlevelstart=99
setlocal foldenable

" 第一次打开默认全部展开；保存/离开时保存折叠，再次打开时恢复
augroup go_fold_view
	au!
	autocmd BufReadPost <buffer> silent! loadview
	autocmd BufWritePost,BufWinLeave <buffer> mkview
augroup END

" 可选：zo 打开、zc 关闭、za 切换当前折叠
" 可选：zR 全部打开、zM 全部关闭
