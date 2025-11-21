"==============================================================
" config/ui/sidebar.vim
" 侧边栏配置：文件浏览器和代码大纲
"==============================================================

if exists('g:loaded_sidebar_config')
  finish
endif
let g:loaded_sidebar_config = 1

"==============================================================
" 1. NERDTree 配置（经典文件浏览器）
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
  " 忽略规则说明：
  "   \.pyc$, \.pyo$, \.pyd$     - Python 编译文件
  "   __pycache__, \.git$, \.svn$ - 版本控制目录
  "   \.DS_Store$, node_modules$ - 系统文件和依赖
  "   \.class$, \.jar$           - Java 编译文件

  " 自动打开/关闭行为
  " 启动时自动打开 NERDTree（可选，默认关闭）
  " autocmd VimEnter * NERDTree
  " 最后一个窗口是 NERDTree 时自动关闭
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
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

