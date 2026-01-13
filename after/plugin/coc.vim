" ============================================================================
" coc.nvim 插件配置
" 文件位置: ~/.vim/after/plugin/coc.vim
" 说明: 此文件会在所有插件加载后自动执行，用于配置 coc.nvim 插件
" ============================================================================

" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim
" 注意：g:coc_config_home 已在 vimrc.vim 中设置

" Vim（非 Neovim）可能需要，因为 coc.nvim 通过计算 utf-8 字节序列来计算字节偏移
set encoding=utf-8
" 某些服务器对备份文件有问题，参见 #649
set nobackup
set nowritebackup

" 更长的更新间隔（默认是 4000 毫秒 = 4 秒）会导致明显的延迟和糟糕的用户体验
set updatetime=300

" 始终显示标记列，否则每次诊断出现/解决时都会移动文本
set signcolumn=yes

" 使用 Tab 键触发补全并导航
" 注意：默认情况下总是有补全项被选中，你可能想要通过配置文件中设置
" `"suggest.noselect": true` 来启用不自动选择
" 注意：在将此配置放入你的配置文件之前，使用命令 ':verbose imap <tab>' 
" 来确保 Tab 键没有被其他插件映射
"
" CheckBackspace 函数必须在 Tab 映射之前定义
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" 使 <CR> 接受选中的补全项或执行正常换行
" 修复：移除 coc#on_enter() 调用，避免在某些位置阻塞 Enter 键
" coc#on_enter() 主要用于触发代码操作，不是必需的，移除后 Enter 键会更可靠
function! s:SmartCR() abort
  " 如果补全菜单可见，确认补全
  if exists('*coc#pum#visible') && coc#pum#visible()
    return coc#pum#confirm()
  endif
  
  " 否则执行正常的回车
  " <C-g>u 会中断当前的撤销操作，允许在插入模式下撤销
  " 移除 coc#on_enter() 调用，避免在某些位置（如 { 后、} 后）阻塞
  return "\<C-g>u\<CR>"
endfunction

inoremap <silent><expr> <CR> <SID>SmartCR()

" 使用 <c-space> 触发补全
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" 使用 `[g` 和 `]g` 导航诊断信息
" 使用 `:CocDiagnostics` 在位置列表中获取当前缓冲区的所有诊断信息
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" 代码导航
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" 使用 K 在预览窗口显示文档
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" 当光标停留时高亮符号及其引用
autocmd CursorHold * silent call CocActionAsync('highlight')

" 符号重命名
nmap <leader>rn <Plug>(coc-rename)

" 格式化选中的代码
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " 为指定的文件类型设置 formatexpr
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  
  " 注意：Go 文件的配置已移至 ~/.vim/ftplugin/go.vim
  " 这样可以更好地组织文件类型特定的配置
augroup end

" 对选中的代码块应用代码操作
" 示例：`<leader>aap` 用于当前段落
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" 重新映射键位以在光标位置应用代码操作
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" 重新映射键位以应用影响整个缓冲区的代码操作
nmap <leader>as  <Plug>(coc-codeaction-source)
" 应用最优先的 quickfix 操作来修复当前行的诊断问题
nmap <leader>qf  <Plug>(coc-fix-current)

" 重新映射键位以应用重构代码操作
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" 在当前行运行 Code Lens 操作
nmap <leader>cl  <Plug>(coc-codelens-action)

" 映射函数和类的文本对象
" 注意：需要语言服务器支持 'textDocument.documentSymbol'
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" 重新映射 <C-f> 和 <C-b> 来滚动浮动窗口/弹出窗口
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" 使用 CTRL-S 进行选择范围
" 需要语言服务器支持 'textDocument/selectionRange'
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" 添加 `:Format` 命令来格式化当前缓冲区
command! -nargs=0 Format :call CocActionAsync('format')

" 添加 `:Fold` 命令来折叠当前缓冲区
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" 添加 `:OR` 命令来整理当前缓冲区的导入
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" 添加 (Neo)Vim 原生的状态行支持
" 注意：请参阅 `:h coc-status` 了解与提供自定义状态行的外部插件的集成：
" lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" CoCList 的键位映射
" 显示所有诊断信息
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" 管理扩展
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
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

" ============================================================================
" coc.nvim 原生推荐安装功能（可选）
" ============================================================================
"
" coc.nvim 提供了原生功能来自动安装推荐的扩展
" 通过定义 g:coc_global_extensions 变量，coc.nvim 会在启动时自动检查并安装这些扩展
"
" 如果需要启用此功能，取消下面的注释并修改扩展列表：
"
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-snippets',
      \ 'coc-vimlsp',
      \ 'coc-sh',
      \ 'coc-yaml',
      \ '@yaegassy/coc-pylsp',
      \ 'coc-tsserver',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-eslint',
      \ 'coc-prettier',
      \ 'coc-clangd',
      \ 'coc-phpls',
      \ 'coc-vetur',
      \ 'coc-go'
      \ ]

" 扩展说明：
"   coc-json            - JSON 文件支持
"   coc-snippets        - 代码片段支持
"   coc-vimlsp          - Vim 脚本语言支持
"   coc-sh              - Shell 脚本支持
"   coc-yaml            - YAML 文件支持
"   @yaegassy/coc-pylsp - Python LSP（基于 Pylsp）
"   coc-tsserver        - JavaScript/TypeScript 语言支持
"   coc-html            - HTML 文件支持
"   coc-css             - CSS 文件支持
"   coc-eslint          - ESLint 代码检查集成
"   coc-prettier        - 代码格式化工具
"   coc-clangd          - C/C++ 语言支持（基于 clangd）
"   coc-phpls           - PHP 语言支持
"   coc-vetur           - Vue.js 框架支持（支持 Vue 2 和 Vue 3）
"   coc-go              - Go 语言支持（LSP）
"
" 注意：
" - 此功能会在 coc.nvim 启动时自动安装未安装的扩展
" - 如果不想自动安装，可以保持注释状态，手动执行 :CocInstall <扩展名>
" - 与 coc-settings.json 中的 extensionAutoUpdate 不同：
"   * g:coc_global_extensions: 控制首次安装哪些扩展
"   * extensionAutoUpdate: 控制已安装扩展是否自动更新

