" --- [最优先配置] ---
" leader 键
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"
nnoremap <Space> <Nop>
xnoremap <Space> <Nop>

" 禁用 Python2，指定 Python3 (Windows 提速关键)
let g:loaded_python_provider = 0
let g:python3_host_prog = 'python3' 

" --- [基础设置] ---
set nocompatible " 不兼容vi
filetype on
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gbk,gb2312,big5
set history=1000

" --- [界面体验] ---
set number
set relativenumber
set laststatus=2
set wildmenu
set wildmode=longest:full,full
set ruler
set showcmd
set lazyredraw         " 性能关键
set ttyfast
" 更新延迟时间（默认 4000ms = 4s）过长会导致明显延迟和体验差
" 设置为 300ms 以获得更好的响应速度（用于 CursorHold 事件和诊断更新）
set updatetime=300

" --- [编辑习惯] ---
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set mouse=a
" 不可见字符显示（使用 :set list 启用）
set listchars=tab:▸\ ,trail:·,extends:»,precedes:«,nbsp:␣
set list

" --- [搜索] ---
set hlsearch
set incsearch
set ignorecase
set smartcase

" --- [文件处理] ---
set autoread
set autowrite
set nobackup
set nowritebackup
set noswapfile

" --- [GVim 去边框 (UI 准备)] ---
" GUI 模式
if has("gui_running")
    set guifont=Maple_Mono_NL_NFMono_CN:h12
    set guioptions-=m  " 去菜单栏
    set guioptions-=T  " 去工具栏
    set guioptions-=e  " 去异常菜单
    set guioptions-=r  " 去右滚动条
    set guioptions-=R  " 去右分割条
    set guioptions-=l  " 去左滚动条
    set guioptions-=L  " 去左分割条
    set notitle        " 不显示标题
endif

" --- [按键映射] ---
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>h :nohlsearch<CR>
" 窗口移动
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" 行首行尾
nnoremap H ^
nnoremap L $

" --- [主题应用] ---
set background=dark
if has("gui_running")
    try
        colorscheme retrobox
    catch
        colorscheme default
    endtry
else
    try
        colorscheme seoul256
    catch
        colorscheme default
    endtry
endif

" 自动命令
augroup vimrc
    autocmd!
    " 自动去除行尾空格
    autocmd BufWritePre * %s/\s\+$//e
    " 记住上次光标位置
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    " Quickfix 窗口：取消相对行号显示，只显示绝对行号
    autocmd FileType qf setlocal norelativenumber
    
    " 当当前标签页的最后一个窗口是辅助窗口时，自动关闭当前标签页或退出 Vim
    " 辅助窗口类型：Quickfix、NERDTree、Vista 等
    function! s:CloseTabIfOnlyAuxWindow()
        " 使用延迟执行避免 E1312 错误（不能在 BufEnter 中直接改变窗口布局）
        if winnr('$') == 1
            let buftype = &buftype
            let filetype = &filetype
            " 检查是否是辅助窗口
            if buftype ==# 'quickfix' || 
             \ filetype ==# 'nerdtree' || 
             \ filetype ==# 'vista' ||
             \ (exists('b:NERDTree') && b:NERDTree.isTabTree())
                " 检查标签页数量：如果只有一个标签页则退出 Vim，否则关闭当前标签页
                let tab_count = tabpagenr('$')
                if tab_count == 1
                    " 只有一个标签页，退出 Vim
                    call timer_start(0, {-> execute('quit')})
                else
                    " 有多个标签页，关闭当前标签页
                    call timer_start(0, {-> execute('tabclose')})
                endif
            endif
        endif
    endfunction
    autocmd BufEnter * call s:CloseTabIfOnlyAuxWindow()
augroup END