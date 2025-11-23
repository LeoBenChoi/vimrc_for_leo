"==============================================================
" config/mappings/a.vim
" LSP 代码操作相关快捷键：所有 a 开头的快捷键统一管理
"==============================================================

if exists('g:loaded_a_mappings')
  finish
endif
let g:loaded_a_mappings = 1

"==============================================================
" a / A - Action / 代码操作
"==============================================================
" 规范：小写 a 用于 LSP 代码操作（修复、重构等）

" aq -> Quick Fix：快速修复当前问题（光标所在位置的快速修复）
nmap <silent> <leader>aq <Plug>(coc-fix-current)

" ac -> Code Action Cursor：光标处的代码操作（修复/重构）
nmap <silent> <leader>ac <Plug>(coc-codeaction-cursor)

" a -> Code Action Selected：选中区域的代码操作（可视化模式）
" 选中区域的代码操作（可视化模式）
xmap <silent> <leader>a <Plug>(coc-codeaction-selected)
" 选中区域的代码操作（普通模式）
nmap <silent> <leader>a <Plug>(coc-codeaction-selected)

" as -> Code Action Source：源代码级别的代码操作（模块管理、批量重构、导入优化）
nmap <silent> <leader>as <Plug>(coc-codeaction-source)

