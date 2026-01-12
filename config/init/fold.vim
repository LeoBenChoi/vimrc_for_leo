" ============================================================================
" 折叠配置
" ============================================================================

" 折叠方法
set foldmethod=indent
set foldlevel=99
set foldnestmax=10

" 折叠快捷键
nnoremap <space> za
vnoremap <space> zf

" 不同文件类型的折叠设置
autocmd FileType vim setlocal foldmethod=marker
autocmd FileType python setlocal foldmethod=indent
autocmd FileType javascript setlocal foldmethod=indent
autocmd FileType json setlocal foldmethod=syntax
