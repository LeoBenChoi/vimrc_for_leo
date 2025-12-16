"==============================================================
" config/mappings/g.vim
" Git 相关快捷键：所有 g 开头的快捷键统一管理
"==============================================================

if exists('g:loaded_g_mappings')
  finish
endif
let g:loaded_g_mappings = 1

"==============================================================
" g / G - Git 操作和代码跳转快捷键
"==============================================================
" 规范：所有 Git 相关快捷键统一归档在 g 段
" 同时包含 g 开头的 LSP 代码跳转快捷键（gd, gy, gi, gr）

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

"==============================================================
" 代码导航与跳转（LSP）- g 开头的快捷键
"==============================================================
" 注意：这些是直接使用的快捷键（无 leader），与 Git 的 <leader>g 快捷键不冲突

" 如果 coc 未安装，不执行 LSP 相关快捷键
if exists('*coc#rpc#start_server')
  " gd -> Go to Definition：跳转到定义
  nnoremap <silent> gd <Plug>(coc-definition)

  " gy -> Go to Type Definition：跳转到类型定义
  nnoremap <silent> gy <Plug>(coc-type-definition)

  " gi -> Go to Implementation：跳转到实现
  " 注意：gi 在 Vim 中是原生快捷键（进入插入模式并移动到上次编辑位置）
  " 这里覆盖原生行为，使用 LSP 跳转到实现
  " 如果需要原生 gi 功能，可以使用 <leader>gi 或其他快捷键
  nnoremap <silent> gi <Plug>(coc-implementation)
  
  " 备用快捷键：<leader>gi 也可以跳转到实现（如果 gi 不工作）
  nnoremap <silent> <leader>gi <Plug>(coc-implementation)

  " gr -> Go to References：查看引用
  nnoremap <silent> gr <Plug>(coc-references)
endif

