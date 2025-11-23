"==============================================================
" config/mappings/g.vim
" Git 相关快捷键：所有 g 开头的快捷键统一管理
"==============================================================

if exists('g:loaded_g_mappings')
  finish
endif
let g:loaded_g_mappings = 1

"==============================================================
" g / G - Git 操作快捷键
"==============================================================
" 规范：所有 Git 相关快捷键统一归档在 g 段

" 注意：vim-fugitive 的快捷键在 git.vim 中动态设置
" 这里提供占位符，实际映射由 SetupGitFugitiveMappings() 函数设置

" vim-fugitive 快捷键（由 git.vim 中的 s:SetupGitMappings() 设置）
" gs -> Git status：打开 Git 状态窗口
" gc -> Git commit：提交更改
" gw -> Git write：暂存当前文件
" gd -> Git diff：查看文件差异
" gb -> Git blame：查看文件注释历史
" gl -> Git log：查看提交历史
" gr -> Git read：撤销更改（检出文件）
" gP -> Git push：推送
" gL -> Git pull：拉取

" vim-gitgutter 快捷键（直接映射，不依赖函数）
" gh -> GitGutter PrevHunk：跳转到上一个变更
nmap <silent> <leader>gh <Plug>(GitGutterPrevHunk)

" gj -> GitGutter NextHunk：跳转到下一个变更
nmap <silent> <leader>gj <Plug>(GitGutterNextHunk)

" gv -> GitGutter PreviewHunk：预览变更
nmap <silent> <leader>gv <Plug>(GitGutterPreviewHunk)

" gS -> GitGutter StageHunk：暂存当前变更块
nmap <silent> <leader>gS <Plug>(GitGutterStageHunk)

" gu -> GitGutter UndoHunk：撤销当前变更块
nmap <silent> <leader>gu <Plug>(GitGutterUndoHunk)

" gt -> GitGutter Toggle：切换 GitGutter 显示
nnoremap <silent> <leader>gt :GitGutterToggle<CR>

