" 设置不兼容vi
if &compatible
    set nocompatible
endif

" ===================================================================
" 基础配置
" ===================================================================
" 文件编码设置（跨平台兼容）
set encoding=utf-8              " 内部编码
set fileencoding=utf-8          " 新文件默认编码
set fileencodings=utf-8,gb2312,gbk,cp936,latin1 " 自动检测编码顺序

" 强制统一换行格式
set fileformat=unix
set fileformats=unix,dos

" 文件处理行为
set autoread                    " 文件被外部修改时自动重新加载
set hidden                      " 允许缓冲区隐藏而不保存
set confirm                     " 未保存时显示确认对话框

" 基础杂项
set lazyredraw                  " 执行宏/寄存器时不重绘
set ttyfast                     " 快速终端连接, 优化终端重绘
set timeoutlen=300              " 映射等待时间(ms)
set updatetime=3000              " 写入交换文件间隔(ms)(影响插件)
"set synmaxcol=200               " 只高亮行前100列
set re=1                        " 使用旧版正则引擎（对复杂语法更快）
" set notimeout                   " 禁用命令超时
set nottimeout                  " 禁用键盘映射超时
set backspace=indent,eol,start  " 退格键行为
set history=100                " 命令历史记录数
set virtualedit=block           " 可视块模式允许越过行尾
set splitright                  " 垂直分割在右侧打开
set splitbelow                  " 水平分割在下方打开
set ambiwidth=double            " 使用 double 格式的字符，双宽度字符

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
" autocmd! BufReadPost *
"             \ if line("'\"") > 1 && line("'\"") <= line("$") |
"             \   exe "normal! g'\"" |
"             \ endif
function! LastPositionJump()
    if &filetype =~# 'commit'
        return
    endif

    let line = line("'\"")
    if line >= 1 && line <= line("$")
        execute "normal! '\""
    else
        execute "normal! $"
    endif
endfunction

autocmd BufReadPost * call LastPositionJump()

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

" 交给 editorconfig
set tabstop=4       " tab 宽度
set shiftwidth=4    " 字符前 tab 空格
set softtabstop=4   " 字符后 tab 空格
set expandtab       " 将字符转换成空格

" 显示不可见字符
set list
" let &listchars='tab:▸ '+',trail:·'eol:↴,space:.
set listchars=tab:▸\ ,multispace:▸,extends:❯,precedes:❮,eol:↲

" 智能缩进显示函数
function! SmartIndentDisplay()
    " 获取当前缩进宽度 (优先级: shiftwidth > tabstop)
    let width = &shiftwidth > 0 ? &shiftwidth : &tabstop
    if width == 2
        " let symbol = '»\ '
        let symbol = '▸\ '
    elseif width == 4
        let symbol = '▸\ \ \ '
    elseif width == 8
        let symbol = '▸\ \ \ \ \ \ \ '
    else
        let symbol = '→' . repeat('\ ', width - 1)
    endif

    if has('patch-9.0.0')
        execute 'set listchars+=multispace:' . symbol
    endif

    " 调整高亮组（建议不动）
    " highlight SpecialKey ctermfg=7 guifg=#888888
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
set shortmess+=I                " 关闭启动信息
set showfulltag                 " 完整显示标签内容
set signcolumn=yes              " 始终显示符号列
set numberwidth=4               " 设置行号列宽度（默认4字符）

" 启用真彩色支持（终端需支持）
if has('termguicolors')
    set termguicolors
endif

" 全屏打开
" guifont 设置（仅 GUI 环境）
if has('gui_running') && !has('unix')
    autocmd GUIEnter * simalt ~x
endif

" 设置文本宽度（根据团队规范调整，常用值如下）
" set textwidth=80   " 经典Unix风格（Linux内核等使用）
" set textwidth=100 " 现代项目常用
set textwidth=120 " 大型项目可能使用

" 自动折行设置
set wrap                " 启用视觉折行
set textwidth=0         " 禁用自动换行
set wrapmargin=0        " 禁用自动换行边距
set linebreak           " 只在单词边界折行
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
    " autocmd BufRead,BufNewFile *.vue set filetype=vue
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
    " 获取折叠的起始和结束行号
    " v:foldstart 和 v:foldend 是 Vim 提供的特殊变量，表示当前折叠的范围
    let l:start_line_num = v:foldstart
    let l:end_line_num = v:foldend

    " 计算折叠包含的行数
    " 即使是单行折叠 (start_line_num == end_line_num)，结果也是 1
    " 理论上，Vim 不会创建 start_line_num > end_line_num 的折叠
    let l:line_count = l:end_line_num - l:start_line_num + 1

    " 获取折叠起始行和结束行的内容
    " getline() 函数在行号超出缓冲区范围时会返回空字符串，这里不需要额外检查
    " 因为 v:foldstart 和 v:foldend 总是有效的行号
    let l:start_line_content = getline(l:start_line_num)
    let l:end_line_content = getline(l:end_line_num)

    " 处理行内容：将制表符替换为空格，并移除结束行的前导空白（为了美观）
    let l:processed_start = substitute(l:start_line_content, '\t', '    ', 'g')
    let l:processed_end = substitute(l:end_line_content, '\t', '    ', 'g')
    let l:processed_end_no_indent = substitute(l:processed_end, '^\s*', '', '')

    " 构建折叠内容的显示部分
    " 如果结束行在去除缩进后为空，则只显示起始行内容
    let l:folded_display_text = empty(l:processed_end_no_indent) ? l:processed_start : l:processed_start . ' ... ' . l:processed_end_no_indent

    " 限制折叠文本的显示长度，防止过长导致信息部分被挤出屏幕
    " 假设信息部分至少需要 20 个字符的宽度，加上最小间隔 3 个字符
    let l:max_folded_width = &columns - 20 - 3
    if strwidth(l:folded_display_text) > l:max_folded_width && l:max_folded_width > 3
        " 如果文本过长，截断并添加省略号
        let l:folded_display_text = strcharpart(l:folded_display_text, 0, l:max_folded_width - 3) . '...'
    elseif l:max_folded_width <= 3 " 如果可用空间太小，直接清空折叠文本，只显示信息
        let l:folded_display_text = ''
    endif

    " 构建信息部分的显示内容
    let l:info_display_text = printf('[%d-%d] %d lines', l:start_line_num, l:end_line_num, l:line_count)

    " 计算填充空格的数量，确保信息部分右对齐
    " &columns 是当前终端的列数
    let l:current_display_width = strwidth(l:folded_display_text) + strwidth(l:info_display_text)
    let l:spacing = max([80 - l:current_display_width, 1]) " 至少一个空格

    " 返回最终的折叠文本
    return l:folded_display_text . repeat(' ', l:spacing) . l:info_display_text
endfunction

" 设置折叠文本的颜色（如果需要）
" highlight Folded guifg=#888888
" 如果你使用的是终端 Vim (不是 gVim/MacVim)，可能需要使用 ctermfg
" highlight Folded ctermfg=888888 (或一个终端颜色代码，如 240)
" 建议在你的 .vimrc 中根据你的 Vim 版本和终端类型选择合适的 highlight 命令

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

" ========================
" 功能函数
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

" ===================================================================
" 性能优化
" 突破限制
" ===================================================================

" ===== 核心性能优化 =====
set redrawtime=30000       " 增加重绘超时到 30 秒 (充分利用高性能硬件)
set maxmempattern=8000000  " 模式匹配内存提升到 8GB (默认 1MB)
set maxmem=4000000         " 每个缓冲区最大内存提升到 4GB (默认取决于系统)
set maxmemtot=16000000     " Vim 总内存限制提升到 16GB (匹配您的物理内存)
set maxfuncdepth=400       " 最大函数嵌套深度 (默认 100)
set maxmapdepth=200        " 最大映射深度 (默认 1000)
set maxcombine=8           " 最大组合字符 (默认 6)

" ===== CPU 优化 =====
set regexpengine=2         " 使用新版正则引擎 (i9 能更好处理)
set lazyredraw             " 脚本执行时不重绘屏幕
set ttyfast                " 快速终端连接
" set notimeout              " 无命令超时
set nottimeout             " 无键映射超时
set updatetime=50          " 降低更新时间 (默认 4000ms)

" ===== 渲染优化 =====
" set nocursorline           " 禁用光标行高亮
" set nocursorcolumn         " 禁用光标列高亮
" set norelativenumber       " 禁用相对行号
" set noshowcmd              " 禁用命令显示
" set noshowmode             " 禁用模式显示
" set foldmethod=manual      " 手动折叠 (语法折叠消耗大)
set synmaxcol=800          " 每行只高亮前500列
" 增加语法同步行数
syntax sync minlines=300

" ===== GPU 加速 (需要 GUI 版本) =====
if has('gui_running')
    set renderoptions=type:directx,geom:1,renmode:5 " Windows 专用 GPU 加速
    set linespace=0           " 优化文本渲染
    " set guifont=Consolas:h12  " 使用等宽字体提高渲染效率
endif

" ===================================================================

" ===================================================================
finish
" ===================================================================
