"==============================================================
" config/plugins/lsp_coc.vim
" LSP 配置：coc.nvim 语言服务器协议
"==============================================================

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

if exists('g:loaded_lsp_coc_config')
  finish
endif
let g:loaded_lsp_coc_config = 1

" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

" Vim（非 Neovim）可能需要，因为 coc.nvim 通过计算 utf-8 字节序列来计算字节偏移
set encoding=utf-8
" 某些语言服务器会因备份文件导致问题，见 #649
"set nobackup
"set nowritebackup

" updatetime 时间过长（默认 4000ms = 4s）会导致明显延迟和糟糕的用户体验
set updatetime=300

" 始终显示 signcolumn，否则每次诊断出现/解决时文本会移位
set signcolumn=yes

" 补全菜单不自动选中第一项
" 注意：completeopt 已在 basic.vim 中设置（同步加载）
" 使用 autocmd 确保在 coc.nvim 初始化后也设置一次（作为备用）
augroup CocNoselectConfig
  autocmd!
  " 在 coc.nvim 初始化后设置配置
  autocmd User CocNvimInit call coc#config('suggest.noselect', v:true)
  " 如果上述事件不存在，在 VimEnter 时尝试设置（延迟确保 coc.nvim 已加载）
  autocmd VimEnter * call timer_start(500, {-> s:EnsureCocNoselect()})
augroup END

" 辅助函数：确保 suggest.noselect 配置已设置
function! s:EnsureCocNoselect() abort
  if exists('*coc#config')
    call coc#config('suggest.noselect', v:true)
  endif
endfunction

" 立即尝试设置（如果 coc.nvim 已经加载）
if exists('*coc#config')
  call s:EnsureCocNoselect()
endif

" 全局函数：安全地获取补全菜单的当前选中索引（用于 <expr> 映射）
function! GetPumIndex() abort
  if !exists('*coc#pum#info')
    return -1
  endif
  try
    let info = coc#pum#info()
    return has_key(info, 'index') ? info['index'] : -1
  catch
    return -1
  endtry
endfunction

" 使用 Tab 键触发补全并导航
" 注意：当补全菜单可见但没有选中项时，先选中第一项；否则移动到下一项
" 注意：可以通过 `:verbose imap <tab>` 检查 Tab 是否被其它插件映射，确保此设置生效
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" 让 <CR> 接受当前选中的补全项或通知 coc.nvim 格式化
" <C-g>u 会中断当前撤销，根据需要选择是否保留
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 使用 <c-space> 触发补全
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" 使用 `[g` 和 `]g` 导航诊断
" 使用 `:CocDiagnostics` 获取当前缓冲区所有诊断（在 location list 中展示）
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" 跳转到代码位置
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" 使用 K 键在预览窗口显示文档
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" 光标悬停时，高亮当前符号及其引用
autocmd CursorHold * silent call CocActionAsync('highlight')

" 符号重命名
nmap <leader>rn <Plug>(coc-rename)

" 格式化选中代码
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " 针对指定 filetype 设置 formatexpr
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" 对选中代码块应用 Code Action
" 示例：`<leader>aap` 针对当前段落应用
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" 重映射按键以在光标位置应用代码操作
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" 重映射按键以对整个缓冲区应用代码操作
nmap <leader>as  <Plug>(coc-codeaction-source)
" 对当前行诊断应用最优修复
nmap <leader>qf  <Plug>(coc-fix-current)

" 重映射按键以应用重构代码操作
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" 运行当前行的 Code Lens 操作
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

" 重映射 <C-f> 和 <C-b> 用于滚动浮动窗口/弹窗
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" 使用 CTRL-S 进行选择范围扩展
" 要求语言服务器支持 'textDocument/selectionRange'
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" 增加 :Format 命令格式化当前缓冲区
command! -nargs=0 Format :call CocActionAsync('format')

" 增加 :Fold 命令折叠当前缓冲区
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" 增加 :OR 命令用于组织当前文件的 import
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" 调试命令：检查补全配置
command! -nargs=0 CocCheckConfig call s:CocCheckConfig()

function! s:CocCheckConfig() abort
  echo '=== 补全配置检查 ==='
  echo 'completeopt: ' . &completeopt
  if exists('*coc#config')
    try
      " coc#config() 读取配置时需要提供默认值作为第二个参数
      let noselect = coc#config('suggest.noselect', v:false)
      echo 'suggest.noselect: ' . noselect . ' (类型: ' . type(noselect) . ')'
    catch
      echo 'suggest.noselect: 读取失败 - ' . v:exception
    endtry
  else
    echo 'suggest.noselect: coc#config 函数不存在'
  endif
  if exists('*coc#pum#visible')
    echo 'coc#pum#visible(): ' . coc#pum#visible()
    if coc#pum#visible()
      try
        let info = coc#pum#info()
        " 安全地访问字典键，避免键不存在时报错
        let index = has_key(info, 'index') ? info['index'] : 'N/A'
        let size = has_key(info, 'size') ? info['size'] : 'N/A'
        echo 'coc#pum#info(): index=' . index . ', size=' . size
        " 显示所有可用的键（用于调试）
        echo 'coc#pum#info() 所有键: ' . string(keys(info))
      catch
        echo 'coc#pum#info(): 读取失败 - ' . v:exception
      endtry
    endif
  else
    echo 'coc#pum#visible(): 函数不存在'
  endif
  if exists('g:coc_user_config')
    echo 'g:coc_user_config: ' . string(g:coc_user_config)
  else
    echo 'g:coc_user_config: 未设置'
  endif
endfunction

" 增加 (Neo)Vim 原生 statusline 支持
" 注意：参见 `:h coc-status`，集成外部美化插件（如 lightline.vim, vim-airline）
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" CoCList 快捷键映射
" 显示所有诊断
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" 管理扩展
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" 显示命令列表
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" 查找当前文档符号
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" 全局查找工作区符号
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" 下一个项目默认操作
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" 上一个项目默认操作
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" 恢复最近一次的 coc 列表
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
