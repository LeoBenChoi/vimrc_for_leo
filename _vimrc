" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" vimrc for Leo
" author: Leo
" descript: 自己用的比较顺手的vimrc
" date: 20241020

" 1 重要选项
:set nocompatible " 不兼容vi

" 2 移动、搜索以及正则表达式
" 3 标签(tag)
:set showfulltag	"在插入模式补全标签时显示更多信息

" 4 显示文本
:set scroll=5	"按 CTRL-U 和 CTRL-D 滚动的行数 (局部于窗口)
:set window=20	"按 CTRL-F 和 CTRL-B 滚动的行数
"set wrap	"长行折行(局部于窗口)
"set linebreak	"在 'breakat' 中的字符处对长行折行(局部于窗口)
"set breakindent	"在折行文本中保持缩进(局部于窗口)
:set cmdheight=2	"用于命令行的行数
"set list "以 ^I 显示 <Tab>, 以 $ 显示行尾(局部于窗口),本人一般用于绑定F3
:set number	" 显示行号
"set relativenumber	"显示每行的相对行号(局部于窗口)
:set numberwidth=4	"用于行号的列数(局部于窗口)

" 5 语法、高亮和拼写
" "dark" 或者 "light"；背景色亮度
"set background=light
:filetype plugin on " 检测文件类型
:filetype plugin indent on " 自动检测文件类型
"colorscheme ron
"if has('gui_running') == 1
"    :colorscheme morning
"elseif has('gui_running') == 0
"    :colorscheme desert
"endif


" 6 多个窗口
"状态栏
":set statusline=%1*[%t]%2*\ [%{&ff}(%{&fenc})]\ %3*%y%4*%h%m%r%=%5*%l,%-10v%-3p%%
" 状态栏调色
"hi User1 cterm=none ctermfg=0 ctermbg=255
"hi User2 cterm=none ctermfg=5 ctermbg=0
"hi User3 cterm=none ctermfg=3 ctermbg=0
"hi User4 cterm=none ctermfg=red ctermbg=0
"hi User5 cterm=none ctermfg=2 ctermbg=0
:set laststatus=2 " 启用状态栏(lightline 插件使用中)

" 7 多个标签页
"set showtabline=2	"0, 1 或 2; 何时使用标签页行

" 8 终端
" 9 使用鼠标
" 10 图形用户界面
:set guifont=楷体:h14:cGB2312:qDRAFT " "在 GUI 中使用的字体名称列表

" 11 打印
" 12 消息和信息
:set showmode	"在状态行中显示当前模式

" 13 选择文本
"set textwidth=78 " 超过长度自动换行
" 14 编辑文本
"set noundofile	"自动保存和恢复撤销历史

" 15 Tab 和缩进
"set expandtab " 使用空格代替tab
:set tabstop=4	" <Tab> 在文本中代表的空格数(局部于缓冲区)
:set shiftwidth=4	" 缩进所使用的空格
"set smarttab	" 用 <Tab> 键缩进时插入 'shiftwidth' 个空格(使用空格代替 <Tab>)
:set shiftround	" 用 "<<" 和 ">>" 缩进时，插入 'shiftwidth' 整数倍个空格
"set autoindent	" 自动设置新行缩进(局部于缓冲区) 使用noai关闭
"set smartindent	" 智能自动缩进(局部于缓冲区)

" 16 折叠
" 17 差异模式

" 18 映射
" <F2>  普通模式：配置 
" 打开配置文件
:nmap <F2> :e $MYVIMRC<CR> 
" 换行后正常进行上下行移动
:nnoremap j gj
:nnoremap k gk
" 复制粘贴(Windows 用户临时使用)
"nmap <C-c> "+yy
"vmap <C-c> "+y
"nmap <C-v> "+p

" 19 读写文件
" 20 交换文件
:set nobackup " 取消自动备份功能
:set noswapfile " 取消生成swp文件
:set noundofile " 取消生成un文件

" 21 命令行编辑
:set wildmenu

" 22 执行外部命令
:set shell=C:\\Windows\\system32\\cmd.exe	"用于外部命令的 shell 程序的名称

" 23 运行 make 并跳到错误（快速修复）
" 24 系统特定
" 25 语言特定
" 26 多字节字符
:set encoding=utf-8	"在 Vim 中使用的字符编码："latin1", "utf-8","euc-jp", "big5" 等
:set fileencodings=ucs-bom,utf-8,gb18030,cp936,latin1 " 猜测文件编码列表

" 27 杂项
" 文件打开回到上次离开行
:autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" 设置HOME目录位置
if has('win32') || has ('win64')
    let $VIMHOME = $VIM."/vimfiles"
else
    let $VIMHOME = $HOME."/.vim"
endif


" 加载插件
" ######################
" ##  插件 lightline  ##
" ######################
" #####################
" ##  插件 NERDTree  ##
" #####################
: nnoremap <F3> :call IsTree()<CR>
let s:a = 0
function! IsTree() abort
	if s:a == 0
		let s:a = 1
		:NERDTree
	elseif s:a == 1
		let s:a = 0 
		:NERDTreeClose
	endif
endfunction
" Exit Vim if NERDTree is the only window remaining in the only tab.
" 当 NERDTree 是最后一个窗口时，自动关闭 Vim 或选项卡
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
" 防止其他缓冲区在其窗口中替换 NERDTree？
autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
" Open the existing NERDTree on each new tab.
" 每个标签上自动使用相同的 NERDTree
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif
" ########################
" ##  插件 altercation  ##
" ########################
if has('gui_running') == 1
	":set background=light
	:set background=dark
	:colorscheme solarized
elseif has('gui_running') == 0
	:set background=dark
	:colorscheme solarized
endif
" 配置文件完 "
finish
