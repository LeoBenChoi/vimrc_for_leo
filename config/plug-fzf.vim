" ========================
" fzf 配置
" 功能：搜索
" ========================

" 确保只加载一次
if exists('g:plug_load_fzf')
    finish
endif
let g:plug_load_fzf = 1

"""" 注意：根据官方文档 fzf_vim 的配置是放在初始化里面的
" 所以下面的配置只能在初始化之后

" ========================
" 初始化
" ========================

let g:fzf_vim = {}

" ========================
" 窗口
" ========================

" 右侧显示50%宽度的预览窗口，用Ctrl+/切换显隐
" let g:fzf_vim.preview_window = ['right,50%', 'ctrl-/']
" 响应式预览：默认隐藏，右侧50%宽，小屏时顶部40%高 windows 失效，暂不使用
" let g:fzf_vim.preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-/']
" 完全禁用预览窗口
" let g:fzf_vim.preview_window = []
" 主窗口显示在屏幕下方，高度约30% 【兼容性问题，只能选择显示在下方】
let g:fzf_layout = { 'down': '~30%' }
" 最终方案 [ AI 推荐 ]
" let g:fzf_layout = {
"             \ 'window': {
"             \   'width': 0.9,
"             \   'height': 0.6,
"             \   'xoffset': 0.5,
"             \   'yoffset': 0.5,
"             \   'highlight': 'Comment',
"             \   'border': 'sharp'
"             \ }}

" ========================
" 命令级选项
" ========================

" 智能搜索缓冲区，防止重复打开窗口
let g:fzf_vim.buffers_jump = 1

" [Ag|Rg|RG] 对于窄屏幕，将显示路径放在单独的一行上（默认值：0）
" * 需要 Perl 和 fzf 0.56.0 或更高版本
" 模式    适用场景                屏幕宽度要求    性能影响
" 0       快速搜索/低分辨率终端   无              最快
" 1       平衡可读性和效率        ≥40 字符        中等
" 2       详细调试/复杂代码库     ≥60 字符        最慢
let g:fzf_vim.grep_multi_line = 0
"   PATH:LINE:COL:LINE
"   路径：行：列：行
" let g:fzf_vim.grep_multi_line = 1
"   路径：行：列：
"   行
" let g:fzf_vim.grep_multi_line = 2
"   路径：行：列：
"   行
"   （使用 --gap 选项时，各项之间使用换行符隔开）

" 定义 fzf.vim 插件 在执行 :Commits 或 :BCommits 命令时，Git 提交历史的显示格式和样式
" 优化 git log 显示
let g:fzf_vim.commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [标签] 生成标签文件的指令 为了安全性，默认情况下不启用
" 需要在 Vim 中使用 :Tags 命令来生成标签文件
let g:fzf_vim.tags_command = 'ctags -R &'

" [命令] -- 用于直接执行命令的预期表达式
" 允许 alt-enter 和 ctrl-x 触发命令等待模式 【感觉用不上】
" 典型使用场景
" 场景 1：alt-enter 多步操作
"     在 :Files 搜索中选择一个文件
"     按 Alt+Enter → fzf 暂停并显示 > 提示符
"     输入 chmod 755 → 对选中的文件执行权限修改
" 场景 2：ctrl-x 复杂处理
"     在 :Rg 搜索结果中选择一行代码
"     按 Ctrl+X → 暂停
"     输入 :tabedit → 在新标签页打开该文件
" let g:fzf_vim.commands_expect = 'alt-enter,ctrl-x'

" ======================== =========================
" 自定义 命令级 fzf 选项 各个查询方式放这里
" ======================== =========================

" 格式如 g：fzf_vim。{command}_options
" 下方类似一个例子，设置 Buffer 样式

" 自定义 :Buffers 命令界面显示的配置选项
" 让 fzf.vim 使用 fzf 的默认选项 方案二选一
let g:fzf_vim.buffers_options = '--style full --border-label " Open Buffers "'
" let g:fzf_vim.buffers_options = ['--style', 'full', '--border-label', ' Open Buffers ']

" ========================  ========================
" 自定义 多列表处理流程
" ========================  ========================

" 当选择多个条目时，以下命令将填充快速修复列表
" Ag
" Rg / RG
" Lines / BLines
" Tags / BTags
" 通过设置 g：fzf_vim.listproc，你可以让它们改用 location lista

" 默认设置：使用快速修复列表
" 设置未让 fzf.vim 使用快速修复列表
" 例子
" 转换前（quickfix 项）：
" { 'filename': 'main.py', 'lnum': 42, 'text': 'TODO: fix this' }
" 转换后（fzf 输入格式）：
" main.py:42:TODO: fix this
" let g:fzf_vim.listproc = { list -> fzf#vim#listproc#quickfix(list) }
" 使用位置列表而非快速修复列表
" let g:fzf_vim.listproc = { list -> fzf#vim#listproc#location(list) }

" 您可以针对每个命令自定义列表类型，方法是定义名为“g:fzf_vim.listproc_{命令名称小写形式}”的变量
""""""" 能解决窗口漂移问题
let g:fzf_vim.listproc_ag = { list -> fzf#vim#listproc#quickfix(list) }
let g:fzf_vim.listproc_rg = { list -> fzf#vim#listproc#location(list) }

" 还可以通过提供一个自定义函数来处理列表，从而进一步自定义其行为，而非使用预定义的 fzf#vim#listproc#quickfix 或 fzf#vim#listproc#location 函数
" 这是 fzf#vim#listproc#quickfix 的定制版本
" 最后两行被注释掉了，以避免直接跳转到第一条记录
" 优化 末行模式 的操作
function! g:fzf_vim.listproc(list)
    call setqflist(a:list)
    copen
    wincmd p
    " cfirst
    " normal! zvzz
endfunction

" ========================
" 高级定制
" ========================

" Vim 函数
" 示例：自定义 Files 命令
" 这是 Files 命令的默认定义
" 单独设置 :Files 使用底部窗口（高度 ~40%）
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({ 'down': '~40%' }), <bang>0)

command! -bang -nargs=? -complete=dir Buffers
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({ 'down': '~40%' }), <bang>0)
" ========================
" 自定义fzf状态行
" ========================

" fa fzf.vim 的状态行
" function! s:fzf_statusline()
"     highlight fzf1 ctermfg=161 ctermbg=1
"     highlight fzf2 ctermfg=23 ctermbg=1
"     highlight fzf3 ctermfg=237 ctermbg=1
"     setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
" endfunction

" autocmd! User FzfStatusLine call <SID>fzf_statusline()

" 隐藏状态行
" autocmd! FileType fzf set laststatus=0 noshowmode noruler
"   \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" ========================
" 快捷键绑定
" ========================a

" <tab> 搜索当前可用快捷键
" 搜索所有普通模式的快捷键
nmap <leader><tab> <plug>(fzf-maps-n)
" 搜索可视模式下可用的快捷键
xmap <leader><tab> <plug>(fzf-maps-x)
" 搜索文本对象操作时的快捷键（如 d、y 后）
omap <leader><tab> <plug>(fzf-maps-o)

" 插入模式快捷键，强化补全
" 单词补全
imap <c-x><c-k> <plug>(fzf-complete-word)
" 文件路径补全
imap <c-x><c-f> <plug>(fzf-complete-path)
" 行补全
imap <c-x><c-l> <plug>(fzf-complete-line)

" 文件模糊搜索
nnoremap <leader>ff :Files<CR>
" Git 文件
nnoremap <leader>fg :GFiles<CR>
" 搜索内容（使用 rg）
nnoremap <leader>fa :Rg<CR>
" 打开 buffer
nnoremap <leader>fb :Buffers<CR>
" 书签
nnoremap <leader>fm :Marks<CR>
" 历史
nnoremap <leader>fh :History<CR>

" =========================
" 颜色主题
" =========================

" fzf 颜色匹配 Vim 主题
" let g:fzf_colors = {
"   \ 'fg':      ['fg', 'fzf1'], " 前景色       1红 2绿 3白
"   \ 'bg':      ['bg', 'fzf1'], " 背景色
"   \ 'hl':      ['fg', 'fzf1'], " 高亮色
"   \ 'fg+':     ['fg', 'fzf1'], " 前景色高亮
"   \ 'bg+':     ['bg', 'fzf1'], " 背景色高亮
"   \ 'hl+':     ['fg', 'fzf1'], " 高亮色高亮
"   \ 'info':    ['fg', 'fzf1'], " 信息提示色
"   \ 'border':  ['fg', 'fzf1'], " 边框色
"   \ 'prompt':  ['fg', 'fzf1'], " 提示符色
"   \ 'pointer': ['fg', 'fzf1'], " 指针色
"   \ 'marker':  ['fg', 'fzf1'], " 标记色
"   \ 'spinner': ['fg', 'fzf1'], " 加载指示器色
"   \ 'header':  ['fg', 'fzf1']  " 头部色
"   \}
let g:fzf_colors = {
            \ 'fg':      ['fg', 'fzf3'],
            \ 'bg':      ['bg', 'fzf1'],
            \ 'hl':      ['fg', 'fzf1'],
            \ 'fg+':     ['fg', 'fzf2'],
            \ 'bg+':     ['bg', 'fzf3'],
            \ 'hl+':     ['fg', 'fzf3'],
            \ 'info':    ['fg', 'fzf2'],
            \ 'border':  ['fg', 'fzf3'],
            \ 'prompt':  ['fg', 'fzf1'],
            \ 'pointer': ['fg', 'fzf2'],
            \ 'marker':  ['fg', 'fzf2'],
            \ 'spinner': ['fg', 'fzf2'],
            \ 'header':  ['fg', 'fzf3']
            \}




" ========================
" 优化
" ========================

" Rg
" let g:fzf_files_options = '--no-ignore-parent --no-follow'

" ctags 权限不足目录和文件 跳过
let g:fzf_vim.tags_command = 'ctags -R --exclude=node_modules --exclude=.git --exclude=build'
