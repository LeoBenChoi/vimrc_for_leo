" :AirlineTheme <Tab>  " 自动补全可用主题
" let g:airline_theme = 'gruvbox'  " 可选主题：solarized, onedark, molokai 等
let g:airline_theme = 'luna'
let g:airline_powerline_fonts = 1                           " 启用特殊符号
let g:airline#extensions#tabline#formatter = 'unique_tail'  " 文件名显示方式
" 可选 formatter：
"     default（完整路径）
"     unique_tail（仅显示唯一后缀）
"     jsformatter（适合 JavaScript 项目）

" ========================
" 扩展功能
" ========================

" air基本设置
" let g:airline#extensions#lsp#enabled = 1            " LSP 显示
" let g:airline#extensions#battery#enabled = 0  " 显示电池状态
let g:airline#extensions#tabline#enabled = 1                " 启用顶部 Tab 栏
let g:airline#extensions#tabline#show_tabs = 1   " 显示标签页
let g:airline#extensions#tabline#tab_nr_type = 1   " 显示标签序号
let g:airline#extensions#tabline#preserve_pwd = 1  " 保持当前工作目录

" let g:airline#extensions#tabline#enabled = 1        " 显示缓冲区列表
" let g:airline#extensions#wordcount#enabled = 1  " 显示字数统计
" let g:airline#extensions#whitespace#enabled = 1  " 显示尾随空格/混合缩进警告
" let g:airline#extensions#lsp#show_line_status = 1   " 显示当前行 LSP 状态

" Git
let g:airline#extensions#hunks#enabled = 1      " 显示Git变更统计
let g:airline#extensions#branch#enabled = 1     " 显示 Git 分支
" let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']  " 自定义符号

" 语法检查 二选一
let g:airline#extensions#ale#enabled = 1  " 使用 ALE
" 或
" let g:airline#extensions#syntastic#enabled = 1  " 使用 Syntastic

" 图标
let g:airline_symbols = {}  " 符号表初始化
" vue
" let g:airline_symbols.vue = ""  " Unicode 字符 
let g:airline_symbols = get(g:, 'airline_symbols', {})
let g:airline_symbols.vue = ""  " 强制覆盖
let g:airline#extensions#filetype#symbols = {}  " 重置文件类型符号表
let g:airline#extensions#filetype#symbols.vue = g:airline_symbols.vue  " 重新映射

" ========================
" 扩高级自定义
" ========================

" 修改状态栏布局
" let g:airline_section_a = g:airline_section_a + ' %{airline#extensions#branch#head()}'  " 模式 + Git 分支
" let g:airline_section_b = airline#section#create(['%{strftime("%H:%M")}', 'branch'])
" let g:airline_section_c = '%{getcwd()}'  " 当前目录
" let g:airline_section_x = '%{airline#extensions#lsp#status()}'  " LSP 状态
" let g:airline_section_y = '%3p%%'  " 文件百分比
" let g:airline_section_z = '
"             \ %3p%% ☰ %l:%c
"             \ %{get(g:, "startup_time_display", " ")}
"             \ %{battery#component()}
"             \ %{strftime("%Y-%m-%d")} " 显示日期
"             \ %{strftime("%H:%M")}
            " \ %{coc#status()}'
            "   \'
" let g:airline_section_y = '
"             \ %{strftime("%H:%M")}'

let g:airline_section_z = '
            \ %3p%% ☰ %l:%c
            \ %{get(g:, "startup_time_display", " ")}
            \ %{strftime("%H:%M")}'


" 自动更新时间（需Vim 8.0+）
if has('timers')
    let g:airline_clock_timer = timer_start(
                \ 1000,
                \ {-> execute('let g:airline_section_z = g:airline_section_z')},
                \ {'repeat': -1})
endif


" ========================
" 兼容性配置
" ========================

" 让 Airline 不覆盖 fzf 的界面
let g:airline#extensions#fzf#enabled = 0  " 禁用 fzf 的 Airline 集成, 解决fzf 界面异常
" let g:webdevicons_enable_airline_statusline = 0  " 禁止图标插件修改状态栏
" let g:webdevicons_enable_airline_tabline = 0     " 禁止图标插件修改标签栏

" 解决宽字符设置显示问题
set conceallevel=2
set concealcursor=nvic
" let g:airline_left_sep = '>'  " 用 '>' 替代默认的 '▶'（避免双宽度问题）
" let g:airline_right_sep = '<'
" 默认使用单宽度（防止符号错位）

"""" 这里的兼容性配置是 vim-devicons 的配置 兼容，由于内容很少，就先放这
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}            "
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vue'] = '󰡄'  " 直接粘贴 Unicode 字符
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols['.vue'] = '󰡄'   " 针对 .vue 文件
