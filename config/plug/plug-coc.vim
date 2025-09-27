" 这个配置文件比较特殊，它的大部分配置在 mapping 里面，一部分在 fzf 里面， 少数配置散落在其他地方

" ========================
" 配置路径
" ========================

" coc config 文件路径
" 设置 cocconfig 路径
let g:coc_config_home = expand('~/.vim')
" let g:coc_config_file="~/.vim/coc-settings.jsonc"
" let g:coc_config_file="~/.vim/coc-settings.jsonc"
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
"   \ 'coc-go',          # Go 语言支持（核心）如果有内置的 gopls 可以不装
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

" 默认的json
" vue
" java
let g:coc_global_extensions = [
  \ 'coc-json',
  \
  \ 'coc-pyright',
  \ 'coc-eslint',
  \
  \ 'coc-html',
  \ 'coc-css',
  \ '@yaegassy/coc-volar',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-snippets',
  \
  \ 'coc-phpls',
  \
  \ 'coc-java',
  \ ]


  autocmd BufWritePre *.go,*.vue,*.php,*.js,*.ts :call CocAction('format')

" ========================
" 优化 与 兼容
" ========================

" 指定 python 路径, 解决 coc 无法找到 python 的问题
"  let g:python3_host_prog = 'D:\Program Files\Python313\python.exe'

" 取消对 CoC 插件一次性应用修改数量的限制，允许它进行批量修改
let g:coc_edits_maximum_count = 0

autocmd CursorHold * silent! lua vim.lsp.diagnostic.show_line_diagnostics()
