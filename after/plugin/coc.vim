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
      \ 'coc-go',
      \ 'coc-json',
      \ 'coc-yaml',
      \ 'coc-vimlsp',
      \ 'coc-sh',
      \ 'coc-snippets',
      \ 'coc-explorer',
      \ 'coc-marketplace',
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
"   coc-translator    - 翻译插件，支持弹窗、命令行和替换三种模式

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" 翻译：始终显示 signcolumn（否则 diagnostics 出现/消失会导致文本左右跳动）
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

" 跳转到代码定义（GoTo Definition）
nmap <silent><nowait> gd <Plug>(coc-definition)
" 跳转到类型定义（GoTo Type Definition）
nmap <silent><nowait> gy <Plug>(coc-type-definition)
" 跳转到实现（GoTo Implementation）
nmap <silent><nowait> gi <Plug>(coc-implementation)
" 跳转到所有引用（GoTo References）
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

" 作用：为选中区域或当前光标的代码块应用代码操作（Code Action）
" 例如：选中文本后按 <leader>a 触发快速修复、重构等操作
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

" ============================================================================
" 文档预览窗口滚动支持
" ============================================================================
" 使用 <C-j> 和 <C-k> 滚动文档预览窗口
" 优先滚动浮动窗口，如果没有浮动窗口则滚动预览窗口
function! s:ScrollDocumentation(direction)
  " 首先检查是否有可滚动的浮动窗口
  if coc#float#has_scroll()
    " 滚动浮动窗口：1 表示向下，0 表示向上
    call coc#float#scroll(a:direction ==# 'down' ? 1 : 0)
    return
  endif
  
  " 检查是否有预览窗口
  let preview_win = -1
  for winid in range(1, winnr('$'))
    if getwinvar(winid, '&previewwindow', 0)
      let preview_win = win_getid(winid)
      break
    endif
  endfor
  
  " 如果找到预览窗口，滚动它
  if preview_win != -1
    if a:direction ==# 'down'
      call win_execute(preview_win, 'normal! ' . &scroll . "\<C-e>")
    else
      call win_execute(preview_win, 'normal! ' . &scroll . "\<C-y>")
    endif
  endif
endfunction

" 映射 <C-j> 和 <C-k> 来滚动文档预览
nnoremap <silent> <C-j> :call <SID>ScrollDocumentation('down')<CR>
nnoremap <silent> <C-k> :call <SID>ScrollDocumentation('up')<CR>
inoremap <silent> <C-j> <C-o>:call <SID>ScrollDocumentation('down')<CR>
inoremap <silent> <C-k> <C-o>:call <SID>ScrollDocumentation('up')<CR>


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
" 注意：<space>a 与 <leader>a（代码操作）冲突，改为 <space>d
nnoremap <silent><nowait> <space>d  :<C-u>CocList diagnostics<cr>
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
" coc-translator 翻译插件配置
" ============================================================================
" 说明：coc-translator 是 coc.nvim 生态中非常优秀的翻译插件
" 安装：:CocInstall coc-translator
" 使用场景：在 Vim 界面内直接翻译单词和文本，特别适合学习英语的开发者

" 1. 弹窗翻译 (Popup): 最常用，不打断思路
" <Leader>t 翻译光标下的单词（Normal 模式）
nmap <Leader>t <Plug>(coc-translator-p)
" <Leader>t 翻译选中的文本（Visual 模式）
vmap <Leader>t <Plug>(coc-translator-pv)

" 2. 命令行回显 (Echo): 适合只想快速看一眼意思，不想挡住代码
" <Leader>e 翻译光标下的单词（Normal 模式）
"nmap <Leader>e <Plug>(coc-translator-e)
" <Leader>e 翻译选中的文本（Visual 模式）
"vmap <Leader>e <Plug>(coc-translator-ev)

" 3. 替换文本 (Replace): 慎用，把选中的英文直接变成中文
" 默认注释掉，如需使用请取消注释
" nmap <Leader>r <Plug>(coc-translator-r)
" vmap <Leader>r <Plug>(coc-translator-rv)

" 查看翻译历史：:CocList translation

:nmap <space>ee <Cmd>CocCommand explorer<CR>

let g:coc_explorer_global_presets = {
\   '.vim': {
\     'root-uri': '~/.vim',
\   },
\   'cocConfig': {
\      'root-uri': '~/.config/coc',
\   },
\   'tab': {
\     'position': 'tab',
\     'quit-on-open': v:true,
\   },
\   'tab:$': {
\     'position': 'tab:$',
\     'quit-on-open': v:true,
\   },
\   'floating': {
\     'position': 'floating',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingTop': {
\     'position': 'floating',
\     'floating-position': 'center-top',
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingLeftside': {
\     'position': 'floating',
\     'floating-position': 'left-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'floatingRightside': {
\     'position': 'floating',
\     'floating-position': 'right-center',
\     'floating-width': 50,
\     'open-action-strategy': 'sourceWindow',
\   },
\   'simplify': {
\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   },
\   'buffer': {
\     'sources': [{'name': 'buffer', 'expand': v:true}]
\   },
\ }

" Use preset argument to open it
nmap <space>ed <Cmd>CocCommand explorer --preset .vim<CR>
nmap <space>ef <Cmd>CocCommand explorer --preset floating<CR>
nmap <space>ec <Cmd>CocCommand explorer --preset cocConfig<CR>
nmap <space>eb <Cmd>CocCommand explorer --preset buffer<CR>

" List all presets
nmap <space>el <Cmd>CocList explPresets<CR>