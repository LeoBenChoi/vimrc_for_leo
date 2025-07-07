" ========================================================================
" Global 基础设置
" ========================================================================
set nocompatible             " 禁用 vi 兼容模式
set number                  " 显示行号
set relativenumber          " 相对行号
set numberwidth=4           " 行号列宽
set showmatch               " 高亮匹配括号
set cursorline              " 高亮当前行
set cursorcolumn            " 高亮当前列
set colorcolumn=80          " 高亮显示第80列
set list lcs=tab:\|\       " 可见化制表符（示例：tab 用 '|' 表示）
set signcolumn=yes          " 永远显示符号列（用于 Gutter 插件）
set shortmess+=I            " 关闭启动信息
set showfulltag             " 完整显示标签内容
set mouse=a                 " 启用鼠标
set backspace=2             " 退格键删除


" 搜索设置（大小写智能感知）
set noignorecase              " 搜索区分大小写, 区分大小写用ignorecase
set smartcase               " 搜索时包含大写即区分大小写:contentReference[oaicite:4]{index=4}
set incsearch               " 增量搜索
set hlsearch                " 高亮搜索结果

" 命令行补全
set wildmenu                " 使用增量命令补全菜单
set wildmode=longest:full,full
set wildoptions=pum         " 在补全时使用垂直弹出菜单:contentReference[oaicite:5]{index=5}
set pumheight=20            " 弹出菜单最大行数

" ========================================================================
" 界面显示
" ========================================================================
set showtabline=2          " 标签页行始终显示
set laststatus=2          " 始终显示状态栏
set cmdheight=2           " 命令行高度 2
set guifont=Consolas:h12   " GUI 模式下字体（Windows 环境示例）
"set ambiwidth=double      " 宽字符占两个位置
set background=dark       " 默认背景（自动切换在后面设置）
" 注意：自动背景设置逻辑见下方

" ========================================================================
" 折叠配置
" ========================================================================
set viewdir=~/.vim/.view   " 保存视图信息（折叠/光标等）
set foldenable            " 启用折叠
augroup SetFoldingByFiletype
  autocmd!
  nnoremap <space> za           " 空格切换折叠
  autocmd FileType go setlocal foldmethod=syntax
  autocmd FileType python setlocal foldmethod=indent
  autocmd BufWinLeave *.py,*.go if &buftype == '' | silent! mkview | endif
  autocmd BufWinEnter *.py,*.go if &buftype == '' | silent! loadview | endif
augroup END

" 自定义折叠文本
set foldtext=CustomFoldText()
function! CustomFoldText()
  let start = substitute(getline(v:foldstart), '\t', '    ', 'g')
  let end = substitute(getline(v:foldend), '\t', '    ', 'g')
  let end_no_indent = substitute(end, '^\s*', '', '')
  let folded = start . ' ... ' . end_no_indent
  let count = v:foldend - v:foldstart + 1
  let info = printf('[ %d - %d ] ==> %d lines <  ', v:foldstart, v:foldend, count)
  let width = &textwidth > 0 ? &textwidth : 80
  let spacing = width - strwidth(folded) - strwidth(info)
  let pad = repeat(' ', spacing > 0 ? spacing : 1)
  return folded . pad . info
endfunction

" ========================================================================
" 备份、交换和撤销
" ========================================================================
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

" 自动恢复上次编辑位置
autocmd! BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif

" ========================================================================
" 缩进设置
" ========================================================================
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab     " 使用空格代替制表符

" ========================================================================
" 文件类型与语法
" ========================================================================
filetype plugin indent on  " 一次性启用文件类型检测、插件和缩进:contentReference[oaicite:6]{index=6}
syntax on                  " 启用语法高亮

" ========================================================================
" 主题切换（根据时间自动亮/暗）
" ========================================================================
let hour = strftime("%H")
if hour >= 7 && hour < 19
  set background=light
else
  set background=dark
endif

" ========================================================================
" 键盘映射与快捷键
" ========================================================================
let mapleader = "\\"
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>

" 切换主题（F4）
nnoremap <silent> <F4> :execute (&background ==# 'dark' ? 'set background=light' : 'set background=dark')<CR>

" 代码运行/调试（F5/F6）
autocmd FileType python,go nnoremap <buffer> <F5>  :call RunCode()<CR>
autocmd FileType python,go nnoremap <buffer> <C-F5>:call DeBugCode()<CR>

function! RunCode()
  update
  if &filetype ==# 'python'
    :belowright terminal python %
  elseif &filetype ==# 'go'
    :belowright terminal go run .
  endif
endfunction

function! DeBugCode()
  if &filetype ==# 'python'
    :!python %
  elseif &filetype ==# 'go'
    :!go build .
  endif
endfunction

" 注释当前行（仅 Go 示例，支持多种语言）
if has('win32') || has('win64')
  autocmd FileType go noremap <buffer> <C-/> :call CommentCurrentLine()<CR>
else
  autocmd FileType go noremap <buffer> <C-_> :call CommentCurrentLine()<CR>
endif
function! CommentCurrentLine()
  let s:map = {
        \ 'go': '//',
        \ 'c': '//',
        \ 'cpp': '//',
        \ 'java': '//',
        \ 'python': '#',
        \ 'sh': '#',
        \ 'bash': '#',
        \ 'lua': '--',
        \ }
  let ft = &filetype
  let prefix = get(s:map, ft, '')
  if empty(prefix)
    echo "Unsupported filetype: " . ft
    return
  endif
  let line = getline('.')
  if line =~ '^\s*' . escape(prefix, '#') 
    let line = substitute(line, '^\(\s*\)' . escape(prefix, '#') . '\s*', '\1', '')
  else
    let line = substitute(line, '^\s*', '\0' . prefix . ' ', '')
  endif
  call setline('.', line)
endfunction

" ========================================================================
" 标志和环境变量
" ========================================================================
let g:flag_git = 0
let g:flag_install = 0
if filereadable(expand('~/.vim/vimfiles/flag/flag_install'))
  let g:flag_install = 1
endif

function! InstallPlugins()
  source ~/.vim/vimfiles/vimscript/InstallPlugins.vim
endfunction

if g:flag_install == 0
  finish
endif

" ========================================================================
" 不同操作系统的设置
" ========================================================================
" used Linux: Kali, Ubuntu, CentOS
" used Windows: Windows 11, 10

" colorscheme color
 set t_Co=256
if has('termguicolors')
  set termguicolors
endif
if has('win32') || has('win64')
    set guifont=更纱终端书呆黑体-简:h14:cGB2312:qDRAFT,Consolas,h12:b:cANSI:qDRAFT
  set packpath+=~/.vim/vimfiles
  if !isdirectory(expand('$VIM/vimfiles/flag'))
    call mkdir(expand('$VIM/vimfiles/flag'), 'p')
  endif
  colorscheme gruvbox       " Windows 下默认主题
  if has('gui_running')
    autocmd GUIEnter * simalt ~x
  endif
elseif has('unix')
  set packpath+=~/.vim/vimfiles
  colorscheme gruvbox       " Unix 下默认主题
else
  echo "Unrecognized system"
endif

" ========================================================================
" 插件配置（LSP 和其他）
" ========================================================================
" LSP 缓冲区初始化时映射常用命令
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nnoremap <buffer> gd <plug>(lsp-definition)
  nnoremap <buffer> gs <plug>(lsp-document-symbol-search)
  nnoremap <buffer> gr <plug>(lsp-references)
  nnoremap <buffer> gi <plug>(lsp-implementation)
  nnoremap <buffer> gt <plug>(lsp-type-definition)
  nnoremap <buffer> <leader>rn <plug>(lsp-rename)
  nnoremap <buffer> [g <plug>(lsp-previous-diagnostic)
  nnoremap <buffer> ]g <plug>(lsp-next-diagnostic)
  nnoremap <buffer> K <plug>(lsp-hover)
  nnoremap <buffer> <expr> <C-f> lsp#scroll(+4)
  nnoremap <buffer> <expr> <C-d> lsp#scroll(-4)
  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
  autocmd BufWritePre *.go :GoImports
endfunction
augroup lsp_setup
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" 配置各语言的 LSP 服务器
"Bash
"ccls - C/C++
"Clangd - C/C++
"Clojure
"Crystal
"Css/Less/Sass
"cquery - C/C++
"CWL
"Docker
if executable('docker-langserver')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'docker-langserver',
    \ 'cmd': {server_info->['docker-langserver', '--stdio']},
    \ 'allowlist': ['dockerfile']
    \ })
endif

"Erlang
"Flow - Javascript
"Go
if executable('gopls')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': ['gopls', '-remote=auto'],
    \ 'allowlist': ['go', 'gomod', 'gohtmltmpl', 'gotexttmpl']
    \ })
  let g:go_def_mode = 'gopls'
  let g:go_info_mode = 'gopls'
  let g:go_fmt_command = "goimports"   " 保存时自动格式化并排序 import
  let g:go_gopls_enabled = 1
  let g:go_code_completion_enabled = 1
  let g:go_doc_keywordprg_enabled = 0
  autocmd BufWritePre *.go :silent! GoImports
endif

"Godot
"Groovy
"Hack
"Haskell
"HTML
if executable('html-languageserver')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'html-ls',
    \ 'cmd': ['html-languageserver', '--stdio'],
    \ 'allowlist': ['html']
    \ })
endif

"Java
if executable('jdtls')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'Eclipse JDT LS',
    \ 'cmd': ['jdtls'],
    \ 'allowlist': ['java']
    \ })
endif

"JavaScript and TypeScript
if executable('typescript-language-server')
  augroup LspJS_TS
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'typescript-language-server',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(
      \     lsp#utils#find_nearest_parent_file_directory(
      \         lsp#utils#get_buffer_path(), 'tsconfig.json'))},
      \ 'allowlist': ['javascript', 'javascript.jsx', 'typescript', 'typescript.tsx', 'typescriptreact'],
      \ })
  augroup END
endif
autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx call execute('LspCodeActionSync source.organizeImports')
autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx call execute('LspDocumentFormatSync')

"Julia
"Kotlin
"Lua
"Perl
"PHP
if executable('intelephense')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'intelephense',
    \ 'cmd': ['intelephense', '--stdio'],
    \ 'allowlist': ['php'],
    \ 'initialization_options': {'storagePath': '/tmp/intelephense'},
    \ 'workspace_config': {
    \   'intelephense': {
    \     'files': {'maxSize': 1000000, 'associations': ['*.php','*.phtml'], 'exclude': []},
    \     'completion': {'insertUseDeclaration': v:true, 'triggerParameterHints': v:true},
    \     'format': {'enable': v:true},
    \   }
    \ }
    \ })
endif

"Python
if executable('pyls') " or 'pylsp'
  au User lsp_setup call lsp#register_server({
    \ 'name': 'pyls',
    \ 'cmd': ['pyls'],
    \ 'allowlist': ['python'],
    \ 'workspace_config': {'pyls': {'plugins': {'pydocstyle': {'enabled': v:true}}}}
    \ })
endif

"Ruby
"Rust
"Scala
"Swift
"Tex
"TOML

if executable('vim-language-server')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'vimls',
    \ 'cmd': ['vim-language-server', '--stdio'],
    \ 'allowlist': ['vim'],
    \ 'initialization_options': {
    \   'vimruntime': $VIMRUNTIME,
    \   'runtimepath': &rtp,
    \ }})
endif

"OCaml+Reason
"VHDL
"Vim
"YAML
if executable('yaml-language-server')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'yamlls',
    \ 'cmd': ['yaml-language-server', '--stdio'],
    \ 'allowlist': ['yaml', 'yaml.ansible'],
    \ 'workspace_config': {
    \   'yaml': {'validate': v:true, 'hover': v:true, 'completion': v:true}
    \ }
    \ })
endif

" === 启用 LSP 自动补全（支持 JavaScript / TypeScript / Go / Python 等） ===
let g:lsp_async_completion = 1

" === 补全行为优化 ===
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_remove_duplicates = 1

" === 注册补全源 ===
" LSP 补全源
" 延迟注册所有补全源，确保 asyncomplete 插件已加载
augroup AsyncompleteRegister
  autocmd!
  autocmd VimEnter * call s:asyncomplete_register_sources()
augroup END

function! s:asyncomplete_register_sources() abort
  if exists('*asyncomplete#register_source')
    " 注册 LSP 补全源
    if exists('*asyncomplete#sources#lsp#get_source_options')
      call asyncomplete#register_source(asyncomplete#sources#lsp#get_source_options({
      \ 'name': 'lsp',
      \ 'whitelist': ['go', 'python', 'javascript', 'typescript', 'json', 'html', 'css'],
      \ }))
    endif
    " 注册 Buffer 补全源
    if exists('*asyncomplete#sources#buffer#get_source_options')
      call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
      \ 'name': 'buffer',
      \ 'whitelist': ['*'],
      \ }))
    endif
    " 注册文件路径补全源
    if exists('*asyncomplete#sources#file#get_source_options')
      call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'file',
      \ 'whitelist': ['*'],
      \ }))
    endif
  endif
endfunction
" 补全快捷键：Tab 在弹出菜单时可上下选择
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)
" For Vim 8 (<c-@> corresponds to <c-space>):
" imap <c-@> <Plug>(asyncomplete_force_refresh)
let g:asyncomplete_auto_popup = 0

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" allow modifying the completeopt variable, or it will
" be overridden all the time
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" rainbow 括号高亮
let g:rainbow_active = 1
let g:rainbow_conf = {
\ 'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\ 'ctermfgs': ['lightblue', 'lightcyan', 'lightgreen', 'lightmagenta'],
\ 'operators': '_,_',
\ 'separately': {
\   '*': {},
\   'go': {
\     'parentheses': ['start=/(/ end=/)/ fold', 'containedin=goFunction'],
\     'braces': ['start=/{/ end=/}/ fold'],
\     'brackets': ['start=/\[/ end=/\]/ fold'],
\   }
\ }
\}

" NERDTree 文件树设置
"let g:NERDTreeShowHidden = 1
"autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
"  \ quit |
"  \ endif
"autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
"  \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | buffer#buf | endif
"autocmd BufWinEnter * if &buftype !=# 'quickfix' && getcmdwintype() ==# '' | silent NERDTreeMirror | endif
"nnoremap <leader>t :NERDTreeToggle<CR>
" ===============================
" NERDTree 配置
" ===============================

" 显示隐藏文件（.gitignore 中的也会显示）
let g:NERDTreeShowHidden = 1

" 在 Vim 启动时打开 NERDTree（如果无文件参数）
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" 自动关闭 Vim 如果 NERDTree 是唯一窗口
autocmd BufEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), '&filetype') ==# 'nerdtree' | quit | endif

" 打开新 tab 时自动启动 NERDTree
"autocmd TabNewEntered * NERDTree
autocmd TabNew * NERDTree

" 启用文件行统计（可能略耗资源）
let g:NERDTreeFileLines = 1

" 设置 NERDTree 快捷键（使用 <leader>t）
nnoremap <leader>t :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>     " 定位当前文件

" 禁用 netrw 以避免冲突
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" NERDTree 图标支持（如果已装 devicons）
let g:webdevicons_enable = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

let g:NERDTreeShowHidden = 1                    " 显示隐藏文件
let g:NERDTreeMinimalUI = 0                     " 显示帮助文本
"let g:NERDTreeDirArrows = 0                     " 不用箭头，避免渲染卡顿
let g:NERDTreeAutoDeleteBuffer = 1              " 自动关闭 buffer
let g:NERDTreeStatusline = ''                   " 禁用状态栏显示

" 快捷键：<Leader>t 打开/关闭 NERDTree
nnoremap <leader>t :NERDTreeToggle<CR>
" 新 tab 自动打开 NERDTree（保留更好的用户体验）
"autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent! NERDTreeMirror | endif
"autocmd VimEnter * NERDTree
" 如果当前只有 NERDTree 窗口，自动退出
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" 若你想设置默认宽度
let g:NERDTreeWinSize = 32
" 显示书签标志（可手动设置书签）
"let g:NERDTreeShowBookmarks = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1


" vim-signify 更新延时
"set updatetime=100

" GitGutter 快捷键
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction

" Vim-airline 状态栏与图标
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'luna'
"let g:airline_theme = 'default'
"let g:airline_section_z = '%3p%% | %l:%c'
let g:airline_section_z = '%3p%% ☰ %l:%c %{g:startup_time_display}'

" vim-fugitive 设置
let g:netrw_banner = 0
let g:fugitive_no_autochdir = 1

" Devicons 文件图标
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1

finish

