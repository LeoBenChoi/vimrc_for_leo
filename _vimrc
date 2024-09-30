" vimrc for Leo
" author: Leo
" descript: vimrc for own use, welcome to copy

" 1 重要选项
" 2 移动、搜索以及正则表达式
" 3 标签(tag)
set showfulltag	"在插入模式补全标签时显示更多信息

" 4 显示文本
set scroll=5	"按 CTRL-U 和 CTRL-D 滚动的行数 (局部于窗口)
set window=20	"按 CTRL-F 和 CTRL-B 滚动的行数
set wrap	"长行折行(局部于窗口)
set linebreak	"在 'breakat' 中的字符处对长行折行(局部于窗口)
set breakindent	"在折行文本中保持缩进(局部于窗口)
set cmdheight=2	"用于命令行的行数
"set list "以 ^I 显示 <Tab>, 以 $ 显示行尾(局部于窗口),本人一般用于绑定F3
set number
"set relativenumber	"显示每行的相对行号(局部于窗口)
set numberwidth=4	"用于行号的列数(局部于窗口)

" 5 语法、高亮和拼写
" "dark" 或者 "light"；背景色亮度
set background=light


" 6 多个窗口
set statusline=%1*[%t]%2*\ [%{&ff}(%{&fenc})]\ %3*%y%4*%h%m%r%=%5*%l,%-10v%-3p%%
" 状态栏调色
hi User1 cterm=none ctermfg=0 ctermbg=255
hi User2 cterm=none ctermfg=5 ctermbg=0
hi User3 cterm=none ctermfg=3 ctermbg=0
hi User4 cterm=none ctermfg=red ctermbg=0
hi User5 cterm=none ctermfg=2 ctermbg=0
set laststatus=2 " 启用状态栏

" 7 多个标签页
set showtabline=2	"0, 1 或 2; 何时使用标签页行

" 8 终端
set title	"在窗口标题中显示信息

" 9 使用鼠标
" 10 图形用户界面
set guifont=楷体:h16:cGB2312:qDRAFT " "在 GUI 中使用的字体名称列表

" 11 打印
" 12 消息和信息
set showmode	"在状态行中显示当前模式

" 13 选择文本
" 14 编辑文本
set noundofile	"自动保存和恢复撤销历史

" 15 Tab 和缩进
set expandtab " 使用空格代替tab
set tabstop=4	" <Tab> 在文本中代表的空格数(局部于缓冲区)
"set shiftwidth=4	" 每步（自动）缩进所使用的空格数(局部于缓冲区)
"set smarttab	" 用 <Tab> 键缩进时插入 'shiftwidth' 个空格(使用空格代替 <Tab>)
"set shiftround	" 用 "<<" 和 ">>" 缩进时，插入 'shiftwidth' 整数倍个空格
set autoindent	" 自动设置新行缩进(局部于缓冲区) 使用noai关闭
set smartindent	" 智能自动缩进(局部于缓冲区)

" 16 折叠
" 17 差异模式

" 18 映射
" <F2>  普通模式：配置 
nnoremap <F2> :e $MYVIMRC<CR>


" 19 读写文件
" 20 交换文件
" 21 命令行编辑
" 22 执行外部命令
set shell=C:\\Windows\\system32\\cmd.exe	"用于外部命令的 shell 程序的名称

" 23 运行 make 并跳到错误（快速修复）
" 24 系统特定
" 25 语言特定
" 26 多字节字符
set encoding=utf-8	"在 Vim 中使用的字符编码："latin1", "utf-8","euc-jp", "big5" 等

" 27 杂项
" 文件打开回到上次离开行
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

""" 配置文件完 """


