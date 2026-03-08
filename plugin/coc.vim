if exists('g:loaded_coc') || &compatible
  finish
else
  let g:loaded_coc = 'yes'
endif

" =======================================================
" [coc.nvim] 智能补全与 LSP 配置
" =======================================================
" 来源: https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

" --- [基础设置] ---
" 指定 coc.nvim 配置文件路径（与 g:vim_dir 一致：Win=vimfiles，Linux=.vim）
let g:coc_config_home = g:vim_dir

" Vim (非 Neovim) 需要设置 UTF-8 编码，因为 coc.nvim 通过字节序列计算偏移量
set encoding=utf-8

" 某些语言服务器对备份文件有问题，禁用备份
set nobackup
set nowritebackup

" 始终显示符号列，否则每次诊断出现/消失时文本会移位
set signcolumn=yes

" --- [补全触发与导航] ---
" 使用 Tab 键触发补全并导航
" 注意：默认总是选中补全项，如需禁用可在配置文件中设置 "suggest.noselect": true
" 注意：使用命令 ':verbose imap <tab>' 确保 Tab 键未被其他插件映射
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
" Shift+Tab 选择上一项
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" 使用 Enter 键接受选中的补全项或通知 coc.nvim 格式化
" <C-g>u 会中断当前撤销，请根据自己需求选择
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" 检查光标前是否为空格
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 使用 Ctrl+Space 触发补全
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  " Vim 中使用 Ctrl+@ (等价于 Ctrl+Space)
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" --- [诊断导航] ---
" 使用 [g 和 ]g 导航诊断错误
" 使用 :CocDiagnostics 获取当前缓冲区所有诊断信息到位置列表
" 上一个诊断错误
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
" 下一个诊断错误
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" --- [代码导航] ---
" GoTo 代码导航快捷键
nmap <silent><nowait> gd <Plug>(coc-definition)         " 跳转到定义
nmap <silent><nowait> gy <Plug>(coc-type-definition)    " 跳转到类型定义
nmap <silent><nowait> gi <Plug>(coc-implementation)     " 跳转到实现
nmap <silent><nowait> gr <Plug>(coc-references)        " 查看所有引用

" --- [文档查看] ---
" 使用 K 键在预览窗口显示文档
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    " 如果有悬浮文档提供者，显示悬浮文档
    call CocActionAsync('doHover')
  else
    " 否则使用默认的 K 键行为
    call feedkeys('K', 'in')
  endif
endfunction

" --- [符号重命名] ---
" 重命名符号
nmap <leader>rn <Plug>(coc-rename)

" --- [代码格式化] ---
" 格式化选中的代码
" 可视化模式
xmap <leader>f  <Plug>(coc-format-selected)
" 普通模式
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " 为指定文件类型设置格式化表达式
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" --- [代码操作] ---
" 对选中的代码块应用代码操作
" 示例：`<leader>aap` 对当前段落应用操作
" 可视化模式
xmap <leader>a  <Plug>(coc-codeaction-selected)
" 普通模式
nmap <leader>a  <Plug>(coc-codeaction-selected)

" 在光标位置应用代码操作
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" 对整个缓冲区应用代码操作
nmap <leader>as  <Plug>(coc-codeaction-source)
" 应用最优先的快速修复操作来修复当前行的诊断错误
nmap <leader>qf  <Plug>(coc-fix-current)

" --- [重构操作] ---
" 应用重构代码操作
" 重构当前
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
" 重构选中（可视化）
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
" 重构选中（普通）
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" --- [Code Lens] ---
" 在当前行运行 Code Lens 操作
nmap <leader>cl  <Plug>(coc-codelens-action)

" --- [文本对象映射] ---
" 映射函数和类的文本对象
" 注意：需要语言服务器支持 'textDocument.documentSymbol'
" 内部函数（可视化）
xmap if <Plug>(coc-funcobj-i)
" 内部函数（操作符）
omap if <Plug>(coc-funcobj-i)
" 整个函数（可视化）
xmap af <Plug>(coc-funcobj-a)
" 整个函数（操作符）
omap af <Plug>(coc-funcobj-a)
" 内部类（可视化）
xmap ic <Plug>(coc-classobj-i)
" 内部类（操作符）
omap ic <Plug>(coc-classobj-i)
" 整个类（可视化）
xmap ac <Plug>(coc-classobj-a)
" 整个类（操作符）
omap ac <Plug>(coc-classobj-a)

" --- [浮动窗口滚动] ---
" 重新映射 <C-f> 和 <C-b> 来滚动浮动窗口/弹出窗口
if has('nvim-0.4.0') || has('patch-8.2.0750')
  " 向下滚动
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  " 向上滚动
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" --- [选择范围] ---
" 使用 CTRL-S 进行选择范围
" 需要语言服务器支持 'textDocument/selectionRange'
" 普通模式
nmap <silent> <C-s> <Plug>(coc-range-select)
" 可视化模式
xmap <silent> <C-s> <Plug>(coc-range-select)

" 添加 `:Format` 命令，以格式化当前缓冲区
command! -nargs=0 Format :call CocActionAsync('format')

" 添加 `:OR` 命令，用于整理（organize）当前缓冲区的导入语句
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" 添加 (Neo)Vim 原生的状态栏支持
" 注意：请参阅 `:h coc-status`，以了解与外部状态栏插件（如 vim-airline）的集成方式
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" --- [CoCList 映射] ---
" 显示所有诊断错误
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" 管理扩展
"nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" 显示命令
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" 查找当前文档的符号
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" 搜索工作区符号
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" 对下一项执行默认操作
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" 对上一项执行默认操作
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" 恢复最新的 coc 列表
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"" 附加

" --- [设置 coc-settings.json 为 jsonc 格式] ---
augroup jsonc_detect
  autocmd!
  autocmd BufRead,BufNewFile coc-settings.json setfiletype jsonc
augroup END

let g:coc_config_home = g:vim_dir

let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-go',
      \ 'coc-yaml',
      \ 'coc-vimlsp',
      \ 'coc-snippets',
      \ 'coc-marketplace',
      \ 'coc-clangd',
      \ 'coc-pyright',
      \ '@yaegassy/coc-ruff',
      \ 'coc-tsserver',
      \ ]

" 2. 平台特定判断
" 如果 【不是】 Windows 系统，才加入 coc-sh / coc-lua
if !has('win32') && !has('win64')
    call add(g:coc_global_extensions, 'coc-sh')
    call add(g:coc_global_extensions, 'coc-lua')
endif
