" ============================================================================
" 映射配置 - A (Code Actions)
" ============================================================================

" 代码操作（Code Actions）
" 对选中代码块应用 Code Action
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" 应用于光标位置的代码操作
nmap <leader>ac  <Plug>(coc-codeaction-cursor)

" 应用于整个缓冲区的代码操作
nmap <leader>as  <Plug>(coc-codeaction-source)
