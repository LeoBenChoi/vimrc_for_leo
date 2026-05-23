" leader 键
let mapleader = " "

" 真彩色
if (has("termguicolors"))
 set termguicolors
endif

" 语法高亮
syntax enable

" 主题设置
" colorscheme shades_of_purple
" colorscheme kyotonight
" colorscheme retrobox
" let g:airline_theme='kyotonight'
" let g:airline_theme=''
set background=dark
set colorscheme tokyonight



" 显示绝对行号（当前行） " 显示相对行号（其他行）
set number relativenumber 

" 强制显示侧边栏
set signcolumn=yes

" 光标距窗口顶部/底部至少保留几行，避免贴边
set scrolloff=5
set sidescrolloff=5

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
