" ~/.vim/config/plug-lsp.vim
" ========================
" plug-lsp 语言服务器
" 功能：代码补全
" ========================

" 确保只加载一次
if exists('g:plug_load_lsp')
    finish
endif
let g:plug_load_lsp = 1

" ========================
" 基础配置
" ========================

" 启用 LSP 客户端
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_float_cursor = 1
" let g:lsp_signature_help_enabled = 0  " 按需手动触发
let g:lsp_signature_help_enabled = 1

" 异步补全设置
let g:asyncomplete_auto_completeopt = 1
set completeopt=menuone,noinsert,noselect

" ========================
" 快捷键映射
" ========================

" 诊断类·
nnoremap <silent> [d    :LspPreviousDiagnostic<CR>
nnoremap <silent> ]d    :LspNextDiagnostic<CR>
nnoremap <silent> <leader>d :LspPeekDiagnostic<CR>

" 补全增强
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" 导航类
nnoremap <silent> gd    :LspDefinition<CR>
nnoremap <silent> <F2>  :LspRename<CR>
nnoremap <silent> gr    :LspReferences<CR>

let g:lsp_diagnostics_signs_error = {'text': '✗'}
let g:lsp_diagnostics_signs_warning = {'text': '!'}
sign define LspError text=✗ texthl=Error
sign define LspWarning text=! texthl=Todo


let g:vista_default_executive = 'vim_lsp'  " 优先使用LSP
" let g:vista_default_executive = 'lsp'  " 优先使用LSP
" let g:vista_default_executive = 'ctags'  " 优先使用LSP
nmap <silent> <F8> :Vista!!<CR>       " 开关大纲

" 或者针对不同文件类型指定不同的后端（更灵活）
let g:vista_executive_for = {
            \ 'go': 'vim_lsp',
            \ 'python': 'ctags',
            \ 'cpp': 'vim_lsp',
            \ }


" ========================
" LSP 服务器配置
" ========================

" LSP 缓冲区初始化时映射常用命令
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nnoremap <buffer> gd <plug>(lsp-definition)
    nnoremap <buffer> gs <plug>(lsp-document-symbol-search)
    nnoremap <buffer> gr <plug>(lsp-references)
    nnoremap <buffer> gi <plug>(lsp-implementation)
    nnoremap <buffer> gt <plug>(lsp-type-definition)
    nnoremap <buffer> <leader>rn <plug>(lsp-rename)
    nnoremap <buffer> [g <plug>(lsp-previous-diagnostic)
    nnoremap <buffer> ]g <plug>(lsp-next-diagnostic)
    nnoremap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr> <C-f> lsp#scroll(+4)
    nnoremap <buffer> <expr> <C-d> lsp#scroll(-4)
    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    autocmd BufWritePre *.go :silent! GoImports

endfunction
augroup lsp_setup
    autocmd!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" 配置各语言的 LSP 服务器
"Bash
"ccls - C/C++
"Clangd - C/C++
"Clojure
"Crystal
"Css/Less/Sass
"cquery - C/C++
"CWL
"Docker
if executable('docker-langserver')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'docker-langserver',
                \ 'cmd': {server_info->['docker-langserver', '--stdio']},
                \ 'allowlist': ['dockerfile']
                \ })
endif

"Erlang
"Flow - Javascript
"Go
if executable('gopls')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'gopls',
                \ 'cmd': ['gopls', '-remote=auto'],
                \ 'allowlist': ['go', 'gomod', 'gohtmltmpl', 'gotexttmpl']
                \ })
    let g:go_def_mode = 'gopls'
    let g:go_info_mode = 'gopls'
    let g:go_fmt_command = "goimports"   " 保存时自动格式化并排序 import
    let g:go_gopls_enabled = 1
    let g:go_code_completion_enabled = 1
    let g:go_doc_keywordprg_enabled = 0
    autocmd BufWritePre *.go :silent! GoImports
endif

"Godot
"Groovy
"Hack
"Haskell
"HTML
if executable('html-languageserver')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'html-ls',
                \ 'cmd': ['html-languageserver', '--stdio'],
                \ 'allowlist': ['html']
                \ })
endif

"Java
if executable('jdtls')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'Eclipse JDT LS',
                \ 'cmd': ['jdtls'],
                \ 'allowlist': ['java']
                \ })
endif

"JavaScript and TypeScript
if executable('typescript-language-server')
    augroup LspJS_TS
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'typescript-language-server',
                    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
                    \ 'root_uri': {server_info->lsp#utils#path_to_uri(
                    \     lsp#utils#find_nearest_parent_file_directory(
                    \         lsp#utils#get_buffer_path(), 'tsconfig.json'))},
                    \ 'allowlist': ['javascript', 'javascript.jsx', 'typescript', 'typescript.tsx', 'typescriptreact'],
                    \ })
    augroup END
endif
autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx call execute('LspCodeActionSync source.organizeImports')
autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx call execute('LspDocumentFormatSync')

"Julia
"Kotlin
"Lua
"Perl
"PHP
if executable('intelephense')
    augroup LspPHPIntelephense
        au!
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'intelephense',
                    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'intelephense --stdio']},
                    \ 'whitelist': ['php'],
                    \   'initialization_options': {'storagePath': has('win32') ? expand('~/AppData/Local/Temp/intelephense') : '/tmp/intelephense'},
                    \ 'workspace_config': {
                    \   'intelephense': {
                    \     'files': {
                    \       'maxSize': 1000000,
                    \       'associations': ['*.php', '*.phtml'],
                    \       'exclude': [],
                    \     },
                    \     'completion': {
                    \       'insertUseDeclaration': v:true,
                    \       'fullyQualifyGlobalConstantsAndFunctions': v:false,
                    \       'triggerParameterHints': v:true,
                    \       'maxItems': 100,
                    \     },
                    \     'format': {
                    \       'enable': v:true
                    \     },
                    \   },
                    \ }
                    \})
    augroup END
endif

"Python
if executable('pyls') " or 'pylsp'
    au User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': ['pyls'],
                \ 'allowlist': ['python'],
                \ 'workspace_config': {'pyls': {'plugins': {'pydocstyle': {'enabled': v:true}}}}
                \ })
endif

"Ruby
"Rust
"Scala
"Swift
"Tex
"TOML

if executable('vim-language-server')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'vimls',
                \ 'cmd': ['vim-language-server', '--stdio'],
                \ 'allowlist': ['vim'],
                \ 'initialization_options': {
                \   'vimruntime': $VIMRUNTIME,
                \   'runtimepath': &rtp,
                \ }})
endif

"OCaml+Reason
"VHDL
"Vim
"YAML
if executable('yaml-language-server')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'yamlls',
                \ 'cmd': ['yaml-language-server', '--stdio'],
                \ 'allowlist': ['yaml', 'yaml.ansible'],
                \ 'workspace_config': {
                \   'yaml': {'validate': v:true, 'hover': v:true, 'completion': v:true}
                \ }
                \ })
endif
