" ~/.vim/config/mappings.vim
" ========================
" 高效键位映射
" 原则：
" 1. 高频操作优先
" 2. 避免与插件冲突
" 3. 符合肌肉记忆
" ========================

" 确保只加载一次
if exists('g:loaded_mappings_config')
    finish
endif
let g:loaded_mappings_config = 1

" ===================================================
" F1 - F12 区域
" ===================================================

" 快速切换相对行号
function! ToggleRelativeNumber()
    if &relativenumber
        set norelativenumber
    else
        set relativenumber
    endif
endfunction
nnoremap <F8> :call ToggleRelativeNumber()<CR>

" 切换主题
" <F4> 占用 to theme.vim
nnoremap <silent> <F4> :call ToggleThemeMode()<CR>

" 分析启动时间
nnoremap <F12> :StartupTime<CR>

" ===================================================
" 基础编辑映射
" ===================================================

" === 文件操作 ===
nnoremap <leader>w :w<CR>                  " 快速保存
nnoremap <leader>q :q<CR>                  " 安全退出
nnoremap <leader>Q :qa!<CR>                " 强制退出
nnoremap <leader>s :wq<CR>                 " 保存并退出

" === 缓冲区管理 ===
nnoremap <silent> <leader>bn :bn<CR>       " 下一个缓冲区
nnoremap <silent> <leader>bp :bp<CR>       " 上一个缓冲区
nnoremap <silent> <leader>bd :bd<CR>       " 关闭当前缓冲区
nnoremap <leader>bl :buffers<CR>           " 列出缓冲区

" ===================================================
" 窗口管理映射
" ===================================================

" === 窗口导航 ===
nnoremap <C-h> <C-w>h                      " 向左切换窗口
nnoremap <C-j> <C-w>j                      " 向下切换窗口
nnoremap <C-k> <C-w>k                      " 向上切换窗口
nnoremap <C-l> <C-w>l                      " 向右切换窗口

" === 窗口调整 ===
nnoremap <silent> <C-Left> :vertical resize -5<CR>
nnoremap <silent> <C-Right> :vertical resize +5<CR>
nnoremap <silent> <C-Up> :resize -5<CR>
nnoremap <silent> <C-Down> :resize +5<CR>

" === 窗口创建 ===
nnoremap <leader>v :vsplit<CR>             " 垂直分割
nnoremap <leader>h :split<CR>              " 水平分割
nnoremap <leader>o :only<CR>               " 关闭其他窗口

" ===================================================
" 搜索与替换
" ===================================================

" === 搜索优化 ===
nnoremap <silent> <leader>/ :nohlsearch<CR>" 取消高亮
nnoremap n nzz                             " 搜索结果居中
nnoremap N Nzz
vnoremap // y/<C-R>"<CR>                   " 可视化模式搜索选中文本

" === 全局替换 ===
nnoremap <leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>
xnoremap <leader>r "sy:%s/<C-r>s//g<Left><Left>

" ===================================================
" 代码操作增强
" ===================================================

" === 代码折叠 ===
" 切换折叠
nnoremap <space> za
" 创建折叠
vnoremap <space> zf

" === 快速跳转 ===
nnoremap gb `[                            " 跳转到上次编辑位置
nnoremap <leader>j :%!python -m json.tool<CR> " 格式化JSON

" === 注释切换 ===
" nmap <leader>c <Plug>CommentaryLine       " 需要vim-commentary插件
" xmap <leader>c <Plug>Commentary

" 需要vim-commentary插件
nmap <C-/> <Plug>CommentaryLine
xmap <C-/> <Plug>Commentary

" ===================================================
" 特殊模式优化(奇奇怪怪)
" ===================================================

" === 命令行模式 ===
cnoremap <C-a> <Home>                     " 行首
cnoremap <C-e> <End>                      " 行尾
cnoremap <C-p> <Up>                       " 历史记录上一条
cnoremap <C-n> <Down>                     " 历史记录下一条

" === 插入模式 ===
" inoremap jk <ESC>                         " 快速退出插入模式
" 移动光标
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" ===================================================
" 特自定义功能键（后续换到功能区）
" ===================================================

" === 实用功能 ===
nnoremap <leader>ev :vsplit $MYVIMRC<CR>  " 编辑vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>  " 重载配置

" 切换相对行号
nnoremap <silent> <leader>rn :set relativenumber!<CR>

" 清除行尾空格
nnoremap <leader>cw :%s/\s\+$//<CR>:let @/=''<CR>

" 检查未使用的键位（需要插件）
" nnoremap <leader>ck :map<CR>

" ===================================================
" 会话管理（依赖插件）
" ===================================================

nnoremap <leader>ss :SaveSession<CR>
nnoremap <leader>sl :OpenSession<space>
nnoremap <leader>sd :DeleteSession<CR>

" 模糊查找会话文件（依赖 fzf.vim）
" nnoremap <leader>fs :execute 'OpenSession ' . fzf#run({'source': 'ls ~/.vim/.sessions', 'sink': 'OpenSession'})<CR>

" ===================================================
" coc.nvim 快捷键映射
" ===================================================

" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

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
" 补全导航
inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
" 回车确认补全项，<C-g>会中断当前补全
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
" 使用空格键触发完成操作
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
" “使用 `[g` 和 `]g` 进行诊断内容的导航
" 使用 `:CocDiagnostics` 可获取当前缓冲区的所有诊断信息（以位置列表的形式呈现）”
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
" “GoTo 代码导航”
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" Use K to show documentation in preview window
" 使用 K 键可在预览窗口中显示文档内容。
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor
" “当鼠标指针悬停在符号上时，突出显示该符号及其相关内容。”
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
" 符号重命名
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
" 格式化选定的代码
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s)
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
" “对选定的代码块应用代码操作”
" “示例：对于当前段落，输入‘<leader>aap’”
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
" “重新设置按键，以便在光标位置执行代码操作”
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
" 重新设置按键以应用代码重构操作
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
" 在当前行运行代码镜像操作。
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
" “映射函数和文本对象类”
" “注意：需要语言服务器支持‘文本文档的文档符号’功能”
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
" 将 <C-f> 和 <C-b> 键重新映射为用于滚动浮动窗口/弹出窗口的操作。
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
" “使用 Ctrl-S 来选择范围。”
" “需要语言服务器支持‘文本文档/选择范围’功能。”
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
" “添加 `:Format` 命令以格式化当前缓冲区”
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
" “添加 `:Fold` 命令以折叠当前缓冲区”
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
" “添加 `:OR` 命令，用于对当前缓冲区的导入操作进行分类整理”
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
" “添加（Neo）Vim 的原生状态栏支持”
" “注意：有关与提供自定义状态栏的外部插件（如 lightline.vim、vim-airline）的集成，请参阅 `:h coc-status` 。”
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" set statusline^=%{coc#status()}

" Mappings for CoCList
" Show all diagnostics
" CoCList 的映射
" 显示所有诊断信息
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
" 管理扩展程序
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
" 显示命令
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
" 查找当前文档的符号
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
" 搜索工作区符号
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
" 对下一项执行默认操作
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
" 执行上一项的默认操作
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
" 更新最新的合作方列表
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
