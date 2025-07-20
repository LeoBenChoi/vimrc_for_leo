" ==================================================
" BASIC.VIM - 核心编辑器配置
" 功能：基础设置/性能优化/通用行为
" 加载顺序：应在其他配置前最先加载
" ==================================================

" 确保只加载一次
if exists('g:loaded_basic_config')
    finish
endif
let g:loaded_basic_config = 1

" 设置不兼容vi
if &compatible
    set nocompatible
endif

" ========================
" 基础行为配置
" ========================

" 文件编码设置（跨平台兼容）
set encoding=utf-8              " 内部编码
set fileencoding=utf-8          " 新文件默认编码
set fileencodings=utf-8,gb2312,gbk,cp936,latin1 " 自动检测编码顺序

" 文件处理行为
set autoread                    " 文件被外部修改时自动重新加载
set hidden                      " 允许缓冲区隐藏而不保存
set confirm                     " 未保存时显示确认对话框

" ========================
" 性能优化
" ========================

set lazyredraw                  " 执行宏/寄存器时不重绘
set ttyfast                     " 快速终端连接, 优化终端重绘
" set timeoutlen=500              " 映射等待时间(ms)
set updatetime=3000              " 写入交换文件间隔(ms)(影响插件)
set synmaxcol=200               " 只高亮行前100列
set re=1                        " 使用旧版正则引擎（对复杂语法更快）
set notimeout                   " 禁用命令超时
set nottimeout                  " 禁用键盘映射超时

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

" 自动恢复上次编辑位置
autocmd! BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g'\"" |
            \ endif

" ========================
"  搜索行为
" ========================

set ignorecase                  " 搜索忽略大小写
set smartcase                   " 包含大写时转为精确匹配
set hlsearch                    " 高亮搜索结果
set incsearch                   " 实时搜索反馈
set wrapscan                    " 搜索到文件尾时循环

" ========================
" 缩进与制表符
" ========================

" 基础设置
set list
" let &listchars='tab:▸ '+',trail:·'
set listchars=tab:▸\ ,space:.,multispace:▸,extends:❯,precedes:❮,eol:↴

" 智能缩进显示函数
function! SmartIndentDisplay()
    " 获取当前缩进宽度 (优先级: shiftwidth > tabstop)
    let width = &shiftwidth > 0 ? &shiftwidth : &tabstop
    if width == 2
        " let symbol = '»\ '
        let symbol = '▸\ '
    elseif width == 4
        let symbol = '▸····'
    elseif width == 8
        let symbol = '▸\ \ \ \ \ \ \ '
    else
        let symbol = '→' . repeat('\ ', width - 1)
    endif

    if has('patch-9.0.0')
        execute 'set listchars+=multispace:' . symbol
    endif

    " 高亮组
    highlight SpecialKey ctermfg=7 guifg=#555555
endfunction

" 文件加载时应用智能缩进
autocmd BufEnter * call SmartIndentDisplay()
autocmd FileType * call SmartIndentDisplay()

" ========================
" 界面显示
" ========================

set number                      " 显示行号
set relativenumber              " 显示相对行号
set cursorline                  " 高亮当前行
set scrolloff=5                 " 垂直滚动保留行数
set sidescrolloff=5             " 水平滚动保留列数
set display+=lastline           " 尽量显示长行最后的内容
set showmatch                   " 显示括号匹配
set matchtime=2                 " 括号匹配高亮时间(0.1s单位)
set matchpairs+=<:>             " 增加HTML标签匹配
set shortmess+=I            " 关闭启动信息
set showfulltag             " 完整显示标签内容
set signcolumn=yes          " 始终显示符号列
set numberwidth=4           " 设置行号列宽度（默认4字符）

" 启用真彩色支持（终端需支持）
if has('termguicolors')
    set termguicolors
endif

" 全屏打开
" guifont 设置（仅 GUI 环境）
if has('gui_running')
    autocmd GUIEnter * simalt ~x
endif

" 设置文本宽度（根据团队规范调整，常用值如下）
set textwidth=80   " 经典Unix风格（Linux内核等使用）
" set textwidth=100 " 现代项目常用
" set textwidth=120 " 大型项目可能使用

" 自动折行设置
set wrap                " 启用视觉折行
set linebreak           " 只在单词边界折行
set textwidth=80        " 自动换行
set wrapmargin=8        " 自动换行边距
set breakindent         " 折行后保持缩进
set display+=lastline   " 显示长行最后的内容

" 高亮指定列（textwidth+1列）
set colorcolumn=+1
highlight ColorColumn ctermbg=lightgrey guibg=lightgrey

" 当前行高亮
set cursorline
highlight CursorLine cterm=NONE ctermbg=darkgrey guibg=lightgrey

" 当前列高亮（需要Vim 7.4.792+或Neovim）
set cursorcolumn
highlight CursorColumn cterm=NONE ctermbg=darkgrey guibg=lightgrey

" 只在普通模式下高亮当前行（避免插入模式干扰）
augroup cursor_highlight
    autocmd!
    autocmd InsertEnter * set nocursorline nocursorcolumn
    autocmd InsertLeave * set cursorline cursorcolumn
augroup END


" 行号高亮
highlight LineNr ctermfg=darkgrey guifg=#5c6370
highlight CursorLineNr cterm=bold ctermfg=yellow gui=bold guifg=#e5c07b

" 状态栏显示行列信息
set ruler          " 显示光标位置
set laststatus=2   " 总是显示状态栏

" ========================================================================
" 折叠配置
" ========================================================================

set viewdir=~/.vim/.view   " 保存视图信息（折叠/光标等）
set viewoptions=cursor,folds,slash,unix " 保存视图信息（折叠/光标等）
set foldenable              " 启用折叠
" nnoremap <space> za " 切换折叠 写到base里面了
" 自动加载视图并根据文件是否保存了视图进行折叠设置
augroup AutoFold
    autocmd!
    " 自动保存/加载折叠状态
    autocmd BufWinLeave *.* mkview       " 关闭文件时保存折叠
    autocmd BufWinEnter *.* silent! loadview  " 打开文件时加载折叠
augroup END

" 折叠方法 使用语言排序
augroup SetFoldingByFiletype
    autocmd!
    " a
    " b
    " c
    autocmd FileType css        setlocal foldmethod=marker foldmarker={{{,}}}
    " d
    " e
    " f
    " g
    autocmd FileType go         setlocal foldmethod=syntax
    " h
    autocmd FileType htm        setlocal foldmethod=expr foldexpr=HTMLFold()
    autocmd FileType html       setlocal foldmethod=expr foldexpr=HTMLFold()
    " i
    " j
    autocmd FileType javascript setlocal foldmethod=syntax
    autocmd FileType json       setlocal foldmethod=syntax
    autocmd FileType jsp        setlocal foldmethod=expr foldexpr=HTMLFold()
    " k
    " l
    " m
    " n
    " o
    " p
    autocmd FileType python     setlocal foldmethod=indent
    autocmd FileType phtml      setlocal foldmethod=indent
    autocmd FileType php        setlocal foldmethod=expr foldexpr=HTMLFold()
    " q
    " r
    " s
    " t
    autocmd FileType typescript setlocal foldmethod=syntax
    " u
    " v
    autocmd BufRead,BufNewFile *.vue set filetype=vue
    " autocmd FileType vue        setlocal foldmethod=indent
    autocmd FileType vue set foldmethod=syntax   " 使用语法折叠
    autocmd FileType vue set foldlevelstart=99   " 默认展开所有折叠
    autocmd FileType vue set foldnestmax=5       " 最大嵌套折叠层数
    " w
    " x
    autocmd FileType xhtml      setlocal foldmethod=expr foldexpr=HTMLFold()
    " y
    " z
augroup END
set foldlevelstart=99       " 默认不折叠, 需要放到所有类型之后

" === HTML 折叠表达式（需自定义） ===
" HTML 语法折叠函数（优化版）
function! HTMLFold()
    let line = getline(v:lnum)
    " 快速跳过不包含标签的行
    if line !~# '<'
        return '='
    endif
    " 忽略注释、DOCTYPE 和特殊标签
    if line =~# '^\s*<!--' || line =~# '<!DOCTYPE' || line =~# '<![A-Z]'
        return '='
    endif
    " 预定义自闭合标签列表（HTML5）
    let sclosing_tags = ['area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input', 'link', 'meta', 'param', 'source', 'track', 'wbr']
    " 匹配所有标签
    let tags = []
    let pos = 0
    while pos < len(line)
        let match = matchstrpos(line, '<\zs[^>]*\ze>', pos)
        if match[0] == '' | break | endif
        call add(tags, match[0])
        let pos = match[2] + 1
    endwhile
    " 处理标签序列
    let fold_change = 0
    for tag in tags
        " 跳过自闭合标签
        if tag =~# '/$' || index(sclosing_tags, split(tag)[0]) >= 0
            continue
        endif
        " 处理开始标签
        if tag !~# '^/'
            let fold_change += 1
        " 处理结束标签
        else
            let fold_change -= 1
        endif
    endfor
    " 确定折叠级别变化
    if fold_change > 0
        return 'a' . fold_change
    elseif fold_change < 0
        return 's' . (-fold_change)
    endif
    return '='
endfunction

" 自定义折叠文本
set foldtext=CustomFoldText()
function! CustomFoldText()
    " 安全获取行内容（防止越界）
    let start_line = v:foldstart <= line('$') ? getline(v:foldstart) : ''
    let end_line = v:foldend <= line('$') ? getline(v:foldend) : ''

    " 处理制表符
    let start = substitute(start_line, '\t', '    ', 'g')
    let end = substitute(end_line, '\t', '    ', 'g')
    let end_no_indent = substitute(end, '^\s*', '', '')

    " 强制计算有效行数
    let valid_foldend = min([v:foldend, line('$')])
    let count = max([valid_foldend - v:foldstart + 1, 1]) " 双重保险

    " 如果仍然异常，直接使用行号差
    if count <= 0
        let count = abs(v:foldend - v:foldstart) + 1
    endif

    " 构建显示内容
    let info = printf('[%d-%d] %d lines', v:foldstart, valid_foldend, count)
    let folded = empty(end_no_indent) ? start : start . ' ... ' . end_no_indent

    " 计算对齐
    let width = &textwidth > 0 ? &textwidth : 80
    let spacing = max([width - strwidth(folded) - strwidth(info), 1])
    let pad = repeat(' ', spacing)

    return folded . pad . info
endfunction
highlight Folded guifg=#888888

" ========================
" 命令行行为
" ========================

set wildmenu                    " 启用可视化补全菜单
" set wildmode=longest:list,full  " 优化补全模式：先补全公共前缀，再列出选项，最后完整补全
" set wildmode=longest,list,full  “ 优化补全模式：先补全公共前缀，再列出选项，最后完整补全
" set wildmode=full               " 优化补全模式：完整补全
set wildmode=longest:full,full
set wildoptions=pum,tagfile     " 使用弹出菜单显示补全项，优化标签文件处理
set wildignorecase              " 补全时忽略大小写
set wildcharm=<Tab>             " 允许在宏中使用 Tab 触发补全
" 高级补全增强
set wildchar=<Tab>             " 设置补全触发键
" set completeopt=menu,menuone,noselect
set completeopt=menu,menuone,noselect
set pumheight=10               " 补全菜单最大高度

" ========================
" 鼠标与剪贴板
" ========================

" 跨平台鼠标支持
if has('mouse')
    set mouse=a                   " 全模式鼠标支持
    if !has('nvim')
        set ttymouse=xterm2         " 确保终端鼠标支持
    endif
endif

" 剪贴板集成
" if has('clipboard')
"   if has('unnamedplus')         " 优先使用+寄存器
"     set clipboard=unnamed,unnamedplus
"   else                          " 回退到*寄存器
"     set clipboard=unnamed
"   endif
" endif

" ========================
" 其他关键配置
" ========================

set backspace=indent,eol,start  " 退格键行为
set history=100                " 命令历史记录数
set virtualedit=block           " 可视块模式允许越过行尾
set splitright                  " 垂直分割在右侧打开
set splitbelow                  " 水平分割在下方打开

" tags 生成与查询路径
set tags=./tags;,tags

" ========================
" 实用函数
" ========================

" 清除尾随空格
function! StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
    endif
endfunction
" 自动清除尾随空格，在保存文件时触发
autocmd BufWritePre * call StripTrailingWhitespace()

" ========================
" 配置验证（开发时启用）
" ========================

" if exists('g:debug_vim_config')
"   echo '=== basic.vim 加载完成 ==='
"   set verbose=1
" endif

" ========================
" 兼容性配置
" ========================

" 需要双宽度字符保证正文内容显示，但是需要单宽度字符保证图标显示正常
set ambiwidth=single
" 但允许文件内容中的 CJK 字符使用双宽度
autocmd BufEnter * if &filetype =~ 'markdown\|text' | setlocal ambiwidth=double | endif

"""" editorconfig 兼容 """"
" editorconfig 加载 依赖 editorconfig-vim 插件
augroup ForceExpandTab
    autocmd!
    autocmd FileType * nested setlocal expandtab
augroup END

" 解决vite.config.ts 卡死问题
" 针对 TypeScript 配置文件的优化
" autocmd BufRead,BufNewFile vite.config.* set filetype=typescript
" " 禁用复杂语法高亮
" autocmd FileType typescript set syntax=off
" autocmd FileType typescript set foldmethod=manual
" " 限制语法解析范围
" autocmd FileType typescript set synmaxcol=200  " 每行最多解析200列
" autocmd FileType typescript set redrawtime=2000 " 增加重绘时间
" " 禁用某些耗时的语法组
" autocmd FileType typescript syntax clear typescriptDocComment
" autocmd FileType typescript syntax clear typescriptDecorator
" ===== 文件类型特定优化 =====
autocmd FileType typescript,vue set synmaxcol=800
autocmd FileType typescript,vue set redrawtime=40000
autocmd FileType json,yaml set foldmethod=indent

" " 创建专门针对 vite.config.ts 的优化
" function! OptimizeViteConfig()
"     " 禁用所有插件功能
"     " set eventignore=all
"     set syntax=off
"     set foldmethod=manual
"     set nocursorline
"     set norelativenumber
"     set nolazyredraw
"     " 仅启用基本功能
"     syntax enable
"     set syntax=typescript
"     autocmd FileType typescript set regexpengine=1      " 使用旧版正则引擎 (更稳定)
"     " 手动重新启用必要功能
"     " autocmd BufWinLeave <buffer> set eventignore=
" endfunction
" autocmd BufReadPre vite.config.* call OptimizeViteConfig()

" 突破限制 ===========================================================================
" ===== 核心性能优化 =====
set redrawtime=30000       " 增加重绘超时到 30 秒 (充分利用高性能硬件)
set maxmempattern=8000000  " 模式匹配内存提升到 8GB (默认 1MB)
set maxmem=4000000         " 每个缓冲区最大内存提升到 4GB (默认取决于系统)
set maxmemtot=32000000     " Vim 总内存限制提升到 32GB (匹配您的物理内存)
set maxfuncdepth=400       " 最大函数嵌套深度 (默认 100)
set maxmapdepth=200        " 最大映射深度 (默认 1000)
set maxcombine=8           " 最大组合字符 (默认 6)
set mmp=1000000            " 模式匹配内存限制 (默认 100000)

" ===== CPU 优化 =====
set regexpengine=2         " 使用新版正则引擎 (i9 能更好处理)
set lazyredraw             " 脚本执行时不重绘屏幕
set ttyfast                " 快速终端连接
set notimeout              " 无命令超时
set nottimeout             " 无键映射超时
set updatetime=50          " 降低更新时间 (默认 4000ms)

" ===== 渲染优化 =====
" set nocursorline           " 禁用光标行高亮
" set nocursorcolumn         " 禁用光标列高亮
" set norelativenumber       " 禁用相对行号
" set noshowcmd              " 禁用命令显示
" set noshowmode             " 禁用模式显示
" set foldmethod=manual      " 手动折叠 (语法折叠消耗大)
set synmaxcol=500          " 每行只高亮前500列
syntax sync minlines=500   " 增加语法同步行数

" ===== GPU 加速 (需要 GUI 版本) =====
if has('gui_running')
    set renderoptions=type:directx,geom:1,renmode:5 " Windows 专用 GPU 加速
    set linespace=0           " 优化文本渲染
    set guifont=Consolas:h12  " 使用等宽字体提高渲染效率
endif

" ===== 大型文件处理 =====
function! LargeFileMode()
    if getfsize(expand("%")) > 10485760 " 10MB
        set eventignore=all
        set syntax=off
        set foldmethod=manual
        set nolist
        set number
        echo "Large file mode activated"
    endif
endfunction
autocmd BufReadPre * call LargeFileMode()

" ===== 插件优化 =====
let g:polyglot_disabled = ['typescript', 'vue'] " 禁用部分语法插件
let g:loaded_matchparen = 1                     " 禁用括号匹配
let g:loaded_netrwPlugin = 1                    " 禁用内置文件浏览器

" ===== 内存监控命令 =====
function! MemoryUsage()
    let total_mem = system('wmic computersystem get TotalPhysicalMemory')/1024/1024
    let used_mem = system('wmic process where ProcessId="'.getpid().'" get WorkingSetSize')/1024/1024
    echo "Vim memory: ".used_mem."MB / System memory: ".total_mem."MB"
endfunction

command! MemInfo call MemoryUsage()

" ===== 性能分析工具 =====
command! ProfileStart :profile start vim-profile.log | profile func * | profile file *
command! ProfileStop :profile pause | noautocmd qall!
