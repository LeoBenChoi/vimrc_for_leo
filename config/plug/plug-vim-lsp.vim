" vim-lsp 配置 lsp备选方案

" 注册服务器
if executable('pylsp')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" 禁用vim-lsp的代码折叠功能，避免与其他折叠插件冲突
let g:lsp_fold_enabled = 0

" 文档高亮
let g:lsp_document_highlight_enabled = 1

" 高亮当前光标下的符号及其引用
highlight lspReference ctermfg=red guifg=red ctermbg=green guibg=green

" LSP

" Bash
" ccls - C/C++
" Clangd - C/C++
" Clojure
" Crystal
" Css/Less/Sass
" cquery - C/C++
" CWL
" Docker
" Erlang
" Flow - Javascript
" Go
" Godot
" Groovy
" Hack
" Haskell
" HTML
" Java
if executable('jdtls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'Eclipse JDT Language Server',
        \ 'cmd': {server_info->['jdtls', '-data', getcwd()]},
        \ 'allowlist': ['java']
        \ })
endif
" JavaScript
" JSON
" Julia
" Kotlin
" Lua
" Perl
" PHP
" Python
" Ruby
" Rust
" Scala
" Swift
" Tex
" TOML
" TypeScript
" OCaml+Reason
" VHDL
" Vim
" XML
" YAML
