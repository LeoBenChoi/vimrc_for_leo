" ============================================================================
" NERDTree 文件树插件配置
" 文件位置: ~/.vim/after/plugin/nerdtree.vim
" 说明: 此文件会在所有插件加载后自动执行，用于配置 NERDTree 插件
" ============================================================================

" ============================================================================
" 1. 核心行为设置
" ============================================================================

" 显示行号（方便定位文件）
let NERDTreeShowLineNumbers=1

" 显示隐藏文件（包括 .git、.env 等）
let NERDTreeShowHidden=1

" 自动聚焦到当前文件（打开文件树时自动定位到当前文件）
let NERDTreeAutoCenter=1

" 忽略某些文件类型（减少干扰）
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '__pycache__', '\.swp$', '\.swo$', '\.DS_Store']

" ============================================================================
" 2. 界面美化设置
" ============================================================================

" 使用极简箭头替代默认的 + 号（需要 Nerd Font 支持）
let NERDTreeDirArrowExpandable = '▸'
let NERDTreeDirArrowCollapsible = '▾'

" 最小 UI（隐藏顶部的帮助提示）
let NERDTreeMinimalUI=1

" 显示书签（如果配置了书签）
let NERDTreeShowBookmarks=1

" ============================================================================
" 3. Git 集成
" ============================================================================

" 配合 vim-gitgutter 显示文件变动状态（需要安装 nerdtree-git-plugin 或使用内置支持）
" 如果安装了 nerdtree-git-plugin，取消下面的注释：
" let g:NERDTreeGitStatusUseNerdFonts = 1
" let g:NERDTreeGitStatusIndicatorMapCustom = {
"     \ 'Modified'  : '✹',
"     \ 'Staged'    : '✚',
"     \ 'Untracked' : '✭',
"     \ 'Renamed'   : '➜',
"     \ 'Unmerged'  : '═',
"     \ 'Deleted'   : '✖',
"     \ 'Dirty'     : '✗',
"     \ 'Clean'     : '✔︎',
"     \ 'Ignored'   : '☒',
"     \ 'Unknown'   : '?'
"     \ }

" ============================================================================
" 4. 键位映射
" ============================================================================

" F2 键快速开关文件树（经典键位，符合大多数 IDE 习惯）
nnoremap <silent> <F2> :NERDTreeToggle<CR>
inoremap <silent> <F2> <ESC>:NERDTreeToggle<CR>

" Leader + n 打开文件树（备用快捷键）
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>

" Leader + f 在当前文件所在目录打开文件树
nnoremap <silent> <Leader>f :NERDTreeFind<CR>

" ============================================================================
" 5. 自动行为
" ============================================================================

" 当 NERDTree 是最后一个窗口时，自动退出 Vim
" 避免关闭文件后只剩下空白的文件树窗口
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" 打开文件后自动关闭文件树（可选，如果觉得干扰可以取消注释）
" autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" 注意：由于你已经配置了 Startify 启动页，不建议启用下面的自动打开功能
" 否则启动页和文件树会同时出现，造成冲突
" 如果需要，可以取消下面的注释：
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" ============================================================================
" 6. 窗口大小设置
" ============================================================================

" 设置文件树窗口宽度（字符数）
let NERDTreeWinSize=35

" 文件树窗口位置（'left' 或 'right'）
let NERDTreeWinPos='left'
