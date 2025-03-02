""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 基本设置
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
set mouse=a				 " 启用鼠标
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shortmess+=I		" 禁用默认的启动屏幕
" 显示自定义欢迎信息
autocmd VimEnter * echo "VIM, YES!"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 设置状态栏显示的内容
set wildmenu            " 开启命令行模式补全
set pumheight=20	" 补全菜单高度
set wildmode=longest:full,full   " 让补全更智能
set wildoptions=pum " 补全模式，弹出菜单
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
" 启用语法高亮
syntax enable	" 启用语法高亮
syntax on " 启用语法高亮
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 搜索设置
set incsearch           " 实时搜索
set hlsearch            " 高亮搜索结果
set ignorecase          " 使用搜索模式时忽略大小写
set smartcase           " 智能区分大小写
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 适配配置
if (has('win32') || has('win64')) == 1
	" Windows 系统设置
	set guifont=Consolas:h12:b:cANSI:qDRAFT
	colorscheme gruvbox " 设置主题

	if has('gui_running') == 1
		autocmd GUIENter * simalt ~x
	else
		set termguicolors
	endif
	let hour = strftime("%H")
	if hour >= 7 && hour < 19
		set background=light
	else
		set background=dark
	endif

elseif has('unix') == 1
	" Linux 或类 Unix 系统设置
	" TODO: 设置适配 Linux 或类 Unix 系统的配置
else
	echo "未适配或未知操作系统"
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 其他环境变量
if has('win32') || has('win64')
	" Windows 系统的 Vimfiles 路径
	let $VIMRCHOME = expand($VIM . '\vimfiles\')
elseif has('unix')
	" Linux 或类 Unix 系统的 Vimfiles 路径
	let $VIMRCHOME = expand('/etc/vim/')
else
	echo "未适配或未知操作系统"
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件管理

" go 语言支持
let g:go_code_completion_enabled = 1
if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls', '-remote=auto']},
        \ 'allowlist': ['go', 'gomod', 'gohtmltmpl', 'gotexttmpl'],
        \ })
    autocmd BufWritePre *.go
        \ call execute('LspDocumentFormatSync') |
        \ call execute('LspCodeActionSync source.organizeImports')
endif


" python 语言支持
if executable('pylsp')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

" vimL 语言支持
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

	" 折叠
	set foldmethod=expr
	\ foldexpr=lsp#ui#vim#folding#foldexpr()
	\ foldtext=lsp#ui#vim#folding#foldtext()
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END



" 补全功能(可以使用tab和cr进行选择)
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"


" 状态栏
let g:lightline = {
			\ 'colorscheme': 'wombat',
			\ 'active': {
			\   'left': [ [ 'mode', ], [ 'gitbranchstatus', 'gitbranch' ] , ['filename', 'readonly', 'modified'] ],
			\   'right': [ ['lineinfo'], [ 'percent' ], ['filetype', 'fileformat', 'fileencoding', 'charvaluehex' ] ],
			\ },
			\ 'component_function': {
			\   'gitbranchstatus': 'FugitiveStatusline',
			\   'gitbranch': 'FugitiveHead'
			\ },
			\ 'component': {
			\   'charvaluehex': '0x%B',
			\ },
			\ }

" 侧边栏
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" rainbow 彩虹括号
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
"autocmd BufRead,BufNewFile * :RainbowToggle
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

finish