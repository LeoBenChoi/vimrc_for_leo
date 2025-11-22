"==============================================================
" config/ui/sidebar.vim
" 侧边栏配置：NERDTree 文件浏览器
"==============================================================

if exists('g:loaded_sidebar_config')
  finish
endif
let g:loaded_sidebar_config = 1

"==============================================================
" 1. NERDTree 配置
"==============================================================
if exists(':NERDTree')
  " 基础设置
  let g:NERDTreeShowHidden = 1                    " 显示隐藏文件
  let g:NERDTreeMinimalUI = 0                     " 显示完整 UI
  let g:NERDTreeAutoDeleteBuffer = 1              " 删除文件时自动删除 buffer
  let g:NERDTreeQuitOnOpen = 0                    " 打开文件后不关闭 NERDTree
  let g:NERDTreeShowLineNumbers = 0               " 不显示行号（节省空间）
  let g:NERDTreeWinSize = 35                      " 侧边栏宽度（字符数）
  let g:NERDTreeRespectWildIgnore = 1             " 尊重 wildignore 设置
  let g:NERDTreeIgnore = [
        \ '\.pyc$',
        \ '\.pyo$',
        \ '\.pyd$',
        \ '__pycache__',
        \ '\.git$',
        \ '\.svn$',
        \ '\.DS_Store$',
        \ 'node_modules$',
        \ '\.class$',
        \ '\.jar$',
        \ ]
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif

"==============================================================
" 2. Git 状态符号配置
"==============================================================
if exists(':NERDTree')
  " 使用 Unicode 字符（需要字体支持）
  " 如果显示有问题，可以切换到下面的 ASCII 版本
  " Modified: 已修改, Staged: 已暂存, Untracked: 未跟踪
  " Renamed: 已重命名, Unmerged: 未合并, Deleted: 已删除
  " Dirty: 脏目录, Ignored: 已忽略, Clean: 干净, Unknown: 未知状态
  let g:NERDTreeGitStatusIndicatorMapCustom = {
        \ 'Modified'  : '✹',
        \ 'Staged'    : '✚',
        \ 'Untracked' : '✭',
        \ 'Renamed'   : '➜',
        \ 'Unmerged'  : '═',
        \ 'Deleted'   : '✖',
        \ 'Dirty'     : '✗',
        \ 'Ignored'   : '☒',
        \ 'Clean'     : '✔',
        \ 'Unknown'   : '?'
        \ }
  
  " 备选方案：如果 Unicode 字符显示有问题，使用下面的 ASCII 版本
  " 注释掉上面的配置，取消下面的注释
  " let g:NERDTreeGitStatusIndicatorMapCustom = {
  "       \ 'Modified'  : '*',
  "       \ 'Staged'    : '+',
  "       \ 'Untracked' : '?',
  "       \ 'Renamed'   : 'R',
  "       \ 'Unmerged'  : '=',
  "       \ 'Deleted'   : 'D',
  "       \ 'Dirty'     : 'X',
  "       \ 'Ignored'   : '!',
  "       \ 'Clean'     : 'C',
  "       \ 'Unknown'   : '?'
  "       \ }
endif

"==============================================================
" 2. 文件图标配置（vim-devicons）
"==============================================================
if exists(':NERDTree') && exists('g:loaded_webdevicons')
  " 在 NERDTree 中启用图标
  let g:webdevicons_enable_nerdtree = 1
  let g:webdevicons_conceal_nerdtree_brackets = 1
  " 图标间距
  let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
  let g:WebDevIconsNerdTreeBeforeGlyphPadding = ' '
endif
