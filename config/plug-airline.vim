" ========================
" airline 配置
" 功能：状态栏
" ========================

" 确保只加载一次
if exists('g:plug_load_airline')
    finish
endif
let g:plug_load_airline = 1

" ========================
" 基本配置
" ========================

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
let g:airline#extensions#lsp#enabled = 1            " LSP 显示
let g:airline#extensions#battery#enabled = 0  " 显示电池状态
let g:airline#extensions#tabline#enabled = 1                " 启用顶部 Tab 栏
let g:airline#extensions#tabline#enabled = 1        " 显示缓冲区列表
let g:airline#extensions#wordcount#enabled = 1  " 显示字数统计
let g:airline#extensions#whitespace#enabled = 1  " 显示尾随空格/混合缩进警告
let g:airline#extensions#lsp#show_line_status = 1   " 显示当前行 LSP 状态

" Git
let g:airline#extensions#hunks#enabled = 1      " 显示Git变更统计
let g:airline#extensions#branch#enabled = 1     " 显示 Git 分支
" let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']  " 自定义符号

" 语法检查 二选一
let g:airline#extensions#ale#enabled = 1  " 使用 ALE
" 或
" let g:airline#extensions#syntastic#enabled = 1  " 使用 Syntastic

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
let g:airline#extensions#fzf#enabled = 0  " 禁用 fzf 的 Airline 集成
