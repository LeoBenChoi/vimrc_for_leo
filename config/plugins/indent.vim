"==============================================================
" config/plugins/indent.vim
" 缩进可视化配置：纯 Vim list 模式
" 使用 Vim 内置的 list 功能显示制表符和空格
"==============================================================

if exists('g:loaded_indent_config')
  finish
endif
let g:loaded_indent_config = 1

"==============================================================
" 1. list 模式配置（纯 Vim 方案，无需插件）
"==============================================================
" 注意：list 模式的基础配置已在 basic.vim 中默认开启
" 这里提供文件类型排除功能

" 排除某些文件类型（不显示 list 模式）
augroup ListModeExclude
  autocmd!
  autocmd FileType help,startify,dashboard,nerdtree,markdown setlocal nolist
augroup END
