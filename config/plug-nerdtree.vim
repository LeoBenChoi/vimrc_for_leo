" ========================
" nerdtree 配置
" 功能：侧边栏
" ========================

" 确保只加载一次
if exists('g:plug_load_nerdtree')
    finish
endif
let g:plug_load_nerdtree = 1

" ========================
" 核心配置
" ========================

" 基本设置
let g:NERDTreeShowHidden = 1          " 显示隐藏文件
let g:NERDTreeMinimalUI = 1           " 隐藏帮助提示
" let g:NERDTreeIgnore = ['\.DS_Store$', '\.git$']  " 忽略文件
" let g:NERDTreeIgnore = []  " 不忽略任何文件
" let g:NERDTreeIgnore = ['\.DS_Store$', '\.swp$']  " 只忽略临时文件，不忽略 .git
let g:NERDTreeStatusline = ''         " 禁用状态栏覆盖
let g:NERDTreeAutoDeleteBuffer = 1    " 删除文件后自动删除缓冲区
let g:NERDTreeCaseSensitiveSort = 1   " 大小写敏感排序

" 窗口行为
let g:NERDTreeWinSize = 30            " 窗口宽度
let g:NERDTreeQuitOnOpen = 0          " 打开文件后不关闭 NERDTree
let g:NERDTreeRespectWildIgnore = 1   " 遵守 wildignore 规则

" ========================
" 快捷键优化
" ========================

" 开关快捷键
nmap <silent> <Leader>ee :NERDTreeToggle<CR>
nmap <silent> <Leader>ef :NERDTreeFind<CR>

" 窗口内操作键
let g:NERDTreeMapActivateNode = 'o'       " 打开文件/目录 (原 'o')
let g:NERDTreeMapPreview = 'p'            " 预览文件 (原 'go')
let g:NERDTreeMapOpenSplit = 's'          " 水平分割打开 (原 'i')
let g:NERDTreeMapOpenVSplit = 'v'         " 垂直分割打开 (原 'gi')
" let g:NERDTreeMapRefresh = 'r'            " 刷新节点 (原 'R')

" ========================
" 视觉美化
" ========================

" 图标支持 (需 Nerd Font)
let g:NERDTreeFileExtensionHighlightFullName = 1  " 文件扩展名高亮
let g:NERDTreeExactMatchHighlightFullName = 1     " 精确匹配高亮
let g:NERDTreeHighlightFolders = 1                " 文件夹图标高亮
let g:NERDTreeLimitedSyntax = 1                   " 仅高亮常用扩展名

" 自定义符号
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" 颜色主题适配
" 在 colorscheme 后重置高亮
" autocmd ColorScheme * highlight NERDTreeFile ctermfg=LightGray guifg=#D8DEE9      " 会导致颜色过浅
autocmd ColorScheme * highlight NERDTreeDir ctermfg=Blue guifg=#81A1C1

" ========================
" 高级功能
" ========================

" Git 状态集成
let g:NERDTreeGitStatusIndicatorMap = {
            \ 'Modified'  : '✹',
            \ 'Staged'    : '✚',
            \ 'Untracked' : '✭',
            \ 'Renamed'   : '➜',
            \ 'Unmerged'  : '═',
            \ 'Deleted'   : '✖',
            \ 'Dirty'     : '✗',
            \ 'Clean'     : '✔︎',
            \ 'Ignored'   : '☒',
            \ 'Unknown'   : '?'
            \ }

" 自动行为
" 当最后一个窗口是 NERDTree 时自动关闭
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" 启动时自动打开 NERDTree (可选)
" autocmd VimEnter * NERDTree | wincmd p

" 动态过滤文件
let g:NERDTreeCustomFilter = 'filter({node -> node.path.getLastPathComponent() !~? "\\v(tmp|temp)"})'

" ========================
" 优化与兼容配置
" ========================

" 保留 （不优化）
let g:NERDTreeChDirMode = 2

" 禁用不必要的渲染
let g:NERDTreeAutoCD = 0
let g:NERDTreeAutoCenter = 0
let g:NERDTreeMinimalMenu = 1
