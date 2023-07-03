" 文字使用 utf-8
" Linux 使用
" 普通设置
:setlocal number " 显示行号
:setlocal guifont=楷体:h12:cGB2312:qDRAFT " 字体
:setlocal backspace=2 " 退格键能正常使用
:setlocal showcmd " 显示输入命令
:setlocal nocompatible  " 以不兼容vi运行
:setlocal noignorecase " 搜索时不忽略大小写
:filetype plugin indent on " 自动检测文件类型、自动缩进？
:setlocal wrap " 自动换行 

" 状态栏
" set statusline 
setlocal laststatus=2 " 状态栏显示两行

" 语法
syn on " 语法高亮

" 备份
setlocal nobackup " 不备份
setlocal noundofile " 不生成undo文件
setlocal noswapfile " 不生成swp文件

" 缩进
setlocal tabstop=4 " 制表符宽度为4
setlocal shiftwidth=4 " 缩进宽度为4
setlocal softtabstop=4 " 换行缩进为4
":setlocal expandtab " 制表符插入空格
"setlocal autoindent " 自动缩进

" 新建文件时 文件头 
autocmd BufNewFile *.sh exec ":call SetTitle()"
function! SetTitle()
	if expand("%:e") == "sh"
		call setline(1, "#!/bin/bash")
		call setline(2, "#")
		call setline(3, "#********************************************************************")
		call setline(4, "# Author:       Ben")
		call setline(5, "# Mail:         2451535770@qq.com")
		call setline(6, "# Date:         ".strftime("%Y-%m-%d"))
		call setline(7, "# Description:  The test script")
		call setline(8, "#********************************************************************")
	endif
endfunction

" 新建文件自动将光标定位到末尾
autocmd BufNewFile * normal G

" 映射
" <F2>  普通模式：配置 
" <F3> 显示特殊字符，用于代码审计
" <F5> 执行当前文件
nnoremap <F2> :e $MYVIMRC<CR>
" inoremap <F2> <C-R>=strftime("%Y/%m/%d")<CR>
nnoremap <F3> :set list!<CR>
" nnoremap <F5> :update<CR>:source %<CR>
nnoremap <F5> :call CompileRun()<CR>
" 这里其实有局限性，python版本不对记得改
function! CompileRun()
	if &filetype == 'python'
		:!python3 %
	endif
endfunction

" 补全字典目录
autocmd! FileType python set dictionary+=$VIM/vimfiles/dict/python.dict
