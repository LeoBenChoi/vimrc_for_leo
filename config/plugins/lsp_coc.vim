"==============================================================
" config/plugins/lsp_coc.vim
" LSP 配置：coc.nvim 语言服务器协议
"==============================================================

if exists('g:loaded_lsp_coc_config')
  finish
endif
let g:loaded_lsp_coc_config = 1

"==============================================================
" 1. 基础配置
"==============================================================
let g:coc_config_home = expand('~/.vim')

" 设置 Node.js 路径（优先使用 nvm 安装的版本）
" 如果 nvm 已安装，使用 nvm 的 Node.js；否则使用系统默认的
let s:nvm_node = expand('~/.nvm/versions/node/v18.20.8/bin/node')
if filereadable(s:nvm_node)
  let g:coc_node_path = s:nvm_node
endif

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
      \ '@yaegassy/coc-pylsp',
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
"   coc-pyright       - Python LSP（基于 Pyright）
"   @yaegassy/coc-pylsp - Python LSP（基于 Pylsp，Pyright 的替代方案）
"   coc-tsserver      - JavaScript/TypeScript LSP
"   coc-go            - Go LSP
"   coc-html          - HTML 支持
"   coc-css           - CSS 支持
"   coc-eslint        - ESLint 集成
"   coc-prettier      - 代码格式化
"   coc-clangd        - C/C++ LSP
"   coc-phpls         - PHP LSP

"==============================================================
" 3. Tab 补全配置
"==============================================================
" Tab 补全导航函数：检查光标前是否是空格
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Tab 键：补全菜单中导航下一个，无菜单则触发补全，光标前是空格则正常插入 Tab
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Shift+Tab：补全菜单中导航上一个
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" 回车键：确认补全项，无补全则正常回车并插入 undo 点
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Ctrl+Space 触发补全
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

"==============================================================
" 4. 自动格式化配置
"==============================================================
" 保存时自动格式化（仅当 LSP 支持格式化时）
" 使用安全函数，避免找不到格式化工具时报错
function! s:CocFormatOnSave() abort
  if !exists('*coc#rpc#start_server')
    return
  endif
  " 使用 try-catch 避免格式化工具不存在时报错
  try
    " 检查是否有可用的格式化工具
    if exists('*CocHasProvider') && CocHasProvider('format')
      call CocAction('format')
    elseif !exists('*CocHasProvider')
      " 如果 CocHasProvider 不存在，直接尝试格式化（会静默失败）
      silent! call CocAction('format')
    endif
  catch /.*/
    " 忽略格式化错误，避免中断保存操作
  endtry
endfunction

augroup CocFormatOnSave
  autocmd!
  autocmd BufWritePre *.go,*.vue,*.php,*.js,*.ts,*.jsx,*.tsx,*.py,*.c,*.cpp,*.h
        \ call s:CocFormatOnSave()
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
" 5. 诊断与错误定位
"==============================================================
" 跳转到上一个诊断（错误/警告/提示/建议）
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)

" 跳转到下一个诊断（错误/警告/提示/建议）
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" 打开诊断列表
nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<cr>

"==============================================================
" 6. 代码修复与重构
"==============================================================
" 注意：所有代码操作快捷键已迁移到 mappings/a.vim
" 这里只保留配置说明

"==============================================================
" 7. 代码导航与跳转
"==============================================================
" 注意：g 开头的跳转快捷键（gd, gy, gi, gr）已迁移到 mappings/g.vim
" 以下是非 g 开头的跳转相关快捷键

" K -> Hover/Preview：查看文档（使用原生 K 键）
nnoremap <silent> K :call <SID>show_documentation()<CR>

" <C-o> -> 返回上一个位置（跳转后返回）
nmap <silent> <C-o> <Plug>(coc-definition-back)

" <leader>rn -> Rename：重命名符号
nmap <silent> <leader>rn <Plug>(coc-rename)

" 显示文档的函数
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

"==============================================================
" 8. 其他优化配置
"==============================================================
" 指定 python 路径（如果需要，取消注释并修改路径）
" let g:python3_host_prog = 'D:\Program Files\Python313\python.exe'

" 如果 coc 未安装，不执行其余内容
if !exists('*coc#rpc#start_server')
  finish
endif
