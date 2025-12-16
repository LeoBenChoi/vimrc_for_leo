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
" 2. NERDTree 其他配置
"==============================================================
" 注意：Git 状态显示功能已移除（nerdtree-git-plugin 已删除）
if exists(':NERDTree')
  " 其他 NERDTree 配置可以在此添加
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
  
  "==============================================================
  " Vue 图标自定义配置（修复乱码问题）
  "==============================================================
  " 默认 Vue 图标 '﵂' 在 Windows 终端下可能显示为乱码
  " 使用更兼容的图标替代
  if !exists('g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols')
    let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
  endif
  " 设置 Vue 图标（选择一个不会乱码的图标）
  " 当前使用：'⚡'（闪电符号，Vue 官方 logo 类似）
  " 如果还是乱码，可以尝试以下选项：
  "   'V' - 大写字母 V（最兼容，不会乱码）
  "   '◆' - 实心菱形 (U+25C6)
  "   '▽' - 倒三角 (U+25BD)
  "   '◈' - 空心菱形 (U+25C8)
  "   '●' - 实心圆 (U+25CF)
  "   '★' - 实心星 (U+2605)
  "   '☆' - 空心星 (U+2606)
  "   '♦' - 菱形 (U+2666)
  "   '▶' - 右三角 (U+25B6)
  " 图标资源网站：
  "   - https://www.nerdfonts.com/cheat-sheet (Nerd Fonts 图标表)
  "   - https://unicode-table.com/ (Unicode 字符表)
  "   - https://emojipedia.org/ (Emoji 图标)
  " let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vue'] = '⚡'

endif
