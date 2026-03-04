if exists('g:loaded_basic') || &compatible
	finish
else
	let g:loaded_basic = 'yes'
endif

" 不保存历史记录
let g:netrw_dirhistmax = 0

" Leader 键设为空格
let mapleader = " "
let maplocalleader = " "

" ========================
" 文件备份与恢复
" ========================

" 备份设置（路径随 g:vim_dir：Win=vimfiles，Linux=.vim）
set backup
let &backupdir = g:vim_dir . '/.backup//'
if !isdirectory(expand(&backupdir))
	call mkdir(expand(&backupdir), 'p')
endif
set backupext=.bak

" 交换文件
set swapfile
let &directory = g:vim_dir . '/.swap//'
if !isdirectory(expand(&directory))
	call mkdir(expand(&directory), 'p')
endif

" 持久化撤销
set undofile
let &undodir = g:vim_dir . '/.undo//'
if !isdirectory(expand(&undodir))
	call mkdir(expand(&undodir), 'p')
endif

" 折叠视图保存目录（固定为 .view，便于纳入 .gitignore）
let &viewdir = g:vim_dir . '/.view//'
if !isdirectory(expand(&viewdir))
	call mkdir(expand(&viewdir), 'p')
endif

" 折叠：仅手动折叠并开启
set foldmethod=manual
set foldenable

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

" 默认显示相对行号和当前行绝对行号
set number
set relativenumber

" 显示列表字符，包括缩进和空白字符
set list
set listchars=tab:▸\ ,trail:·,eol:¶,precedes:<,extends:>

" 定义切换行号模式的函数
let g:line_number_mode = 0
function! ToggleLineNumberMode()
    " 模式顺序：
    " 0: relativenumber+number（相对+绝对 默认）
    " 1: number（只绝对）
    " 2: relativenumber（只相对）
    " 3: 都不显示
    let g:line_number_mode = (g:line_number_mode + 1) % 4
    if g:line_number_mode == 0
        set number
        set relativenumber
        echo "行号: 绝对+相对"
    elseif g:line_number_mode == 1
        set number
        set norelativenumber
        echo "行号: 绝对"
    elseif g:line_number_mode == 2
        set nonumber
        set relativenumber
        echo "行号: 相对"
    else
        set nonumber
        set norelativenumber
        echo "行号: 不显示"
    endif
endfunction

" 绑定 F3 键切换行号模式（如需更换，可以改成 F2/F4...F12）
nnoremap <F3> :call ToggleLineNumberMode()<CR>

" =======================================================
" [Command Line] 末行模式补全增强
" =======================================================

" 开启 wildmenu (基础必须)
" 允许按下 Tab 键时显示补全列表
set wildmenu

" 定义补全行为
" longest: 先补全到最长的公共字符串
" full:    如果还有多种可能，触发菜单
" full:    再次按 Tab 在菜单中循环
set wildmode=longest:full,full

" 启用竖向弹出菜单 (PopUp Menu)
if has("patch-8.2.4325") || has('nvim')
    set wildoptions=pum
    if exists('&pumblend')
        set pumblend=10
    endif
endif

set lazyredraw