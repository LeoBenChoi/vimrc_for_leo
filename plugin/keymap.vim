" 窗格导航：Ctrl+h/j/k/l 对应 左/下/上/右
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" =============================================================================
" FZF 键位（仅当 fzf 已加载时生效）
" <leader>f 已被 coc.vim 用作格式化选中，故 Rg 用 <leader>fg（g@ 即 Coc 的 operator-pending）
" =============================================================================
if exists(':Files')
endif
nnoremap <silent> <leader>fg :Rg<CR>
