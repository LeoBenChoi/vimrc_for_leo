if exists('g:loaded_basic') || &compatible
	finish
else
	let g:loaded_basic = 'yes'
endif

" 不保存历史记录
let g:netrw_dirhistmax = 0

" ========================
" 文件备份与恢复
" ========================

" 备份设置
set backup
set backupdir=~/.vim/.backup//
if !isdirectory(expand(&backupdir))
	call mkdir(expand(&backupdir), 'p')
endif
set backupext=.bak

" 交换文件
set swapfile
set directory=~/.vim/.swapfile//
if !isdirectory(expand(&directory))
	call mkdir(expand(&directory), 'p')
endif

" 持久化撤销
set undofile
set undodir=~/.vim/.undofile//
if !isdirectory(expand(&undodir))
	call mkdir(expand(&undodir), 'p')
endif


""""""""""""""""""""""""""""""""""""""""""" 来自官网，永久保存
" 将以下内容放入一个 autocmd 组，这样可以通过以下命令还原它们：
" ":augroup vimStartup | au! | augroup END"
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

" 显示相对行号和当前行绝对行号
set number
set relativenumber

" =======================================================
" [Command Line] 末行模式补全增强
" =======================================================

" 1. 开启 wildmenu (基础必须)
" 允许按下 Tab 键时显示补全列表
set wildmenu

" 2. 定义补全行为
" longest: 先补全到最长的公共字符串
" full:    如果还有多种可能，触发菜单
" full:    再次按 Tab 在菜单中循环
set wildmode=longest:full,full

" 3. 【核心】启用竖向弹出菜单 (PopUp Menu)
if has("patch-8.2.4325") || has('nvim')
    set wildoptions=pum
    if exists('&pumblend')
        set pumblend=10
    endif
endif

" 4. 忽略一些不想补全的文件 (让列表更干净)
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest
set wildignore+=*.pyc,*.class
set wildignore+=.git,.hg,.svn
set wildignore+=*.jpg,*.png,*.gif,*.jpeg,*.bmp

set lazyredraw