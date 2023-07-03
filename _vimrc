" 文字使用 utf-8
" Linux 使用
" 普通设置
:set number " 显示行号
:set guifont=楷体:h12:cGB2312:qDRAFT " 字体
:set backspace=2 " 退格键能正常使用
:set showcmd " 显示输入命令
:set nocompatible  " 以不兼容vi运行
:set noignorecase " 搜索时不忽略大小写
:filetype plugin indent on " 自动检测文件类型、自动缩进？
:set wrap " 自动换行 
:set termguicolors " 开启真彩色

" 状态栏
" set statusline 
:set laststatus=2 " 状态栏显示两行(始终显示)

" 语法
:syn on " 语法高亮

" 备份
:set nobackup " 不备份
:set noundofile " 不生成undo文件
:set noswapfile " 不生成swp文件

" 缩进
:set tabstop=4 " 制表符宽度为4
:set shiftwidth=4 " 缩进宽度为4
:set softtabstop=4 " 换行缩进为4
":setlocal expandtab " 制表符插入空格
"setlocal autoindent " 自动缩进

" 新建文件时 文件头 
:autocmd BufNewFile *.sh,*.py exec ":call SetTitle()"
function! SetTitle()
	if has('unix')
		if expand("%:e") == "sh"
			call setline(1, "#!/bin/bash")
		endif
		if expand("%:e") == "py"
			call setline(1, "#!/usr/bin/python")
			call setline(2, "# -*- coding: UTF-8 -*-")
		endif
"	call setline(2, "##################################################")
"	call setline(3, "# Author:		Ben")
"	call setline(4, "# Email:	 	lio_ben_choi@foxmial.com")
"	call setline(5, "# Date:			".strftime("%Y-%m-%d"))
"	call setline(6, "# Description:	The Description")
"	call setline(7, "##################################################")
"		if expand("%:e") == "py"
"			call setline(8, "# -*- coding: UTF-8 -*-")
"		endif
	endif
endfunction

" 光标
" 新建文件自动将光标定位到末尾
:autocmd BufNewFile * normal G
" 文件打开回到上次离开行
:autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" 映射
" <F2>  普通模式：配置 
" <F3> 显示特殊字符，用于代码审计
" <F5> 执行当前文件
:nnoremap <F2> :e $MYVIMRC<CR>
" inoremap <F2> <C-R>=strftime("%Y/%m/%d")<CR>
:nnoremap <F3> :set list!<CR>
" nnoremap <F5> :update<CR>:source %<CR>
:nmap <F5> :call CompileRun()<CR>
" 这里其实有局限性，python版本不对记得改
function! CompileRun()
	execute "w"
	if &filetype == 'python'
		execute "!python3 %"
	endif
endfunction

" 补全字典目录
:autocmd! FileType python set dictionary+=$VIM/vimfiles/dict/python.dict

" 状态栏
" 样例
":set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
":set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
:set statusline=%1*[%t]%2*\ [%{&ff}(%{&fenc})]\ %3*%y%4*%h%m%r%=%5*%l,%-10v%-3p%%
" 状态栏调色
hi User1 cterm=none ctermfg=0 ctermbg=255
hi User2 cterm=none ctermfg=5 ctermbg=0
hi User3 cterm=none ctermfg=3 ctermbg=0
hi User4 cterm=none ctermfg=red ctermbg=0
hi User5 cterm=none ctermfg=2 ctermbg=0

