"==============================================================
" config/mappings/c.vim
" 注释相关快捷键：所有 c 开头的快捷键统一管理
"==============================================================

if exists('g:loaded_c_mappings')
  finish
endif
let g:loaded_c_mappings = 1

"==============================================================
" c / C - Comment / 注释
"==============================================================
" 规范：小写 c 用于注释功能，使用 vim-commentary 插件

" cc -> CommentaryLine：注释当前行
nmap <silent> <leader>cc <Plug>CommentaryLine

" c -> Commentary：注释选中区域（可视化模式）或配合 motion
" 注释选中区域（可视化模式）
xmap <silent> <leader>c <Plug>Commentary
" 注释配合 motion（如 <leader>cap 注释段落）
nmap <silent> <leader>c <Plug>Commentary

