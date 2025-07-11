" ==================================================
" BASIC.VIM - 核心编辑器配置
" 功能：基础设置/性能优化/通用行为
" 加载顺序：应在其他配置前最先加载
" ==================================================

" 设置不兼容vi
if &compatible
  set nocompatible
endif

" 确保只加载一次
if exists('g:loaded_basic_config')
  finish
endif
let g:loaded_basic_config = 1

" ========================
" 基础行为配置
" ========================

" 文件编码设置（跨平台兼容）
set encoding=utf-8              " 内部编码
set fileencoding=utf-8          " 新文件默认编码
set fileencodings=utf-8,gbk,cp936,latin1 " 自动检测编码顺序

" 文件处理行为
set autoread                    " 文件被外部修改时自动重新加载
set hidden                      " 允许缓冲区隐藏而不保存
set confirm                     " 未保存时显示确认对话框
set modeline                    " 允许文件内配置（安全性考虑后可禁用）
set modelines=5                 " 检查前5行寻找模式行

" ========================
" 性能优化
" ========================

set lazyredraw                  " 执行宏/寄存器时不重绘
set ttyfast                     " 快速终端连接
set timeoutlen=500              " 映射等待时间(ms)
set updatetime=300              " 写入交换文件间隔(ms)(影响插件)
set synmaxcol=500               " 只高亮行前500列
set re=1                        " 使用旧版正则引擎（对复杂语法更快）


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
set gdefault                    " 替换时默认全局替换

" ========================
" 缩进与制表符
" ========================

set autoindent                  " 自动继承上一行缩进
set smartindent                 " 智能缩进（C风格）
set expandtab                   " 将制表符转为空格
set tabstop=4                   " 制表符显示宽度
set shiftwidth=4                " 自动缩进步长
set softtabstop=4               " 退格键删除缩进
set shiftround                  " 缩进对齐到shiftwidth倍数

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

" guifont 设置（仅 GUI 环境）
    if has('gui_running')
        autocmd GUIEnter * simalt ~x
    endif

" 设置文本宽度（根据团队规范调整，常用值如下）
set textwidth=80   " 经典Unix风格（Linux内核等使用）
" set textwidth=100 " 现代项目常用
" set textwidth=120 " 大型项目可能使用

" 自动折行设置
set wrap           " 启用视觉折行
set linebreak      " 只在单词边界折行
set breakindent    " 折行后保持缩进

" 高亮指定列（textwidth+1列）
set colorcolumn=+1
highlight ColorColumn ctermbg=lightgrey guibg=#eeeeee

" 或者明确指定多个列（示例：80,100,120列）
" let &colorcolumn="80,".join(range(100,120),",")

" 文件类型特定行宽设置
augroup filetype_settings
  autocmd!
  " Python遵循PEP8标准
  autocmd FileType python setlocal textwidth=88
  " Go语言使用制表符
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
augroup END

" 当前行高亮
set cursorline
highlight CursorLine cterm=NONE ctermbg=darkgrey guibg=#eeeeee

" 当前列高亮（需要Vim 7.4.792+或Neovim）
set cursorcolumn
highlight CursorColumn cterm=NONE ctermbg=darkgrey guibg=#eeeeee

" 只在普通模式下高亮当前行（避免插入模式干扰）
augroup cursor_highlight
  autocmd!
  autocmd InsertEnter * set nocursorline nocursorcolumn
  autocmd InsertLeave * set cursorline cursorcolumn
augroup END

" 边界线增强显示
let &showbreak='⤷ '
set list           " 显示不可见字符
set listchars=tab:▸\ ,trail:·,nbsp:␣,extends:❯,precedes:❮

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


" ========================
" 命令行行为
" ========================

set wildmenu                    " 命令行补全菜单
set wildmode=longest:full,full  " 补全模式
set wildignorecase              " 补全忽略大小写
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__ " 补全忽略文件
set shortmess+=c                " 减少补全菜单消息
set showcmd                     " 显示部分命令
set cmdheight=1                 " 命令行高度

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
if has('clipboard')
  if has('unnamedplus')         " 优先使用+寄存器
    set clipboard=unnamed,unnamedplus
  else                          " 回退到*寄存器
    set clipboard=unnamed
  endif
endif

" ========================
" 其他关键配置
" ========================

set backspace=indent,eol,start  " 退格键行为
set completeopt=menu,menuone,noselect " 补全选项
set diffopt+=vertical           " 垂直diff分割
set history=1000                " 命令历史记录数
set virtualedit=block           " 可视块模式允许越过行尾
set nojoinspaces                " J命令不插入双空格
set splitright                  " 垂直分割在右侧打开
set splitbelow                  " 水平分割在下方打开

" ========================
" 实用函数
" ========================

" 快速切换相对行号
function! ToggleRelativeNumber()
  if &relativenumber
    set norelativenumber
  else
    set relativenumber
  endif
endfunction
nnoremap <silent> <leader>rn :call ToggleRelativeNumber()<CR>

" 清除尾随空格
function! StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
  endif
endfunction

" ========================
" 配置验证（开发时启用）
" ========================

" if exists('g:debug_vim_config')
"   echo '=== basic.vim 加载完成 ==='
"   set verbose=1
" endif