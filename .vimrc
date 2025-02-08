"""""""""""
" 基本设置 "
"""""""""""
" 不显示
set nocompatible    " 关闭 vi 兼容模式
set backspace=2     " 合理的退格键行为
set encoding=utf-8	" 在 Vim 中使用的字符编码："latin1", "utf-8","euc-jp", "big5" 等
set fileencodings=utf-8,ucs-bom,gb18030,cp936,latin1    " 文件编码优先级
set autochdir       " 自动切换工作路径
set mouse=a         " 所有模式都支持鼠标
set ttymouse=sgr    " 鼠标兼容
set history=100     " 设置命令历史记录条数
set nobackup        " 取消自动备份功能
set noswapfile      " 取消生成swp文件
set noundofile      " 取消生成un文件

" 顶部
set showfulltag	    " 显示完整标签
set showtabline=2   " 总是显示标签页栏
"set title           " 设置标题栏

" 底部
set cmdheight=2	    " 设置命令行高度
set laststatus=2    " 总是显示状态行
set wildmenu        " 命令行补全菜单
set showcmd         " 显示正在输入的命令
set ruler           " 显示光标位置
set showmode        " 显示当前模式
set wildmode=list:longest,full    " 命令行补全模式

" 左边
set number	            " 显示行号
set numberwidth=4	    " 设置行号列宽
set foldmethod=marker   " 设置折叠方式为标记
set foldlevelstart=99   " 设置折叠级别为99
set foldcolumn=3        " 设置折叠栏宽度为3
set foldnestmax=10     " 设置最大折叠深度为10
set signcolumn=yes     " 打开标志列

" 搜索功能
set incsearch       " 实时搜索
set hlsearch	    " 高亮搜索结果
set ignorecase      " 使用搜索模式时忽略大小写

" 编辑区
"set list                " 显示制表符和换行符
set showmatch           " 高亮匹配的括号
set cursorline          " 突出显示当前行
set cursorcolumn        " 突出显示当前列
set colorcolumn=80      " 设置突出显示列为80
set t_Co=256            " 设置终端颜色数为256
set termguicolors       " 启用终端颜色
"set background=dark    " 设置背景色为暗色
set guifont=Consolas:h14:b:cANSI:qDRAFT    " 设置字体
set breakindent         " 自动缩进换行符
set textwidth=80        " 设置文本宽度为80
set wrapmargin=80       " 设置自动换行的列数为80
set linebreak         " 允许在长行中断行
"set showbreak=+++    " 设置换行符显示方式
set shiftwidth=4     " 设置缩进宽度为4
set softtabstop=4    " 设置软缩进宽度为4
set tabstop=4        " 设置硬缩进宽度为4
"set expandtab       " 使用空格代替制表符
set scrolloff=3      " 光标上下滚动3行时保持在屏幕中间
set sidescrolloff=5  " 光标左右滚动5列时保持在屏幕中间
set whichwrap=b,s,h,l,[,]    " 设置光标移动时的换行方式
set listchars=tab:»\ ,eol:¬  " 设置制表符和换行符的显示方式
set showmatch       " 显示匹配的括号
set autoindent 		" 自动缩进
set smartindent 	" 自动智能缩进
filetype plugin on 		" 打开文件类型检测
filetype indent on 		" 打开文件类型缩进
set updatetime=500     " 设置自动语法检查的时间间隔
set balloondelay=250   " 设置气泡延迟时间

" 打开文件回到上次编辑位置
autocmd! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif 
" 设置VIMHOME目录位置
if has('win32') || has ('win64')
    let $VIMHOME = $VIM.'\vimfiles'
else
    let $VIMHOME = $HOME."/.vim"
endif
" gvim
if has('gui_running') == 1
	:set background=light "背景 dark or light
    :colorscheme morning " 主题
	:set ambiwidth=double " 宽度有歧义字符的宽度（解决中文引号显示不全问题）
elseif has('gui_running') == 0
	:set background=dark
	:colorscheme industry
endif


" 语法高亮
syntax off
autocmd! BufEnter,BufNewFile *.go,go.mod,*.py,_vimrc syntax on
autocmd! BufLeave *.go,go.mod,*.py,_vimrc syntax off

""""""""""
" 状态栏 "
""""""""""
:set statusline=%1*[%t]%2*\ [%{&ff}(%{&fenc})]\ %3*%y%4*%h%m%r%=%5*%l,%-10v%-3p%%
hi User1 cterm=none ctermfg=0 ctermbg=255
hi User2 cterm=none ctermfg=5 ctermbg=0
hi User3 cterm=none ctermfg=3 ctermbg=0
hi User4 cterm=none ctermfg=red ctermbg=0
hi User5 cterm=none ctermfg=2 ctermbg=0
set laststatus=2 " 启用状态栏

""""""""""""
" 字典补全 "
""""""""""""
" 启用字典补全模式
set complete=.,w,b,u,t,i,k
" 补全时显示菜单：显示菜单，不自动选择第一项，只有一个选项也显示菜单
set completeopt+=menu,noselect,menuone
" 字典路径
if !exists('$VIMDICT')
    let $VIMDICT = expand('$VIM\vimfiles\spell')
endif
autocmd! FileType go call SetGoDict()
" 定义 SetGoDict 函数
function! SetGoDict()
	"let files = glob($VIMDICT . '/go/*.go.vimdict', 1, 1) "
	"原始方案，固定了后缀
	let files = glob($VIMDICT . '/go/*', 1, 1)
	let files_list = join(files, ', ')
	if has('win32') || has ('win64')
		let files_list = substitute(files_list, ' ', '\\ ', 'g') " 解决Windows路径问题
	endif
	execute 'set dict+=' . files_list
endfunction

" 键盘映射 "
source $VIM/vimfiles/keymap/default.keymap.vim

"""""""""""
" 插件管理 "
"""""""""""
" 注册插件服务
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

