" =======================================================
" [NERDTree] 文件树插件配置
" =======================================================

" 显示隐藏文件（包括 .git、.env 等）
let NERDTreeShowHidden=1

" 自动聚焦到当前文件（打开文件树时自动定位到当前文件）
let NERDTreeAutoCenter=1

" 忽略某些文件类型（减少干扰）
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '__pycache__', '\.swp$', '\.swo$', '\.DS_Store']

" 使用极简箭头替代默认的 + 号（需要 Nerd Font 支持）
let NERDTreeDirArrowExpandable = '▸'
let NERDTreeDirArrowCollapsible = '▾'

" 最小 UI（隐藏顶部的帮助提示）
let NERDTreeMinimalUI=1

" 显示书签（如果配置了书签）
let NERDTreeShowBookmarks=1

" 设置文件树窗口宽度（字符数）
let NERDTreeWinSize=35

" 文件树窗口位置（'left' 或 'right'）
let NERDTreeWinPos='left'

" 快捷键映射
" F2 键快速开关文件树（经典键位，符合大多数 IDE 习惯）
nnoremap <silent> <F2> :NERDTreeToggle<CR>
inoremap <silent> <F2> <ESC>:NERDTreeToggle<CR>

" Leader + n 打开文件树（备用快捷键）
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>

" Leader + f 在当前文件所在目录打开文件树
nnoremap <silent> <Leader>f :NERDTreeFind<CR>

" 当 NERDTree 是最后一个窗口时的处理已移至 00-init.vim
" 统一处理所有辅助窗口（Quickfix、NERDTree、Vista 等）
