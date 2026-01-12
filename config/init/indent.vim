" ============================================================================
" 缩进配置
" ============================================================================

" 启用自动缩进
set autoindent
set smartindent

" 不同文件类型的缩进设置
autocmd FileType python setlocal indentexpr=pythonindent#PythonIndent()
autocmd FileType javascript setlocal indentexpr=GetJavascriptIndent()
autocmd FileType html setlocal indentexpr=HtmlIndent()

" 缩进可视化（可选，需要插件支持）
" set listchars=tab:▸\ ,trail:·,extends:>,precedes:<
" set list
