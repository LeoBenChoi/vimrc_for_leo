if exists('g:loaded_nerdtree') || &compatible
	finish
else
	let g:loaded_nerdtree = 'yes'
endif

" =======================================================
" [NERDTree] 侧边栏核心配置
" =======================================================

" 1. 快捷键映射
" F2: 打开/关闭侧边栏
nnoremap <silent> <F2> :NERDTreeToggle<CR>
" <Leader>e: 在侧边栏中定位当前文件 (非常有用！)
nnoremap <silent> <leader>e :NERDTreeFind<CR>

" 2. 界面美化
let g:NERDTreeMinimalUI = 1      " 隐藏 'Press ? for help' 顶部提示
let g:NERDTreeDirArrowExpandable = '▸'  " 文件夹收起图标
let g:NERDTreeDirArrowCollapsible = '▾' " 文件夹展开图标

" 3. 显示行号 (可选，如果你喜欢侧边栏也有行号)
let g:NERDTreeShowLineNumbers = 0

" 4. 窗口宽度
let g:NERDTreeWinSize = 30

" =======================================================
" [Automation] 自动化行为
" =======================================================

" 行为 B: 如果关闭了所有文件，只剩下 NERDTree 窗口，则自动退出 Vim
" (防止你关了代码后，还得对着一个空的侧边栏再按一次 :q)
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" =======================================================
" [Git Plugin] Git 状态图标配置
" =======================================================
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }
