" =======================================================
" [Git Suite] Fugitive & Signify 集成配置
" =======================================================
" Git 黄金三角组合：
" 1. vim-fugitive: 核心操作（提交、推送、拉取、查看历史等）
" 2. vim-signify: 视觉反馈（左侧栏显示增删改标记）
" 3. vim-airline: 状态栏显示（分支名和变更统计）

" --- 1. vim-signify (左侧栏) ---
" 只使用 Git 作为版本控制系统
let g:signify_vcs_list = ['git']
" 光标停留时实时更新（配合 updatetime=300）
let g:signify_realtime = 1

" 符号定制（经典风格）
let g:signify_sign_add               = '+'
let g:signify_sign_delete            = '_'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change            = '~'

" 颜色定制（Gruvbox/Retrobox 风格）
highlight SignifySignAdd    ctermfg=green  guifg=#98c379
highlight SignifySignDelete ctermfg=red    guifg=#e06c75
highlight SignifySignChange ctermfg=yellow guifg=#e5c07b

" 快捷键：在变更之间跳转（类似于 git diff）
" <leader>gj : 跳转到下一个修改处 (Jump)
" <leader>gk : 跳转到上一个修改处
nmap <leader>gj <plug>(signify-next-hunk)
nmap <leader>gk <plug>(signify-prev-hunk)

" --- 2. vim-fugitive (核心操作) ---
" 核心快捷键映射（助记：G + 动作）

" <Leader>gs : 打开 Git 状态窗口 (Status) -> 这是一个交互式面板！
nnoremap <silent> <leader>gs :G<CR>

" <Leader>gc : 提交代码 (Commit)
nnoremap <silent> <leader>gc :G commit<CR>

" <Leader>gp : 推送 (Push)
nnoremap <silent> <leader>gp :G push<CR>

" <Leader>gl : 拉取 (Pull)
nnoremap <silent> <leader>gl :G pull<CR>

" <Leader>gb : 显示该行是谁写的 (Blame) -> 再按一次关闭
nnoremap <silent> <leader>gb :G blame<CR>

" <Leader>gd : 查看当前文件的 Diff (Diff)
nnoremap <silent> <leader>gd :Gvdiffsplit<CR>

" --- 3. FZF 集成：浏览 Git 历史 ---
" 如果已安装 fzf.vim，可以使用以下命令：
" :Commits   - 查看项目的所有提交历史（支持搜索）
" :BCommits  - 查看当前文件的提交历史（非常实用）
