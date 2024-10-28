" vimrc for Leo
" author: Leo
" descript: 自己用的比较顺手的vimrc
" date: 20241020

""""""""
" 映射 "
""""""""
" <F1> 帮助文档
" <F2> 打开配置文件
" <F4> 重新载入当前文件
" <F5> 运行代码（如果可以的话）
:nmap <F2> :e $MYVIMRC<CR> 
:nnoremap <F5> :!%<CR>
:nnoremap <F4> :source %<CR>

""""""""
" 常用 "
""""""""
:set nocompatible " 不兼容vi(开不开都行)
:set showfulltag	"在插入模式补全标签时显示更多信息
:set scroll=5	"按 CTRL-U 和 CTRL-D 滚动的行数 (局部于窗口)
:set window=20	"按 CTRL-F 和 CTRL-B 滚动的行数
:set cmdheight=2	"用于命令行的行数
:set number	" 显示行号
:set numberwidth=4	"用于行号的列数(局部于窗口)
:set showmode	"在状态行中显示当前模式
:set backspace=indent,eol,start "退格键能删除的东西，如果要开头能删除到上一行就加上start
:set wildmenu " 命令行补全时显示匹配列表
:set encoding=utf-8	"在 Vim 中使用的字符编码："latin1", "utf-8","euc-jp", "big5" 等
:set fileencodings=ucs-bom,utf-8,gb18030,cp936,latin1 " 猜测文件编码列表

"""""""""""""
" tab键优化 "
"""""""""""""
:set tabstop=4	" <Tab> 在文本中代表的空格数(局部于缓冲区)
:set shiftwidth=4	" 缩进所使用的空格
:set shiftround	" 用 "<<" 和 ">>" 缩进时，插入 'shiftwidth' 整数倍个空格

""""""""""""
" 交换文件 "
""""""""""""
:set nobackup " 取消自动备份功能
:set noswapfile " 取消生成swp文件
:set noundofile " 取消生成un文件

""""""""""""
" 自动任务 "
""""""""""""
:autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " 文件打开回到上次离开行

""""""""""""""""""""
" 设置HOME目录位置 "
""""""""""""""""""""
if has('win32') || has ('win64')
    let $VIMHOME = $VIM."/vimfiles"
else
    let $VIMHOME = $HOME."/.vim"
endif

""""""""""""
" gvim优化 "
""""""""""""
:set guifont=Consolas:h16:b:cANSI:qDRAFT "在 GUI 中使用的字体名称列表
if has('gui_running') == 1
	:set background=light "背景 dark or light
    :colorscheme morning " 主题
	:set ambiwidth=double " 宽度有歧义字符的宽度（解决中文引号显示不全问题）
elseif has('gui_running') == 0
	:set background=dark
	:colorscheme industry
endif

""""""""
" 语法 "
""""""""
:syntax on
:filetype plugin on " 检测文件类型
:filetype plugin indent on " 自动检测文件类型

""""""""""
" 状态栏 "
""""""""""
:set statusline=%1*[%t]%2*\ [%{&ff}(%{&fenc})]\ %3*%y%4*%h%m%r%=%5*%l,%-10v%-3p%%
hi User1 cterm=none ctermfg=0 ctermbg=255
hi User2 cterm=none ctermfg=5 ctermbg=0
hi User3 cterm=none ctermfg=3 ctermbg=0
hi User4 cterm=none ctermfg=red ctermbg=0
hi User5 cterm=none ctermfg=2 ctermbg=0
:set laststatus=2 " 启用状态栏

finish " end
