" 普通设置
setlocal number " 显示行号
setlocal guifont=楷体:h12:cGB2312:qDRAFT " 字体

" 备份
setlocal nobackup " 不备份
setlocal noundofile " 不生成undo文件
setlocal noswapfile " 不生成swp文件

" 缩进
setlocal tabstop=4 " 制表符缩进为4
setlocal shiftwidth=4 " 自动缩进为4
setlocal softtabstop=4 " 换行缩进为4
setlocal expandtab " 制表符插入空格
setlocal autoindent " 自动缩进

" 编译
nmap <F5> :call CompileRun()<cr>
func! CompileRun()
	exec "w"
	if &filetype == 'python'
		exec "!python %"
    endif
endfunc
