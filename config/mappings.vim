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

" F1 - F12 键位映射
" F1    " 帮助文档(默认)
" F2    " 切换相对行号
" F3
" F4    " 切换主题
" F5
" F6
" F7
" F8    " 代码大纲 依赖vista 配置在 config/plug-vista.vim
" F9
" F10
" F11
" F12

" F2 切换行号
nnoremap <silent> <F2> :call ToggleNumberMode()<CR>
" F4 切换主题
nnoremap <silent> <F4> :call ToggleThemeMode()<CR>
" F8 代码大纲 依赖vista 配置在 config/plug-vista.vim
nnoremap <silent> <F8> :Vista!!<CR>

" ===================================================
" F1 - F1 2实现函数
" ===================================================

" F2 快速切换相对行号 实现
let g:number_toggle_state = 1 " 1=显示绝对行号, 2=显示相对行号, 0=隐藏行号
function! ToggleNumberMode()
    if g:number_toggle_state == 1
        " 当前显示绝对行号，切换到相对行号
        set relativenumber
        let g:number_toggle_state = 2
        echo "显示相对行号"
    elseif g:number_toggle_state == 2
        " 当前显示相对行号，切换到隐藏行号
        set nonumber
        set norelativenumber
        let g:number_toggle_state = 0
        echo "隐藏行号"
    else
        " 当前隐藏行号，切换到绝对行号
        set number
        set norelativenumber
        let g:number_toggle_state = 1
        echo "显示绝对行号"
    endif
endfunction

" F4 切换主题模式 实现
function! ToggleThemeMode()
    if g:theme_mode ==# 'dark'
        let g:theme_mode = 'light'
    else
        let g:theme_mode = 'dark'
    endif
    execute 'set background=' . g:theme_mode
endfunction

" ===================================================
" 基础编辑映射
" ===================================================

" 不带前缀的映射
" a 插入模式
" b 移动到上一个单词开头
" c 删除并进入 Insert 模式
" d 删除操作符
" e 移动到当前单词末尾
" f 正向查找字符
" g 移动前缀命令
    " 代码导航跳转 依赖coc
    " gd 跳转到函数定义
    " dy 跳转到类型定义
    " di 跳转到接口实现
    " gr 列出所有引用
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)
" h 向左移动一个字符
" i 在光标前进入 Insert 模式
" j 向下移动一行
" k 向上移动一行
" K 显示文档内容 依赖coc
nnoremap <silent> K :call ShowDocumentation()<CR>
" l 向右移动一个字符
" m 标记位置
" n 重复上一次搜索
nnoremap n nzz
nnoremap N Nzz
" o 在下方新行进入 Insert 模式
" p 粘贴到光标后
" q 录制宏
" r 替换单个字符
" s 删除字符并进入 Insert 模式
" t 移动到目标字符前
" u 撤销上一次操作
" w 移动到下一个单词开头
" x 删除当前字符
" y 复制操作符
" z 屏幕滚动前缀


" leader 键位映射
" let mapleader = '\\' " 设置 leader 键为 \ (默认)
" a
    " ac 修复/重构
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
    " as 模块管理、批量重构、导入优化
nmap <leader>as  <Plug>(coc-codeaction-source)
    " aq 快速修复
nmap <leader>aq  <Plug>(coc-fix-current)
    " b 缓冲区管理
nnoremap <silent> <leader>bn :bn<CR>       " 下一个缓冲区
nnoremap <silent> <leader>bp :bp<CR>       " 上一个缓冲区
nnoremap <silent> <leader>bd :bd<CR>       " 关闭当前缓冲区
        " 列出缓冲区
nnoremap <leader>bl :buffers<CR>
" c 代码透镜
nmap <leader>cl  <Plug>(coc-codelens-action)
" cc 代码注释 依赖 nerdcommenter 插件
" nnoremap <leader>cc :NERDCommenterToggle<CR>
" d
" db 调试，打印当前高亮组 函数实现在下方
nnoremap <leader>db :call PrintSyntaxGroup()<CR>
" e
" f fzf 模糊搜索 配置原因，原配置留在 config/plug-fzf.vim
"     " 文件模糊搜索
" nnoremap <leader>ff :Files<CR>
"     " Git 文件
" nnoremap <leader>fg :GFiles<CR>
"     " 搜索内容（使用 rg）
" nnoremap <leader>fa :Rg<CR>
"     " 打开 buffer
" nnoremap <leader>fb :Buffers<CR>
"     " 书签
" nnoremap <leader>fm :Marks<CR>
"     " 历史
" nnoremap <leader>fh :History<CR>
" g
    " 注释相关 依赖 tcomment_vim 插件
    " gcc 注释当前行
    " gcc
    " gc 注释选中区域
    " gc
" nnoremap <leader>cl :Commentary<CR>
" h
" i
" j
" k
" l
" m
" n
" o
" p
" q 安全退出
" nnoremap <leader>q :q<CR>
" nnoremap <leader>Q :qa!<CR>
" r 重命名 依赖coc
nmap <leader>rn <Plug>(coc-rename)
" s 会话管理
nnoremap <leader>ss :SaveSession
nnoremap <leader>sl :OpenSession<space>
nnoremap <leader>sd :DeleteSession<CR>
" t 代码注释 依赖 nerdcommenter 插件
nmap <leader>tt <Plug>NERDCommenterToggle
vmap <leader>tt <Plug>NERDCommenterToggle
" u
" v
" w 退出
" nnoremap <leader>w :w<CR>
" x
" y
" 复制到系统剪贴板
map <Leader>y "+y
" z
" [ 上一个错误位置 依赖coc
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
" ] 下一个错误位置 依赖coc
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" Ctrl 键位映射
" a
" b
" c
" d
" e
" f
" g
" h 向左切换窗口
nnoremap <C-h> <C-w>h
" i
" j 向上切换窗口
nnoremap <C-j> <C-w>j
" k 向下切换窗口
nnoremap <C-k> <C-w>k
" l 向右切换窗口
nnoremap <C-l> <C-w>l
" m
" n
" o
" p
" q
" r
" s 智能选择范围 依赖coc
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
" t
" u
" v
" w
" x
" y
" z
" <left>
nnoremap <silent> <C-Left> :vertical resize -5<CR>
" <right>
nnoremap <silent> <C-Right> :vertical resize +5<CR>
" <up>
nnoremap <silent> <C-Up> :resize -5<CR>
" <down>
nnoremap <silent> <C-Down> :resize +5<CR>

" / 注释功能 依赖 vim-commentary 插件, 移动到 plug-commentary.vim
" nmap <C-/> <Plug>CommentaryLine
" xmap <C-/> <Plug>Commentary
" nmap <C-/> gcc
" xmap <C-/> gc
nmap <C-/> <Plug>NERDCommenterToggle
vmap <C-/> <Plug>NERDCommenterToggle
" nmap <M-c> <Plug>NERDCommenterToggle
" vmap <M-c> <Plug>NERDCommenterToggle

" ===================================================
" 其他按键映射
" ===================================================

" <space> 空格映射
" === 代码折叠 ===
" 切换折叠
nnoremap <space> za
" 创建折叠 手动折叠有效
vnoremap <space> zf

" <C-x> 补全导航 插入模式下使用(原生)
" 1. 基础补全类型
" 快捷键	    补全类型	    说明
" <C-x><C-n>	普通关键字补全	当前缓冲区中的单词（同 <C-n>）
" <C-x><C-f>	文件名补全	    文件系统路径（输入 / 可触发目录补全）
" <C-x><C-l>	整行补全	    补全整行内容（从当前缓冲区）
" <C-x><C-]>	标签补全	    从 tags 文件补全（需提前生成 tags）
" 2. 编程专用补全
" 快捷键	    补全类型	    说明
" <C-x><C-o>	Omni 补全	    文件类型相关的智能补全（需配置 omnifunc，如 Python 需 set omnifunc=python3complete#Complete）
" <C-x><C-k>	字典补全	    从 dictionary 选项定义的字典文件补全
" <C-x><C-t>	同义词补全	    从 thesaurus 选项定义的同义词词典补全
" 3. 特殊补全方式
" 快捷键	    补全类型	    说明
" <C-x><C-i>	包含文件补全	从 include 路径的文件中补全（如 C 的头文件）
" <C-x><C-d>	定义补全	    补全宏定义或常量（如 C 的 #define）
" <C-x><C-v>	Vim 命令补全	补全 Ex 命令（如 :echo）
" <C-x><C-u>	用户自定义补全	调用 completefunc 定义的补全函数
" <C-x><C-s>	拼写建议补全	从拼写检查词典中补全（需启用 set spell）
" 4. 组合补全
" 快捷键	    说明
" <C-x><C-x>	重复上次补全类型（例如：先用 <C-x><C-f> 补全文件名，再按此键继续补全）
" <C-x>s	    从所有来源的补全菜单中混合选择（需 set completeopt+=menuone）
" 5. 补全控制键
" 快捷键	    作用
" <C-n>	    选择下一个补全项（无需先按 <C-x>）
" <C-p>	    选择上一个补全项
" <C-y>	    确认当前补全项
" <C-e>	    取消补全并恢复原始输入


" ===================================================
" coc.nvim 快捷键映射
" ===================================================
" <tab>补全导航
" 回车确认补全项，没有补全则正常回车，然后插入一个undo点
inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    " inoremap <silent><expr> <c-@> coc#refresh() " 官方文档，但是没生效，如果下面那行配置无效，再切换回来试试
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" 使用 `:CocDiagnostics` 可获取当前缓冲区的所有诊断信息（以位置列表的形式呈现）”
" nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
" nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" “GoTo 代码导航”
" 已移动到上方
" nmap <silent><nowait> gd <Plug>(coc-definition)
" nmap <silent><nowait> gy <Plug>(coc-type-definition)
" nmap <silent><nowait> gi <Plug>(coc-implementation)
" nmap <silent><nowait> gr <Plug>(coc-references)

" 使用 K 键可在预览窗口中显示文档内容。
" 已移动到上方 实现函数留在这里
" nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

" 当鼠标指针悬停在符号上时，突出显示该符号及其相关内容
" 更正，当鼠标点击某个符号时，突出显示该符号及其相关内容。
autocmd CursorMoved,CursorHold * silent! call CocActionAsync('highlight')
" autocmd InsertEnter * silent! call CocAction('clearHighlight') " 插入模式取消高亮
" 调试用
" autocmd CursorHold * echom 'CursorHold triggered'

" 重命名 较为安全 已移动到上方
" nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s)
    " 自动设置格式化表达式
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" 跳转到上一个/下一个错误位置，包括以下类型
    " 错误（Error）
    " 警告（Warning）
    " 提示（Information）
    " 建议（Hint）
" 已移动到最上方
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

"""" 这部分关于代码修复等操作
" 光标位于需要修复/重构的代码处
" 修复/重构 已移动到上方
" nmap <leader>ac  <Plug>(coc-codeaction-cursor)

" 模块管理、批量重构、导入优化 已移动到上方
" nmap <leader>as  <Plug>(coc-codeaction-source)
" 快速修复 已移动到上方
" nmap <leader>aq  <Plug>(coc-fix-current)

" 在当前行运行代码镜像操作。
" 触发代码透镜
" nmap <leader>cl  <Plug>(coc-codelens-action)

" “映射函数和文本对象类”
" “注意：需要语言服务器支持‘文本文档的文档符号’功能”

"""" 函数相关选择 使用场景比较抽象 先不移动
" xmap 可视化模式
" omap 操作符模式 如：d a w 等
" 可视化模式选择函数内部内容
xmap if <Plug>(coc-funcobj-i)
" 操作符模式选择函数内部
omap if <Plug>(coc-funcobj-i)
" 选择函数包括声明和花括号
xmap af <Plug>(coc-funcobj-a)
" 操作符模式下选择完整函数
omap af <Plug>(coc-funcobj-a)

"""" 类相关选择
" 选择类/结构体内部成员（不包含大括号和声明）
xmap ic <Plug>(coc-classobj-i)
" 操作符模式下选择类内部
omap ic <Plug>(coc-classobj-i)
" 选择整个类/结构体（含声明和花括号）
xmap ac <Plug>(coc-classobj-a)
" 操作符模式下选择完整类
omap ac <Plug>(coc-classobj-a)

" 浮动窗口的操作 使用场景较少 暂不动
if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" 智能选择范围 已移动到上方
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" :Format 命令
" 格式化当前缓冲区
command! -nargs=0 Format :call CocActionAsync('format')

" Fold 命令
" :Fold 命令用于折叠当前缓冲区
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" OR 命令
" :OR 命令用于组织导入
" 该命令会自动优化当前文件的导入语句
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" 添加（Neo）Vim 的原生状态栏支持
" 注意：有关与提供自定义状态栏的外部插件（如 lightline.vim、vim-airline）的集成，请参阅 `:h coc-status` 。
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" 不常用 暂不移动
" 显示所有诊断信息
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" 管理扩展程序
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" 显示命令
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" 查找当前文档的符号
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" 搜索工作区符号
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" 对下一项执行默认操作
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" 执行上一项的默认操作
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" 更新最新的合作方列表
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" ===================================================
" 函数实现
" ===================================================

" 查看当前高亮组（调试用）
function! PrintSyntaxGroup()
    let l:line = line('.')
    let l:col = col('.')
    " echo 'Syntax groups at cursor:'
    echo map(synstack(l:line, l:col), 'synIDattr(v:val, "name")')
    " echo 'Current commentstring: ' . &commentstring
endfunction

