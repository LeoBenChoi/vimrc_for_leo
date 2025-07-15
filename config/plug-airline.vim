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

" let g:airline_theme = 'gruvbox'  " 可选主题：solarized, onedark, molokai 等
let g:airline_theme = 'luna'  
":AirlineTheme <Tab>  " 自动补全可用主题
let g:airline_powerline_fonts = 1  " 启用特殊符号
let g:airline#extensions#tabline#enabled = 1      " 启用顶部 Tab 栏

let g:airline#extensions#tabline#formatter = 'unique_tail'  " 文件名显示方式
" 可选 formatter：
"     default（完整路径）
"     unique_tail（仅显示唯一后缀）
"     jsformatter（适合 JavaScript 项目）

" ========================
" 扩展功能
" ========================

" Git
let g:airline#extensions#branch#enabled = 1  " 显示 Git 分支
let g:airline#extensions#hunks#enabled = 1 " 显示Git变更统计
" let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']  " 自定义符号


let g:airline#extensions#lsp#enabled = 1           " LSP 显示
let g:airline#extensions#lsp#show_line_status = 1  " 显示当前行 LSP 状态
let g:airline#extensions#tabline#enabled = 1  " 显示缓冲区列表

" 语法检查 二选一
let g:airline#extensions#ale#enabled = 1  " 使用 ALE
" 或
" let g:airline#extensions#syntastic#enabled = 1  " 使用 Syntastic

let g:airline#extensions#whitespace#enabled = 1  " 显示尾随空格/混合缩进警告
let g:airline#extensions#tagbar#enabled = 1   " 显示Tagbar状态

let g:airline#extensions#keymap#enabled = 1   " 显示键盘布局
let g:airline#extensions#wordcount#enabled = 1  " 显示字数统计

let g:airline#extensions#battery#enabled = 0  " 显示电池状态

" ========================
" 扩高级自定义
" ========================

" 修改状态栏布局
" let g:airline_section_a = g:airline_section_a + ' %{airline#extensions#branch#head()}'  " 模式 + Git 分支

" let g:airline_section_b = airline#section#create(['%{strftime("%H:%M")}', 'branch'])
" 修改 section_b 的显示顺序
" let g:airline_section_b = '%f'  " 文件名
" let g:airline_section_c = '%{getcwd()}'  " 当前目录
" let g:airline_section_x = '
" \ g:airline_section_a'

" let g:airline_section_y = '%3p%%'  " 文件百分比
" let g:airline_section_z = ' %3l:%-2v'  " 行号:列号
let g:airline_section_z = '
\ %3p%% ☰ %l:%c
\ %{get(g:, "startup_time_display", " ")}
\ %{battery#component()}
\ %{strftime("%Y-%m-%d")}
\ %{strftime("%H:%M")}'


" let g:airline_section_x = '%{lsp#get_server_status()}'

" 自动更新时间（需Vim 8.0+）
if has('timers')
  let g:airline_clock_timer = timer_start(
        \ 1000,
        \ {-> execute('let g:airline_section_z = g:airline_section_z')},
        \ {'repeat': -1})
endif

" 显示电池状态
let g:battery#update_time = -1  " 禁用自动更新

" 添加到airline的Z区（最右侧）
" let g:airline_section_z = get(g:, 'airline_section_z', '') . ''

" " 定时刷新时间显示
" let g:airline#extensions#clock#auto_update = 1
" let g:airline#extensions#clock#update_interval = 1000  " 毫秒

" " 避免重复注册定时器
" if !exists('g:airline_clock_initialized')
"   let g:airline_clock_initialized = 1
"   autocmd VimEnter * call timer_start(0, {-> airline#extensions#clock#update()}, {'repeat': -1})
" endif

" " 时间显示高亮
" highlight airline_clock guifg=#FFD700 ctermfg=220 gui=bold

" " 匹配airline主题色
" autocmd ColorScheme * highlight link airline_clock airline_x


" 集成到airline
" let g:airline_section_z = get(g:, 'airline_section_z', '') . '

" ========================
" 优化
" ========================

" let g:airline_extensions = ['branch', 'tabline']  " 只启用 Git 和 Tabline
