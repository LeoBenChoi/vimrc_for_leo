"==============================================================
" config/plugins/lsp_coc.vim
" LSP 配置：coc.nvim 语言服务器协议
"==============================================================

if exists('g:loaded_lsp_coc_config')
  finish
endif
let g:loaded_lsp_coc_config = 1

"==============================================================
" 0. 辅助函数：检查 Coc 插件是否已加载
"==============================================================
" 检查 Coc 是否已加载（通过检查关键函数是否存在）
" 使用全局函数以便在 <expr> 映射中使用
function! CocLoaded() abort
  return exists('*coc#refresh') && exists('*CocAction')
endfunction

" 脚本局部版本（用于脚本内部调用）
function! s:CocLoaded() abort
  return CocLoaded()
endfunction

" 安全调用 CocAction（如果 Coc 未加载则返回空）
function! s:CocActionSafe(...) abort
  if s:CocLoaded()
    return call('CocAction', a:000)
  endif
  return ''
endfunction

" 安全调用 CocActionAsync（如果 Coc 未加载则不执行）
function! s:CocActionAsyncSafe(...) abort
  if s:CocLoaded()
    call call('CocActionAsync', a:000)
  endif
endfunction

" 安全获取 Coc 状态（用于 statusline）
function! CocStatusSafe() abort
  if exists('*coc#status')
    return coc#status()
  endif
  return ''
endfunction

"==============================================================
" 1. 基础配置
"==============================================================
let g:coc_config_home = expand('~/.vim')

" 设置 coc-settings.json 文件类型为 jsonc（支持注释）
autocmd BufRead,BufNewFile coc-settings.json set filetype=jsonc

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

" 交给basic.vim处理
" set encoding=utf-8
" 某些语言服务器会因备份文件导致问题，见 #649
" set nobackup
" set nowritebackup

" updatetime 时间过长（默认 4000ms = 4s）会导致明显延迟和糟糕的用户体验
set updatetime=300

set signcolumn=yes

" 使用 Tab 键触发补全并导航
" 注意：默认总会有选中的补全项，你可以在配置文件里设置 `"suggest.noselect": true` 来不自动选中
" 注意：可以通过 `:verbose imap <tab>` 检查 Tab 是否被其它插件映射，确保此设置生效
inoremap <silent><expr> <TAB>
      \ CocLoaded() && coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ CocLoaded() ? coc#refresh() : "\<Tab>"
inoremap <expr><S-TAB> CocLoaded() && coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" 让 <CR> 接受当前选中的补全项或通知 coc.nvim 格式化
" <C-g>u 会中断当前撤销，根据需要选择是否保留
inoremap <silent><expr> <CR> CocLoaded() && coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=CocLoaded() ? coc#on_enter() : ''\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 使用 <c-space> 触发补全
if has('nvim')
  inoremap <silent><expr> <c-space> CocLoaded() ? coc#refresh() : "\<Nop>"
else
  inoremap <silent><expr> <c-@> CocLoaded() ? coc#refresh() : "\<Nop>"
endif

" 使用 `[g` 和 `]g` 导航诊断
" 使用 `:CocDiagnostics` 获取当前缓冲区所有诊断（在 location list 中展示）
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" 跳转到代码位置
" 跳转到定义
nmap <silent><nowait> gd <Plug>(coc-definition)
" 跳转到类型定义
nmap <silent><nowait> gy <Plug>(coc-type-definition)
" 跳转到实现
nmap <silent><nowait> gi <Plug>(coc-implementation)
" 跳转到引用
nmap <silent><nowait> gr <Plug>(coc-references)

" 使用 K 键在预览窗口显示文档
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if s:CocLoaded() && CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" 光标悬停时，高亮当前符号及其引用
autocmd CursorHold * silent call s:CocActionAsyncSafe('highlight')

" 符号重命名
nmap <leader>rn <Plug>(coc-rename)

" 格式化选中代码
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd! 
  " 针对指定 filetype 设置 formatexpr
  autocmd FileType typescript,json if s:CocLoaded() | setl formatexpr=CocAction('formatSelected') | endif
augroup end

" 对选中代码块应用 Code Action
" 示例：`<leader>aap` 针对当前段落应用
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" 应用于光标位置的代码操作
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" 应用于整个缓冲区的代码操作
nmap <leader>as  <Plug>(coc-codeaction-source)
" 对当前行诊断应用最优修复
nmap <leader>qf  <Plug>(coc-fix-current)

" 重构操作相关快捷键
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" 运行当前行的 Code Lens
nmap <leader>cl  <Plug>(coc-codelens-action)

" 映射函数及类文本对象
" 注意：要求语言服务器支持 'textDocument.documentSymbol'
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" 重映射 <C-f> 和 <C-b> 用于浮动窗口/弹窗滚动
" 当文档显示在浮动窗口中时，使用 <C-f> 向下滚动，<C-b> 向上滚动
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> CocLoaded() && exists('*coc#float#has_scroll') && coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> CocLoaded() && exists('*coc#float#has_scroll') && coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> CocLoaded() && exists('*coc#float#has_scroll') && coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> CocLoaded() && exists('*coc#float#has_scroll') && coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> CocLoaded() && exists('*coc#float#has_scroll') && coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> CocLoaded() && exists('*coc#float#has_scroll') && coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" 使用 <C-Up> 和 <C-Down> 滚动预览窗口/浮动窗口
" 优先检查浮动窗口，如果没有则检查预览窗口
function! s:ScrollDocumentation(direction) abort
  " 优先检查浮动窗口
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    if s:CocLoaded() && exists('*coc#float#has_scroll') && coc#float#has_scroll()
      " 向下滚动（direction=1）或向上滚动（direction=0）
      " 使用较小的滚动量（3行）以便精确控制
      call coc#float#scroll(a:direction ==# 'down' ? 1 : 0, 3)
      return mode() =~ '^i' ? "" : "\<Ignore>"
    endif
  endif
  
  " 检查预览窗口
  let l:preview_win = -1
  for l:winid in range(1, winnr('$'))
    if getwinvar(l:winid, '&previewwindow', 0)
      let l:preview_win = l:winid
      break
    endif
  endfor
  
  if l:preview_win != -1
    " 切换到预览窗口并滚动
    let l:cur_win = winnr()
    execute l:preview_win . 'wincmd w'
    if a:direction ==# 'down'
      execute "normal! 3\<C-e>"
    else
      execute "normal! 3\<C-y>"
    endif
    execute l:cur_win . 'wincmd w'
    return mode() =~ '^i' ? "" : "\<Ignore>"
  endif
  
  " 如果没有预览窗口或浮动窗口，执行默认行为
  return a:direction ==# 'down' ? "\<C-Down>" : "\<C-Up>"
endfunction

" 映射 <C-Up> 和 <C-Down> 用于滚动文档
" 正常模式和可视模式
nnoremap <silent><expr> <C-Up> <SID>ScrollDocumentation('up')
nnoremap <silent><expr> <C-Down> <SID>ScrollDocumentation('down')
vnoremap <silent><expr> <C-Up> <SID>ScrollDocumentation('up')
vnoremap <silent><expr> <C-Down> <SID>ScrollDocumentation('down')

" 插入模式：需要特殊处理
inoremap <silent><expr> <C-Up> <SID>ScrollDocumentation('up')
inoremap <silent><expr> <C-Down> <SID>ScrollDocumentation('down')

" 预览窗口滚动支持（其他方式）
" 如果文档显示在预览窗口中，还可以使用以下方式：
" 1. 切换到预览窗口：<C-w>p（按 Ctrl+w 然后按 p）
" 2. 在预览窗口中使用标准滚动命令：
"    - j/k: 逐行向下/向上滚动
"    - <C-d>/<C-u>: 半页向下/向上滚动
"    - <C-f>/<C-b>: 整页向下/向上滚动
"    - gg/G: 跳转到顶部/底部
" 3. 滚动完成后，按 <C-w>p 返回原窗口，或按 <C-w>w 在窗口间切换

" 使用 Ctrl-S 进行选择范围扩展
" 要求语言服务器支持 'textDocument/selectionRange'
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" 增加 :Format 命令格式化当前缓冲区
command! -nargs=0 Format :call s:CocActionAsyncSafe('format')

" 增加 :Fold 命令折叠当前缓冲区
command! -nargs=? Fold :call s:CocActionSafe('fold', <f-args>)

" 增加 :OR 命令用于组织当前文件的 import
command! -nargs=0 OR   :call s:CocActionAsyncSafe('runCommand', 'editor.action.organizeImport')

" 增加 (Neo)Vim 原生 statusline 支持
" 注意：参见 `:h coc-status`，集成外部美化插件（如 lightline.vim, vim-airline）
set statusline^=%{CocStatusSafe()}%{get(b:,'coc_current_function','')}

" CoCList 快捷键映射
" 使用 <leader>c 前缀（c 代表 Coc/Code），避免与 NERDTree 的 <leader>e 冲突
" 注意：<leader>cc 已被注释功能使用，改用 <leader>cl 表示 Commands List
" 显示所有诊断
nnoremap <silent><nowait> <leader>cd  :<C-u>if CocLoaded()<Bar>execute 'CocList diagnostics'<Bar>else<Bar>echohl WarningMsg<Bar>echomsg 'Coc 插件未安装'<Bar>echohl None<Bar>endif<cr>
" 管理扩展
nnoremap <silent><nowait> <leader>ce  :<C-u>if CocLoaded()<Bar>execute 'CocList extensions'<Bar>else<Bar>echohl WarningMsg<Bar>echomsg 'Coc 插件未安装'<Bar>echohl None<Bar>endif<cr>
" 显示命令列表（使用 cl 避免与注释功能的 cc 冲突）
nnoremap <silent><nowait> <leader>cl  :<C-u>if CocLoaded()<Bar>execute 'CocList commands'<Bar>else<Bar>echohl WarningMsg<Bar>echomsg 'Coc 插件未安装'<Bar>echohl None<Bar>endif<cr>
" 查找当前文档符号
nnoremap <silent><nowait> <leader>co  :<C-u>if CocLoaded()<Bar>execute 'CocList outline'<Bar>else<Bar>echohl WarningMsg<Bar>echomsg 'Coc 插件未安装'<Bar>echohl None<Bar>endif<cr>
" 全局查找工作区符号
nnoremap <silent><nowait> <leader>cs  :<C-u>if CocLoaded()<Bar>execute 'CocList -I symbols'<Bar>else<Bar>echohl WarningMsg<Bar>echomsg 'Coc 插件未安装'<Bar>echohl None<Bar>endif<cr>
" 下一个项目默认操作
nnoremap <silent><nowait> <leader>cj  :<C-u>if CocLoaded()<Bar>execute 'CocNext'<Bar>else<Bar>echohl WarningMsg<Bar>echomsg 'Coc 插件未安装'<Bar>echohl None<Bar>endif<CR>
" 上一个项目默认操作
nnoremap <silent><nowait> <leader>ck  :<C-u>if CocLoaded()<Bar>execute 'CocPrev'<Bar>else<Bar>echohl WarningMsg<Bar>echomsg 'Coc 插件未安装'<Bar>echohl None<Bar>endif<CR>
" 恢复最近一次的 coc 列表
nnoremap <silent><nowait> <leader>cp  :<C-u>if CocLoaded()<Bar>execute 'CocListResume'<Bar>else<Bar>echohl WarningMsg<Bar>echomsg 'Coc 插件未安装'<Bar>echohl None<Bar>endif<CR>

"==============================================================
" Go Linter 配置（个人配置隔离）
"==============================================================
" 辅助函数：安全加载配置文件
function! s:source_if_exists(path) abort
  if filereadable(a:path)
    execute 'source' fnameescape(a:path)
  endif
endfunction

" 加载 Go linter 个人配置
call s:source_if_exists(expand('~/.vim/config/plugins/go_linter.vim'))