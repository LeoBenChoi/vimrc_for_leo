""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 基本设置
" 基本编辑设置
set nocompatible         " 关闭 vi 兼容模式
set backspace=2          " 允许退格键删除任何字符
set encoding=utf-8       " 设置文件编码
set fileencodings=utf-8,ucs-bom,gb18030,cp936,latin1  " 文件编码优先级
set textwidth=80        " 设置文本宽度为80
set wrapmargin=80       " 设置自动换行的列数为80
set linebreak           " 允许在长行中断行
set breakindent         " 自动缩进换行符
set showbreak=+++       " 设置换行符显示方式
set guifont=Consolas:h12:b:cANSI:qDRAFT    " 设置字体
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 性能优化
set lazyredraw           " 延迟重绘，提高性能
set ttyfast              " 提升屏幕刷新速度
set updatetime=300       " 设置自动语法检查的时间间隔
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 禁用自动备份相关功能
set nobackup          " 禁用备份文件
set nowritebackup     " 禁用写入时备份文件
set noswapfile        " 禁用交换文件
set noundofile        " 禁用撤销文件
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 键盘映射
source $VIM/vimfiles/keymap/default.keymap.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 打开文件时回到上次编辑的位置
autocmd! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 缩进设置
set noexpandtab     " 不用空格代替 Tab 键
set tabstop=4       " Tab 键显示为 4 个空格宽度
set shiftwidth=4    " 自动缩进为 4 个空格
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示设置
set number              " 显示行号
set relativenumber      " 相对行号
set numberwidth=4       " 设置行号列宽
set showmatch           " 高亮匹配的括号
set cursorline          " 突出显示当前行
set cursorcolumn        " 突出显示当前列
set colorcolumn=80      " 设置突出显示列为80
set showmode            " 显示当前模式
set showcmd             " 显示正在输入的命令
set ruler               " 显示光标位置
set showfulltag         " 显示完整标签
set showtabline=2       " 总是显示标签页栏
set laststatus=2        " 总是显示状态行
set cmdheight=2         " 设置命令行高度
set mouse=a             " 所有模式都支持鼠标
set ttymouse=sgr        " 鼠标兼容
set signcolumn=yes      " 打开标志列
set guioptions-=m	   " 隐藏菜单栏
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 文件与自动命令
filetype plugin on      " 打开文件类型检测
filetype indent on      " 打开文件类型缩进
set autochdir           " 自动切换工作路径
set foldmethod=marker   " 设置折叠方式为标记
set foldlevelstart=99   " 设置折叠级别为99
set foldcolumn=3        " 设置折叠栏宽度为3
set foldnestmax=10      " 设置最大折叠深度为10
autocmd BufRead,BufNewFile *.vimhex set filetype=xxd	" 设置vimhex文件类型
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 搜索设置
set incsearch           " 实时搜索
set hlsearch            " 高亮搜索结果
set ignorecase          " 使用搜索模式时忽略大小写
set smartcase           " 智能区分大小写
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 主题和外观
if has("gui_running")
	" 设置GVim的主题
	colorscheme gruvbox
	set ambiwidth=double  " 设置宽字符显示
	autocmd GUIENter * simalt ~x
	let hour = strftime("%H")
	if hour >= 8 && hour < 18
		" 白天（8:00-18:00）使用 light 主题
		set background=light
	else
		" 晚上（18:00-6:00）使用 dark 主题
		set background=dark
	endif
else
	" 设置终端Vim的主题
	set termguicolors
	let g:cyberpunk_cursorline="default"
	let hour = strftime("%H")
	if hour >= 8 && hour < 18
		" 白天（6:00-18:00）使用 light 主题
		colorscheme cyberpunk
		let g:airline_theme='cyberpunk'
		" 修改列显示
		call HighlightFor("CursorColumn", "#140007", "#FF0055", "NONE")
	else
		" 晚上（18:00-6:00）使用 dark 主题
		colorscheme silverhand
		let g:airline_theme='silverhand'
		" 修改列显示
		call HighlightFor("CursorColumn", "#0a0d04", "#5E81F5", "NONE")
	endif
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件管理
" 注册插件服务
if executable('vim-language-server')
	augroup LspVim
		autocmd!
		autocmd User lsp_setup call lsp#register_server({
					\ 'name': 'vim-language-server',
					\ 'cmd': {server_info->['vim-language-server', '--stdio']},
					\ 'whitelist': ['vim'],
					\ 'initialization_options': {
					\   'vimruntime': $VIMRUNTIME,
					\   'runtimepath': &rtp,
					\ }})
	augroup END
endif
if executable('pylsp')
	" pip install python-lsp-server
	au User lsp_setup call lsp#register_server({
				\ 'name': 'pylsp',
				\ 'cmd': {server_info->['pylsp']},
				\ 'allowlist': ['python'],
				\ })
endif
if executable('gopls')
	" go get -u golang.org/x/tools/gopls@latest
	au User lsp_setup call lsp#register_server({
				\ 'name': 'gopls',
				\ 'cmd': {server_info->['gopls', '-remote=auto']},
				\ 'allowlist': ['go', 'gomod', 'gohtmltmpl', 'gotexttmpl'],
				\ })
	autocmd BufWritePre *.go
				\ call execute('LspDocumentFormatSync') |
				\ call execute('LspCodeActionSync source.organizeImports')
endif

function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal signcolumn=yes
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
	nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> gs <plug>(lsp-document-symbol-search)
	nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
	nmap <buffer> gr <plug>(lsp-references)
	nmap <buffer> gi <plug>(lsp-implementation)
	nmap <buffer> gt <plug>(lsp-type-definition)
	nmap <buffer> <leader>rn <plug>(lsp-rename)
	nmap <buffer> [g <plug>(lsp-previous-diagnostic)
	nmap <buffer> ]g <plug>(lsp-next-diagnostic)
	nmap <buffer> K <plug>(lsp-hover)
	nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
	nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

	let g:lsp_format_sync_timeout = 1000
	autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

	" refer to doc to add more commands
endfunction

" 状态栏
let g:lightline = {
			\ 'colorscheme': 'wombat',
			\ 'active': {
			\   'left': [ [ 'mode', ], [ 'gitbranchstatus'], ['filename' ], [ 'readonly', 'modified'] ],
			\   'right': [ ['lineinfo'], [ 'percent' ], ['filetype', 'fileformat', 'fileencoding', 'charvaluehex' ] ]
			\ },
			\ 'component_function': {
			\   'gitbranchstatus': 'FugitiveStatusline',
			\ },
			\ 'component': {
			\   'charvaluehex': '0x%B'
			\ },
			\ }

" 侧边栏
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>


finish
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
