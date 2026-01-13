" ============================================================================
" Git 插件配置（Git 三剑客）
" 文件位置: ~/.vim/after/plugin/git.vim
" 说明: 此文件会在所有插件加载后自动执行，用于配置 Git 相关插件
" ============================================================================

" ============================================================================
" 1. vim-gitgutter 配置
" ============================================================================

" 关键设置：减少更新时间，让 gitgutter 响应更快
" 默认是 4000ms，太慢了，改成 100ms
set updatetime=100

" 快捷键：在变更之间跳转
" ]c : 下一个变更点
" [c : 上一个变更点
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)

" 快捷键：预览/撤销/暂存 当前光标处的变更
" <Leader>hp (Hunk Preview) 预览
" <Leader>hu (Hunk Undo)    撤销
" <Leader>hs (Hunk Stage)   暂存
nmap <Leader>hp <Plug>(GitGutterPreviewHunk)
nmap <Leader>hu <Plug>(GitGutterUndoHunk)
nmap <Leader>hs <Plug>(GitGutterStageHunk)

" ============================================================================
" 2. vim-fugitive 配置
" ============================================================================

" <Leader>gs 打开 Git 状态窗口 (Git Status)
nnoremap <Leader>gs :Git<CR>

" <Leader>gb 打开 Git Blame (查看每一行是谁写的)
nnoremap <Leader>gb :Git blame<CR>

" <Leader>gd 打开 Git Diff (分屏对比)
nnoremap <Leader>gd :Gdiffsplit<CR>

" ============================================================================
" 3. gv.vim 配置
" ============================================================================

" <Leader>gl 查看提交历史 (Git Log)
nnoremap <Leader>gl :GV<CR>

" <Leader>gf 查看当前文件的提交历史 (Git File log)
nnoremap <Leader>gf :GV!<CR>
