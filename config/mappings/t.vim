"==============================================================
" config/mappings/t.vim
" 主题相关快捷键：所有 t 开头的快捷键统一管理
"==============================================================

if exists('g:loaded_t_mappings')
  finish
endif
let g:loaded_t_mappings = 1

"==============================================================
" t / T - Theme / Terminal 相关
"==============================================================
" 规范：小写 t 用于视觉样式切换，预留大写 T 给终端/任务面板

" tt -> Theme Toggle：切换日间/夜间主题
if exists('*ToggleThemeMode')
  nnoremap <silent> <leader>tt :call ToggleThemeMode()<CR>
endif

