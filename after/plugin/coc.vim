" ============================================================================
" coc.nvim 插件配置
" 文件位置: ~/.vim/after/plugin/coc.vim
" 说明: 此文件会在所有插件加载后自动执行，用于配置 coc.nvim 插件
" ============================================================================

" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

" 设置 coc.nvim 配置文件路径
" 指定 coc-settings.json 文件所在目录
let g:coc_config_home = expand('~/.vim')

let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-snippets',
      \ '@yaegassy/coc-pylsp',
      \ 'coc-tsserver',
      \ 'coc-go',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-eslint',
      \ 'coc-prettier',
      \ 'coc-clangd',
      \ 'coc-phpls',
      \ 'coc-vetur',
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
"   coc-vetur         - Vue.js LSP（支持 Vue 2 和 Vue 3）

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" ============================================================================
" vim-go 配置（与 coc-go 兼容）
" ============================================================================
" 注意：vim-go 和 coc-go 可以同时使用，但需要合理分工：
"   - coc-go 负责：LSP 功能（补全、跳转、诊断、重构等）
"   - vim-go 负责：测试、运行、调试、代码生成等非 LSP 功能

if exists('g:loaded_go')
  " 禁用 vim-go 的 gopls（由 coc-go 使用）
  let g:go_gopls_enabled = 0
  
  " 禁用 vim-go 的自动补全（由 coc-go 提供）
  let g:go_code_completion_enabled = 0
  
  " 禁用 vim-go 的自动类型信息（由 coc-go 提供）
  let g:go_auto_type_info = 0
  
  " 禁用 vim-go 的自动诊断（由 coc-go 提供）
  let g:go_diagnostics_enabled = 0
  let g:go_metalinter_enabled = 0
  
  " 保留 vim-go 的其他有用功能
  " 启用代码高亮增强
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_interfaces = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_build_constraints = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_types = 1
  let g:go_highlight_function_parameters = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_variable_declarations = 1
  let g:go_highlight_variable_assignments = 1
  
  " 启用代码折叠（基于语法）
  let g:go_fold_enable = ['block', 'import', 'varconst', 'package_comment']
  
  " 格式化工具（gofmt）
  let g:go_fmt_command = 'goimports'  " 使用 goimports 自动管理导入
  let g:go_fmt_autosave = 1           " 保存时自动格式化
  let g:go_fmt_fail_silently = 0      " 格式化失败时显示错误
  
  " 测试相关
  let g:go_test_timeout = '10s'       " 测试超时时间
  let g:go_test_show_name = 1          " 显示测试名称
  
  " 标签导航（禁用，由 coc-go 提供）
  " 注意：当 gopls 被禁用时，vim-go 会回退到 godef/guru
  " 但我们希望完全由 coc-go 处理，所以不设置这些选项
  
  " 代码生成和模板
  let g:go_addtags_transform = 'snakecase'  " 结构体标签转换格式
  let g:go_addtags_flags = '-json'          " 添加 JSON 标签
  
  " 构建和运行
  let g:go_build_tags = ''            " 构建标签
  let g:go_play_browser_command = ''   " Play 命令的浏览器
  
  " 文档查看
  let g:go_doc_keywordprg_enabled = 0 " 禁用默认的 K 键映射（由 coc-go 提供）
  
  " 文件类型检测
  let g:go_auto_sameids = 0           " 禁用自动高亮相同标识符（由 coc-go 提供）
  
  " 错误和警告符号（使用 coc-go 的符号）
  " 不设置 g:go_diagnostics_* 相关变量，让 coc-go 处理
  
  " 快捷键映射（保留 vim-go 的实用命令）
  " 注意：LSP 相关功能（gd, gr, K 等）已由 coc-go 提供
  " vim-go 的命令如 :GoTest, :GoRun, :GoBuild 等仍然可用
endif

