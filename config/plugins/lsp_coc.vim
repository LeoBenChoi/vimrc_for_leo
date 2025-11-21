"==============================================================
" config/plugins/lsp_coc.vim
" coc.nvim LSP 配置
"==============================================================

if exists('g:loaded_lsp_coc_config')
  finish
endif
let g:loaded_lsp_coc_config = 1

"==============================================================
" coc.nvim 配置文件位置设置
"==============================================================
" 设置 :CocConfig 命令打开的文件位置
let g:coc_config_home = expand('~/.vim')

" 设置 coc-settings.json 文件类型为 jsonc（支持注释）
autocmd BufRead,BufNewFile coc-settings.json set filetype=jsonc

" 命令缩写：使用 C 打开 coc config
function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
              \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
              \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction
call SetupCommandAbbrs('C', 'CocConfig')

"==============================================================
" coc.nvim 基础配置
"==============================================================
" 取消对 CoC 插件一次性应用修改数量的限制，允许它进行批量修改
let g:coc_edits_maximum_count = 0

"==============================================================
" LSP 扩展配置（全局扩展列表）
"==============================================================
" 启动时自动安装的扩展
" 注意：如果需要添加新的扩展，修改此列表后运行 :PlugInstall
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-snippets',
      \ 'coc-pyright',
      \ 'coc-tsserver',
      \ 'coc-go',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-eslint',
      \ 'coc-prettier',
      \ 'coc-clangd',
      \ 'coc-phpls',
      \ ]
" 扩展说明：
"   coc-json          - JSON 支持
"   coc-snippets      - 代码片段支持
"   coc-pyright       - Python LSP
"   coc-tsserver      - JavaScript/TypeScript LSP
"   coc-go            - Go LSP
"   coc-html          - HTML 支持
"   coc-css           - CSS 支持
"   coc-eslint        - ESLint 集成
"   coc-prettier      - 代码格式化
"   coc-clangd        - C/C++ LSP
"   coc-phpls         - PHP LSP

"==============================================================
" 自动格式化配置
"==============================================================
" 保存时自动格式化（仅当 LSP 支持格式化时）
augroup CocFormatOnSave
  autocmd!
  autocmd BufWritePre *.go,*.vue,*.php,*.js,*.ts,*.jsx,*.tsx,*.py,*.c,*.cpp,*.h
        \ call CocAction('format')
augroup END

" 为特定文件类型设置 formatexpr（支持 gq 命令） | 格式化
augroup CocFormatExpr
  autocmd!
  autocmd FileType typescript,typescriptreact,javascript,javascriptreact,json
        \ setl formatexpr=CocAction('formatSelected')
  autocmd FileType python,go,rust
        \ setl formatexpr=CocAction('formatSelected')
augroup END

"==============================================================
" 其他优化配置
"==============================================================
" 指定 python 路径（如果需要，取消注释并修改路径）
" let g:python3_host_prog = 'D:\Program Files\Python313\python.exe'

" 如果 coc 未安装，不执行其余内容
if !exists('*coc#rpc#start_server')
  finish
endif

