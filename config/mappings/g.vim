"==============================================================
" config/mappings/g.vim
" Git 操作快捷键映射
"==============================================================

if exists('g:loaded_git_mappings')
  finish
endif
let g:loaded_git_mappings = 1

"==============================================================
" 1. vim-fugitive 快捷键（Git 集成）
"==============================================================
if exists(':Git')
  " 打开 Git 状态窗口
  nnoremap <silent> <leader>gs :Git<CR>
  
  " Git 提交
  nnoremap <silent> <leader>gc :Git commit<CR>
  
  " Git 推送
  nnoremap <silent> <leader>gp :Git push<CR>
  
  " Git 拉取
  nnoremap <silent> <leader>gl :Git pull<CR>
  
  " Git 差异查看
  nnoremap <silent> <leader>gd :Gdiffsplit<CR>
  
  " Git 日志
  nnoremap <silent> <leader>gL :Git log<CR>
  
  " Git blame（查看当前文件的提交历史）
  nnoremap <silent> <leader>gb :Git blame<CR>
  
  " Git 浏览器（查看 Git 对象）
  nnoremap <silent> <leader>go :GBrowse<CR>
endif

"==============================================================
" 2. vim-gitgutter 快捷键（Git 差异显示）
"==============================================================
if exists(':GitGutterEnable')
  " 跳转到下一个/上一个变更
  nnoremap <silent> <leader>gn :GitGutterNextHunk<CR>
  nnoremap <silent> <leader>gN :GitGutterPrevHunk<CR>
  
  " 预览变更（在浮动窗口或预览窗口中显示）
  nnoremap <silent> <leader>gP :GitGutterPreviewHunk<CR>
  
  " 暂存当前变更（git add）
  nnoremap <silent> <leader>ga :GitGutterStageHunk<CR>
  
  " 撤销当前变更（git checkout）
  nnoremap <silent> <leader>gu :GitGutterUndoHunk<CR>
  
  " 切换 GitGutter（启用/禁用）
  nnoremap <silent> <leader>gt :GitGutterToggle<CR>
  
  " 更新 GitGutter 状态
  nnoremap <silent> <leader>gr :GitGutter<CR>
endif

"==============================================================
" 3. 组合快捷键说明
"==============================================================
" <leader>g 前缀用于所有 Git 相关操作
"   gs - Git status（状态窗口）
"   gc - Git commit（提交）
"   gp - Git push（推送）
"   gl - Git pull（拉取）
"   gd - Git diff（差异查看）
"   gL - Git log（日志）
"   gb - Git blame（提交历史）
"   go - Git browse（浏览器）
"   gn - Next hunk（下一个变更）
"   gN - Prev hunk（上一个变更）
"   gP - Preview hunk（预览变更）
"   ga - Stage hunk（暂存变更）
"   gu - Undo hunk（撤销变更）
"   gt - Toggle（切换 GitGutter）
"   gr - Refresh（刷新状态）
