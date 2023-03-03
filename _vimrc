" 文字使用 utf-8
" 普通设置
set number " 显示行号
set guifont=楷体:h12:cGB2312:qDRAFT " 字体
set backspace=2 " 退格键能正常使用

" 语法
syn on " 语法高亮

" 备份
set nobackup " 不备份
set noundofile " 不生成undo文件
set noswapfile " 不生成swp文件

" 缩进
set tabstop=4 " 制表符缩进为4
set shiftwidth=4 " 自动缩进为4
set softtabstop=4 " 换行缩进为4
set expandtab " 制表符插入空格
set autoindent " 自动缩进

" 编译
nmap <F5> :call CompileRun()<cr>
func! CompileRun()
	exec "w"
	if &filetype == 'python'
		exec "!python %"
    endif
endfunc
