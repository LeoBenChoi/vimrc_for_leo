" vimrc for Leo
" author: Leo
" mail: leo_ben_choi@outlook.com
" date: 20250119
" descript: 自己用的比较顺手的vimrc

""""""""
" 映射 "
""""""""
" <F1> 帮助文档
" <F2> 显示/关闭行号，默认为显示
" <F4> 重新载入当前文件
" <F5> 运行文件（如果可以的话）
" <C-F5>和<S-F5>暂时不确定用哪一个比较顺手，所以两个都设置为了编译
" <C-F5> 编译文件（如果可以的话）
" <S-F5> 编译文件（如果可以的话）
" <F7> 浅色模式
" <F8> 深色模式
" <F12> 打开配置文件
:nnoremap <F2> :set number!<CR>
:nnoremap <F4> :source %<CR>
:nnoremap <F5> :call RunFile()<CR>
:nnoremap <S-F5> :call CompileRunFile()<CR>
:nnoremap <C-F5> :call CompileRunFile()<CR>
:nnoremap <F7> :set background=light<CR>
:nnoremap <F8> :set background=dark<CR>
:nnoremap <F12> :e $MYVIMRC<CR> 

" 将 F5 键映射为检测并运行文件
" 定义 RunFile 函数
function! RunFile()
    " 获取当前文件的文件类型
    let filetype = &filetype
    " 根据文件类型执行对应操作
    if filetype ==? 'python'
        " 执行 Python 文件
        exec '!python' shellescape(@%, 1)
    elseif filetype ==? 'go'
        " 执行 Go 文件
        exec '!go run' shellescape(@%, 1)
    else
        " 提示不支持的文件类型
        echo "这个文件暂不能运行!"
    endif
endfunction

" 注释1：==# 区分大小写
"
" 注释2：shellescape(@%, 1)
" shellescape() 是 Vim 提供的一个内置函数，用于对字符串进行转义，确保文件路径在命令行中安全且正确。
" 例如，如果文件路径包含特殊字符（如空格或其他 shell 元字符），shellescape() 会自动加引号或做转义处理，以避免路径解析错误。@% 是 Vim 的寄存器，表示当前文件的路径（绝对路径）。
" 第二个参数 1 表示强制对路径进行完整的转义，确保安全性。

" 定义 CompileRunFile 函数
function! CompileRunFile()
    " 获取当前文件的文件类型
    let filetype = &filetype
    " 如果是 Python 文件，直接执行
    if filetype ==? 'python'
        exec '!python' shellescape(@%, 1)
    " 如果是 Go 文件，先编译再执行
    elseif filetype ==? 'go'
        " 编译 Go 文件
        exec '!go build' shellescape(@%,1)
        " 提示不支持的文件类型
        echo "这个文件暂不支持编译!"
    endif
endfunction


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
:set ignorecase " 使用搜索模式时忽略大小写

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
