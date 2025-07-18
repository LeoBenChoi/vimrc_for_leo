" ========================
" vim-commentary 
" 功能：快速注释
" ========================

" 确保只加载一次
if exists('g:config_load_commentary')
    finish
endif
let g:config_load_commentary = 1

" ========================
" 配置自定义注释
" ========================

" .editorconfig 文件使用 # 注释
autocmd BufNewFile,BufRead *.editorconfig setlocal commentstring=#\ %s