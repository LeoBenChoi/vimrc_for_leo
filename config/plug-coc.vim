" ~/.vim/config/vim-plug.vim
" ========================
" coc 语言服务器
" 功能：coc LSP
" ========================

" 确保只加载一次
if exists('g:config_load_cocnvim')
    finish
endif
let g:config_load_cocnvim = 1

" 这个配置文件比较特殊，它的大部分配置在 mapping 里面，一部分在 fzf 里面， 少数配置散落在其他地方

" ========================
" 配置路径
" ========================

" coc config 文件路径
"  let g:coc_config_home = '~/.vim/'
"  let g:coc_config_home = expand('~/.vim')
"  let g:coc_config_home = expand('$USERPROFILE/.vim')

"  autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd BufRead,BufNewFile coc-settings.json set filetype=jsonc

function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')

" ========================
" 语言支持
" ========================

" 全部语言支持 [ 注释 ]
" go 语言支持
" 启用 LSP 功能 会自动安装未安装的lsp
" let g:coc_global_extensions = [
"     \ 'coc-json',             " JSON "     \ 'coc-tsserver',         " JavaScript/TypeScript
"     \ 'coc-pyright',          " Python
"     \ 'coc-rust-analyzer',    " Rust
"     \ 'coc-clangd',           " C/C++
"     \ 'coc-java',             " Java
"     \ 'coc-html',
"     \ 'coc-css'
"     \ ]
" go 语言
"   \ 'coc-go',          # Go 语言支持（核心）
"   \ 'coc-json',        # 辅助 JSON 配置
"   \ 'coc-yaml',        # 用于 Go Mod 等配置
"   \ 'coc-diagnostic',  # 增强诊断
"   \ 'coc-snippets',    # 代码片段支持
" vue 语言支持
" let g:coc_global_extensions = [
"   \ '@yaegassy/coc-volar',  " vue3 lsp
"   \ 'coc-json',        " JSON 支持
"   \ 'coc-eslint',      " ESLint 集成（可选）
"   \ 'coc-prettier',    " 代码格式化（可选）
"   \ 'coc-vetur'        " vue lsp
"   \ ]

" go vue
let g:coc_global_extensions = [
            \ 'coc-go',
            \ 'coc-pyright',
            \ 'coc-eslint',
            \ 'coc-json',
            \ 'coc-html',
            \ '@yaegassy/coc-volar',
            \ 'coc-eslint',
            \ 'coc-tsserver',
            \ 'coc-vetur',
            \ ]

  autocmd BufWritePre *.go,*.vue :call CocAction('format')

" ========================
" 优化 与 兼容
" ========================

" 指定 python 路径, 解决 coc 无法找到 python 的问题
"  let g:python3_host_prog = 'D:\Program Files\Python313\python.exe'
