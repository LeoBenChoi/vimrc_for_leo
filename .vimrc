let g:start_time = reltime()
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
set signcolumn=yes          " 永远显示符号列（用于 vim-signify 插件）
set shortmess+=I            " 关闭启动信息
set showfulltag             " 完整显示标签内容
set backspace=2             " 退格键删除
set mouse=a                 " 启用鼠标
set encoding=utf-8

" 防止光标抖动
set scrolloff=3
set nocursorline
set lazyredraw

" 防止命令行光标抖动
autocmd VimEnter * if &columns % 2 != 0 | let &columns = &columns + 1 | endif
"autocmd VimEnter * if argc() == 0 | execute 'belowright terminal' | endif
"nnoremap <leader>tt :botright terminal<CR>

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

" 打开 Fern 左侧侧边栏
"nnoremap <Leader>e :Fern . -drawer -toggle -width=30 -reveal=%<CR>


" 使用 Tab 键在 fern 中快速跳转
autocmd FileType fern nnoremap <buffer> <Tab> <Plug>(fern-action-expand)
autocmd FileType fern nnoremap <buffer> <S-Tab> <Plug>(fern-action-collapse)

" airline bufers 
nnoremap <Leader>bp :bprevious<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bl :buffers<CR>
nnoremap <Leader>bc :bp \| bd #<CR>

" tab 功能
" 新建 tab
nnoremap <Leader>tn :tabnew<CR>
" 关闭当前 tab
nnoremap <Leader>tc :tabclose<CR>
" 切换到下一个 tab
nnoremap <Leader>tl :tabnext<CR>
nnoremap <Leader>tj :tabnext<CR>
" 切换到上一个 tab
nnoremap <Leader>th :tabprevious<CR>
nnoremap <Leader>tk :tabprevious<CR>
" 重载当前 tab（可选：执行 :e）
nnoremap <Leader>tr :e<CR>
" 跳转到第 N 个 tab，比如 <Leader>t3
for i in range(1, 9)
    execute 'nnoremap <silent> <Leader>t'.i ':.tabnext '.i.'<CR>'
endfor
" 使用 <Tab> / <S-Tab> 快速切换 tab 页
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabprevious<CR>

" test <leader>
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
if executable('gopls')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'gopls',
                \ 'cmd': ['gopls'],
                \ 'allowlist': ['go'],
                \ 'workspace_config': {
                \   'gopls': {
                \     'ui.completion.usePlaceholders': v:true,
                \     'ui.navigation.importShortcut': 'Both'
                \   }
                \ }
                \ })
endif

" 结构大纲查看：使用 LSP 的 :LspDocumentSymbol
nnoremap <Leader>o :LspDocumentSymbol<CR>

" 补全快捷键：Tab 在弹出菜单时可上下选择
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
"inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() . "\<cr>" : "\<cr>"
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

" Vim-airline 状态栏与图标
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1
let g:airline_theme = 'luna'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
"let g:airline_section_z = '%3p%% | %l:%c'
"let g:airline_section_b = '%{fugitive#head()}'
let g:airline_section_z = '%3p%% ☰ %l:%c %{get(g:, "startup_time_display", " ")}%{" "}%{battery#component()}'
"let g:airline_section_y = '%{GitStatus()}'
" 把 battery 组件插到 section_y 末尾
"let g:airline_section_y = g:airline_section_y . ' %{battery#component()}'
"let g:airline_section_z = '%{battery#component()}'



" Tagbar
"let g:tagbar_ctags_bin = 'D:rogramPortable/ctags-v6.1.0-clang-x64/ctags.exe'
"let g:tagbar_ctags_bin = 'D:/ProgramPortable/ctags-v6.1.8-clang-x64/ctags.exe'
"let g:tagbar_ctags_bin = 'D:\\ProgramPortable\\ctags-v6.1.8-clang-x64\\ctags.exe'
"let g:tagbar_ctags_bin = 'D:\ProgramPortable\ctags-v6.1.0-clang-x64\exuberant-ctags.exe'
" 打开 Tagbar 快捷键，F8 是例子
"nnoremap <F8> :TagbarToggle<CR>
" 设置 Tagbar 宽度（默认是 30）
"let g:tagbar_width = 30
" 设置打开时自动聚焦 Tagbar 窗口
"let g:tagbar_autofocus = 1
" 当关闭文件时自动关闭 Tagbar
"let g:tagbar_autoclose = 1
" 允许 Tagbar 用快速打开方式刷新
"let g:tagbar_recreate = 1
" 如果想让 Tagbar 高亮当前符号
"let g:tagbar_highlight_cursor = 1

" 显示启动时间
function! UpdateAirlineWithStartupTime() abort
    let l:elapsed = reltimefloat(reltime(g:start_time)) * 1000
    let g:startup_time_display = '🚀 ' . printf('%.2f ms', l:elapsed)
    call timer_start(10, { -> execute('redrawstatus!') })

    " 自动清除
    call timer_start(10000, { -> RemoveStartupTime() })
endfunction

function! RemoveStartupTime() abort
    let g:startup_time_display = ''
    call timer_start(10, { -> execute('redrawstatus!') })
endfunction

autocmd VimEnter * call timer_start(100, { -> UpdateAirlineWithStartupTime() })


" fern 基础设置
":Fern {url} -drawer [-opener={opener}] [-reveal={reveal}] [-stay] [-wait] [-width=30] [-keep] [-toggle]
nnoremap <Leader>e :Fern . -drawer -reveal=reveal -stay -width=30 -keep -toggle<CR>
let g:fern#renderer = "nerdfont"

" Fern 快捷键配置
function! s:fern_custom_mappings() abort
    " 右方向键：展开文件夹或打开文件（智能行为）
    nnoremap <buffer> <Right> <Plug>(fern-action-expand)
    " 左方向键：折叠文件夹
    nnoremap <buffer> <Left> <Plug>(fern-action-collapse)
    " 右侧打开
    "nmap <buffer> <CR> <Plug>(fern-action-open:select)
    " 刷新
    nnoremap <buffer> R <Plug>(fern-action-reload)
endfunction
augroup FernCustomKeymaps
    autocmd!
    autocmd FileType fern call s:fern_custom_mappings()
augroup END

" 禁用显示被 .gitignore 忽略的文件或目录
let g:fern_git_status#disable_ignored = 1

" 禁用显示未跟踪（untracked）的文件
let g:fern_git_status#disable_untracked = 1

" 禁用显示 Git 子模块的状态
let g:fern_git_status#disable_submodules = 1

" 禁用显示目录的 Git 状态（即不为目录标记 Git 变化）
let g:fern_git_status#disable_directories = 1



" 左侧图标
"let g:fern#renderer#default#leading = "│"
"let g:fern#renderer#default#root_symbol = "┬ "
"let g:fern#renderer#default#leaf_symbol = "├─ "
"let g:fern#renderer#default#collapsed_symbol = "├─ "
"let g:fern#renderer#default#expanded_symbol = "├┬ "

"let g:fern#mark_symbol                       = '●'
"let g:fern#renderer#default#collapsed_symbol = '▷ '
"let g:fern#renderer#default#expanded_symbol  = '▼ '
"let g:fern#renderer#default#leading          = ' '
"let g:fern#renderer#default#leaf_symbol      = ' '
"let g:fern#renderer#default#root_symbol      = '~ '


" vim-signify
let g:signify_vcs_list = ['git'] " 仅使用 git，可根据需要添加其他
" 设置更新频率（默认为 4000ms，可调低加快反馈）
set updatetime=100
" 快捷键：跳转到下一个 / 上一个 hunk
nmap ]h <Plug>(signify-next-hunk)
nmap [h <Plug>(signify-prev-hunk)
" 显示当前文件的 hunks 概要（可在状态栏调用）
function! GitStatus()
    let [a,m,r] = sy#repo#get_stats()
    return printf('+%d ~%d -%d', a, m, r)
endfunction
" 自定义图标（默认也很好看，可根据喜好调整）
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '-'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = '~'
" 保持变更同步
augroup signify_refresh
    autocmd!
    autocmd BufWritePost * :SignifyRefresh
augroup END

" fugitive & Flog 配置
" 启用 flog 插件图谱命令（默认已有 :Flog）
nnoremap <Leader>gl :Flog<CR>
nnoremap <Leader>gs :G<CR>
nnoremap <Leader>gc :Gcommit<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gf :Gfetch<CR>
nnoremap <Leader>gb :Gblame<CR>
" 打开 Flog 图谱时限制最多加载最近 100 次提交，加快加载速度
command! -nargs=* GL Flog -limit=100 <args>
" 用 TAB 折叠提交详情（在 flog buffer 内）
autocmd FileType flog nnoremap <buffer> <Tab> <Plug>(flog-toggle-fold)
" 使用 Gdiff 查看提交差异（需要 Fugitive）
autocmd FileType flog nnoremap <buffer> <CR> <Plug>(flog-open-preview)
" 打开 flog 时自动聚焦到光标处最近的一次提交
let g:flog_default_arguments = ['--date=short', '--decorate', '--all']
" 美化 Flog 显示（可选）
let g:flog_enable_fold_markers = 1
" Fugitive 状态显示（airline扩展）
let g:airline#extensions#branch#enabled = 1


" fzf.vim 配置
" 初始化fzf.vim
let g:fzf_vim = {}
" 必须启用这些基础功能
set rtp+=~/.vim/vimfiles/pack/plugins/start/fzf
" 窗口
"let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_layout = { 'down': '~30%' }
" - Window using a Vim command
"let g:fzf_layout = { 'window': 'enew' }
"let g:fzf_layout = { 'window': '-tabnew' }
"let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
"let g:fzf_colors =
"\ { 'fg':      ['fg', 'Normal'],
"  \ 'bg':      ['bg', 'Normal'],
"  \ 'query':   ['fg', 'Normal'],
"  \ 'hl':      ['fg', 'Comment'],
"  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"  \ 'hl+':     ['fg', 'Statement'],
"  \ 'info':    ['fg', 'PreProc'],
"  \ 'border':  ['fg', 'Ignore'],
"  \ 'prompt':  ['fg', 'Conditional'],
"  \ 'pointer': ['fg', 'Exception'],
"  \ 'marker':  ['fg', 'Keyword'],
"  \ 'spinner': ['fg', 'Label'],
"  \ 'header':  ['fg', 'Comment'] }

" 快捷键绑定
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
" 文件模糊搜索
nnoremap <leader>ff :Files<CR>
" Git 文件
nnoremap <leader>fg :GFiles<CR>
" 搜索内容（使用 rg）
nnoremap <leader>fa :Rg<CR>
" 打开 buffer
nnoremap <leader>fb :Buffers<CR>
" 书签
nnoremap <leader>fm :Marks<CR>
" 历史
nnoremap <leader>fh :History<CR>
" 避免和 airline 冲突的映射
let g:fzf_buffers_jump = 1
let $FZF_DEFAULT_OPTS = '--bind=ctrl-j:preview-down,ctrl-k:preview-up'


" vista 配置 | 查看类大纲
" 快捷键：打开/关闭 Vista 侧边栏
nnoremap <Leader>v :Vista!!<CR>

" 默认使用 LSP （配合 vim-lsp）
let g:vista_default_executive = 'lsp'
"let g:vista_default_executive = 'ctags'

" 如果当前 buffer 没有 LSP 支持，则回退到 ctags
let g:vista_executive_for = {
      \ 'go': 'ctags',
      \ 'python': 'lsp',
      \ 'javascript': 'lsp',
      \ 'typescript': 'lsp',
      \ 'vim': 'ctags',
      \ }

" 设置 Vista 窗口的位置（默认右侧）
" 配置值	效果说明
" 'vertical topleft'	左侧打开
" 'vertical botright'	右侧打开
" 'topleft'	顶部（水平分屏）
" 'botright'	底部（水平分屏）
let g:vista_sidebar_position = 'vertical botright'

" Vista窗口宽度
let g:vista_sidebar_width = 40
" 设置 Vista 侧边栏宽度为当前窗口宽度的 30%
function! SetVistaWidthToPercent()
    " 保存当前窗口ID
    let original_win = win_getid()
    
    " 获取当前窗口宽度（列数）
    let current_width = winwidth(0)
    
    " 计算 30% 的宽度并取整
    let new_width = float2nr(current_width * 0.3)
    
    " 确保最小宽度为 20（防止计算结果过小）
   " 确保最小宽度为 20 , 最大宽度为 60
    let min_width = 20
    let max_width = 60
    if new_width > max_width
        let new_width = max_width
    else new_width < min_width
        let new_width = min_width
    endif
endfunction

" 仅在打开 Vista 窗口时调用一次设置函数
autocmd User VistaOpening call SetVistaWidthToPercent()

" 自动跳转到 symbol，选中后关闭 Vista（可选）
let g:vista_close_on_jump = 1

" 支持 Nerd Fonts 图标（推荐配合 vim-devicons）
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

" 打开文件时自动加载 Vista（可选）
" autocmd VimEnter * Vista

finish
