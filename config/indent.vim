" ========================
" Go 语言缩进配置
" ========================
" 在 call plug#end() 之后配置，确保不被插件覆盖
autocmd FileType go setlocal tabstop=4
autocmd FileType go setlocal shiftwidth=4
autocmd FileType go setlocal softtabstop=4
autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal smartindent
