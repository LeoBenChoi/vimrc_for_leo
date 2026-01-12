" ============================================================================
" 映射配置 - T (Tab/TODO/Test/Theme)
" ============================================================================

" 标签页操作
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>te :tabedit <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>th :tabprev<CR>
nnoremap <leader>tl :tabnext<CR>
nnoremap <leader>tmh :tabmove -1<CR>
nnoremap <leader>tml :tabmove +1<CR>

" 主题切换
nnoremap <leader>tt :call ToggleTheme()<CR>  " 切换主题（深色/浅色）

" TODO 搜索
nnoremap <leader>td :TODO<CR>        " 搜索所有 TODO 注释
nnoremap <leader>tf :TODOFile<CR>   " 搜索当前文件的 TODO 注释
