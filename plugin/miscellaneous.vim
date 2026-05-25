" ++++++++++++++++++++++++************************
"		 Miscellaneous settings
" ++++++++++++++++++++++++************************
" 杂项
let mapleader = " "
set number relativenumber " 显示绝对行号（当前行） " 显示相对行号（其他行）
set signcolumn=yes " 始终启动符号列
set undofile   
set ttimeoutlen=0
set timeoutlen=500
set noswapfile
set wildmenu
set wildmode=longest:full,full
set wildoptions=pum
set mouse=a
set splitbelow " 水平分屏时，新窗口放在当前窗口下方
set noscrollbind " 不自动绑定滚动（多个窗口独立滚动）
set nocursorbind " 不自动绑定光标移动（多个窗口光标位置独立）
set incsearch " 增量搜索：输入搜索词时实时高亮第一个匹配项，边输边跳转
set scrolloff=5
set tags=./tags;,tags;./.tags;,.tags;
set foldmethod=syntax
set foldnestmax=99
set foldlevel=99
set noautochdir
set viewoptions-=curdir
set list listchars=tab:\¦\ ,eol:¬ " 隐形字符
" set exrc " 允许读取局部vimrc，但是会有安全问题
set cursorline
set nocursorline

" =======================================================
" GUI 图形界面专属
" =======================================================
if has("gui_running")
	set guifont=Maple_Mono_NL_NFMono_CN:h12
	set guioptions-=m
	set guioptions-=T
	set guioptions-=e
	set guioptions-=r
	set guioptions-=R
	set guioptions-=l
	set guioptions-=L
	set notitle
endif

" 启动时自动最大化窗口（Windows GVim）
if has('win32') || has('win64')
	set noerrorbells " 关闭错误提示音
	set novisualbell " 关闭视觉响铃
	autocmd GUIEnter * simalt ~x
endif

""""""""""""""""""""""""""""""""""""""""""" 来自官网，永久保存
" 将以下内容放入一个 autocmd 组，这样可以通过以下命令还原它们：
" :augroup vimStartup | au! | augroup END"
augroup vimStartup
	au!
	" 编辑文件时，始终跳转到上次光标停留的位置。
	" 如果位置无效、处于事件处理程序中（例如在 gvim 拖拽文件时），
	" 或编辑 commit message 文件（通常是新的缓冲区）时则不执行跳转。
	autocmd BufReadPost *
				\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
				\ |   exe "normal! g`\""
				\ | endif
augroup END
