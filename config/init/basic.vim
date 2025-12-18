"==============================================================
" config/init/basic.vim
" 基础配置：跨平台基础设置，无插件依赖
"==============================================================

if exists('g:loaded_basic_config')
  finish
endif
let g:loaded_basic_config = 1

"==============================================================
" 1. 编码设置
"==============================================================
set encoding=utf-8 " 设置编码为utf-8，防止coc.nvim报错
set fileencodings=utf-8,ucs-bom,gbk,latin1

" 模糊宽度字符（如 emoji、图标）显示各有各的bug……酌情修改
" 单宽度：一个字符占一个宽度,解决状态栏和侧边栏图标显示问题
" 双宽度：一个字符占两个宽度,解决ansi代码对齐错位问题
set ambiwidth=single                
" set ambiwidth=double

"==============================================================
" 1.1. 换行符设置（统一使用 LF）
"==============================================================
" 新文件默认使用 Unix 格式（LF）
set fileformat=unix
set fileformats=unix,dos  " 保存文件自动保存为unix,dos格式

"==============================================================
" 2. 编辑体验（不依赖任何插件）
"==============================================================
set number                         " 显示绝对行号
set relativenumber                 " 同时显示相对行号，便于跳行
set numberwidth=4                  " 行号列宽度（为符号预留空间）
set signcolumn=yes                 " 始终显示符号列（为诊断和 Git 符号预留空间）
set hidden                         " 允许切换 buffer 时保留未保存内容
set expandtab                      " 将 Tab 转换为空格
set tabstop=4                      " Tab 视觉宽度（只影响显示）
set shiftwidth=4                   " 自动缩进宽度（默认 4 个空格）
" 注意：文件类型特定的缩进配置在 config/init/indent.vim 中

set smartcase                      " 搜索包含大写时自动切换到大小写敏感
set ignorecase                     " 默认忽略大小写，配合 smartcase 更智能
set hlsearch                       " 高亮显示所有搜索结果
set incsearch                      " 输入搜索模式时实时高亮匹配结果
set mouse=a                        " 全模式启用鼠标（终端支持时生效）
set scrolloff=5                    " 上下翻页和滚动时保留 5 行缓冲区

"==============================================================
" 2.2. 缩进可视化（纯 Vim list 模式）
"==============================================================
" 使用 Vim 内置的 list 功能显示不可见字符
" 设置 listchars 显示多种不可见字符：
"   tab:      - 制表符显示为空格（由于已设置 expandtab，tab 会被转换为空格）
"   trail:-   - 尾随空格显示为 -
"   eol:⏎     - 行尾显示为 ⏎（回车键符号，推荐）
"               其他可选：↵ (U+21B5) 或 ↲ (U+21B2) 或 $ (传统)
"   nbsp:␣    - 非断行空格显示为 ␣
"   extends:> - 行尾延伸字符显示为 >
"   precedes:< - 行首前置字符显示为 <
" 注意：multispace（缩进符号）配置在 config/init/indent.vim 中
" tab 显示为 | 加空格
set listchars=tab:\|\ ,trail:-,eol:↵,nbsp:␣,extends:>,precedes:<
" 默认启用 list 模式（显示不可见字符）
set list

" 设置 list 模式显示字符的高亮颜色（根据深色/浅色主题自动调整）
" NonText: 控制行尾字符（eol）和延伸字符（extends/precedes）的颜色
" SpecialKey: 控制制表符、尾随空格、前导空格等字符的颜色
" 根据背景色自动设置合适的颜色
function! s:set_list_colors() abort
  if &background ==# 'dark'
    " 深色主题：使用浅灰色，在深色背景上可见
    hi NonText    ctermfg=250 guifg=#666666  " 浅灰色（终端：250，GUI：#aaaaaa）
    hi SpecialKey ctermfg=250 guifg=#666666  " 浅灰色（终端：250，GUI：#aaaaaa）
  else
    " 浅色主题：使用灰色，在浅色背景上可见
    hi NonText    ctermfg=240 guifg=#dddddd  " 灰色（终端：240深灰，GUI：#BCBCBC浅灰）
    hi SpecialKey ctermfg=240 guifg=#dddddd  " 灰色（终端：240深灰，GUI：#BCBCBC浅灰）
  endif
endfunction

" 初始设置（根据当前背景色）
call s:set_list_colors()

" 在主题切换和背景色变化时重新设置颜色
augroup ListModeColors
  autocmd!
  autocmd ColorScheme * call s:set_list_colors()
  autocmd OptionSet background call s:set_list_colors()
augroup END
" 注意：如果觉得显示太多字符太乱，可以只保留 tab, trail, eol

" 文件自动重新加载配置
set autoread                       " 当文件在外部被修改时自动重新读取（不显示 W11 警告）
set updatetime=2000                " 更新间隔（毫秒），用于检查文件变更和触发 CursorHold 事件
"==============================================================
" 2.1. 文本排版
"==============================================================
set textwidth=79                   " 超过 79 列自动换行
set formatoptions+=t               " 输入时根据 textwidth 自动换行
set colorcolumn=80                 " 可视化提示 79 列限制（第 80 列高亮）

"==============================================================
" 3. 自动备份配置（集中管理）
"==============================================================
" 备份文件目录：~/.vim/.backup/
set backup
let s:backup_dir = expand('~/.vim/.backup')
if !isdirectory(s:backup_dir)
  call mkdir(s:backup_dir, 'p', 0700)
endif
execute 'set backupdir=' . fnameescape(s:backup_dir . '//')
set backupext=.bak

" 交换文件目录：~/.vim/.swap/
set swapfile
let s:swap_dir = expand('~/.vim/.swap')
if !isdirectory(s:swap_dir)
  call mkdir(s:swap_dir, 'p', 0700)
endif
execute 'set directory=' . fnameescape(s:swap_dir . '//')

" 撤销历史目录：~/.vim/.undo/
set undofile
let s:undo_dir = expand('~/.vim/.undo')
if !isdirectory(s:undo_dir)
  call mkdir(s:undo_dir, 'p', 0700)
endif
execute 'set undodir=' . fnameescape(s:undo_dir . '//')

" 视图文件目录：~/.vim/.view/
let s:view_dir = expand('~/.vim/.view')
if !isdirectory(s:view_dir)
  call mkdir(s:view_dir, 'p', 0700)
endif
execute 'set viewdir=' . fnameescape(s:view_dir)

"==============================================================
" 4. 光标位置恢复（打开文件时回到上次编辑位置）
"==============================================================
" 启用 viminfo 来保存编辑历史（包括光标位置）
" viminfo 文件位置：~/.vim/.viminfo
let s:viminfo_file = expand('~/.vim/.viminfo')
" 确保目录存在
let s:viminfo_dir = fnamemodify(s:viminfo_file, ':h')
if !isdirectory(s:viminfo_dir)
  call mkdir(s:viminfo_dir, 'p', 0700)
endif
" 设置 viminfo：'100（100个文件标记）,>50（50行删除/复制历史）,s10（10个搜索历史）,h（禁用高亮）,n路径（viminfo文件位置）
" 使用 let 设置 viminfo 选项，路径直接拼接
let &viminfo = "'100,<50,s10,h,n" . s:viminfo_file

" 自动恢复到上次编辑位置
augroup RestoreCursorPosition
  autocmd!
  " 打开文件时，如果存在上次编辑位置，自动跳转
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   execute "normal! g`\"" |
        \ endif
augroup END

"==============================================================
" 5. 文件自动重新加载配置
"==============================================================
" 当文件在外部被修改时，自动重新加载文件内容
" 避免显示 W11 警告："编辑开始后，文件已变动"
" 
" 策略：
" 1. 如果文件在外部被修改且当前 buffer 没有未保存修改，自动重新加载
" 2. 如果文件在外部被修改但当前 buffer 有未保存修改，不自动重新加载（避免冲突）
" 3. 定期检查文件变更，确保及时更新

augroup AutoReload
  autocmd!

  " 自定义文件变更处理，完全避免 W11 警告
  " 当文件在外部被修改时，如果当前 buffer 没有未保存修改，自动重新加载
  " 如果当前 buffer 有未保存修改，不自动重新加载（避免冲突）
  " 注意：FileChangedShell 事件在文件变更时触发，我们可以通过执行 edit 来自动重新加载
  function! s:HandleFileChanged() abort
    if expand('<afile>') ==# '' || &buftype !=# ''
      return
    endif
    if !&modified
      " 没有未保存修改，自动重新加载（不显示警告）
      " 使用 :edit! 命令强制重新加载文件（忽略警告）
      silent! edit!
      echohl WarningMsg
      echo "文件已自动重新加载: " . expand('<afile>:t')
      echohl None
    else
      " 有未保存修改，显示警告但不自动重新加载
      echohl WarningMsg
      echo "警告: 文件 " . expand('<afile>:t') . " 在外部被修改，但当前有未保存的修改"
      echo "请使用 :checktime 手动重新加载，或先保存当前修改"
      echohl None
    endif
  endfunction
  autocmd FileChangedShell * call s:HandleFileChanged()

  " 当窗口获得焦点时，检查并重新加载已更改的文件
  " 适用于：切换窗口、切换标签页、从其他应用返回 Vim
  autocmd FocusGained,BufEnter * 
        \ if mode() !=# 'c' && expand('<afile>') !=# '' && &buftype ==# '' | 
        \   silent! checktime | 
        \ endif

  " 当离开插入模式时，检查文件是否已更改
  " 如果文件已更改且当前 buffer 没有未保存修改，自动重新加载
  autocmd InsertLeave * 
        \ if expand('<afile>') !=# '' && &buftype ==# '' && !&modified | 
        \   silent! checktime | 
        \ endif

  " 定期检查文件变更（在光标静止时触发，由 updatetime 控制间隔）
  " 使用 CursorHold 事件，默认每 2 秒检查一次（updatetime=2000）
  autocmd CursorHold * 
        \ if expand('<afile>') !=# '' && &buftype ==# '' && !&modified | 
        \   silent! checktime | 
        \ endif

  " 当文件在外部被删除时，标记为已删除但保留 buffer
  " 使用 FileChangedRO 事件处理文件变为只读的情况
  autocmd FileChangedRO *
        \ if expand('<afile>') !=# '' && &buftype ==# '' |
        \   echohl WarningMsg |
        \   echo "警告: 文件 " . expand('<afile>:t') . " 在外部被删除或变为只读" |
        \   echohl None |
        \ endif

augroup END
