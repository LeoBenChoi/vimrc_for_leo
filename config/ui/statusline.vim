"==============================================================
" config/ui/statusline.vim
" 状态栏配置：vim-airline 插件配置
"==============================================================

if exists('g:loaded_statusline_config')
  finish
endif
let g:loaded_statusline_config = 1

"==============================================================
" 0. Vista 扩展配置（必须在 vim-airline 加载前设置）
"==============================================================
" 确保 Vista 扩展被禁用（已在 .vimrc 中设置，这里再次确认）
" let g:airline#extensions#vista#enabled = 1

"==============================================================
" 0.1. Airline 符号配置（必须在 vim-airline 加载前设置）
"==============================================================
" 这些配置必须在 airline 初始化之前设置才能生效
let g:airline_powerline_fonts = 1                             " 使用 Powerline 字体（如果已安装）
let g:airline_symbols_ascii = 0                               " 禁用 ASCII 模式，启用特殊符号（> 和 <）

" 初始化符号字典（如果需要自定义符号）
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" 修复显示不全的符号：将 maxlinenr 符号改为更兼容的格式
" 使用简单的 '/' 分隔符替代可能显示不全的 ☰ 符号
let g:airline_symbols.maxlinenr = '/'

"==============================================================
" 0.1.1. 标签栏配置（必须在 vim-airline 加载前设置）
"==============================================================
" 启用标签栏（显示所有 buffer）
let g:airline#extensions#tabline#enabled = 1

" 标签栏显示模式
" 可选值：
"   - 'default'      : 默认模式（显示 buffers）
"   - 'unique_tail'   : 显示文件名（不含路径，去重）
"   - 'unique_tail_improved' : 改进的去重模式
"   - 'jsformatter'   : JavaScript 格式化器
"   - 'short_path'    : 短路径模式
"   - 'formatter'     : 自定义格式化器
let g:airline#extensions#tabline#formatter = 'unique_tail'

" 显示 buffer 编号（在标签栏中显示 buffer 编号）
let g:airline#extensions#tabline#buffer_nr_show = 1
" buffer 编号格式（%n 表示编号，%s 表示分隔符）
let g:airline#extensions#tabline#buffer_nr_format = '%s:%n'

" 显示所有 buffer（包括未命名的）
let g:airline#extensions#tabline#show_buffers = 1
" 显示所有 tab 页
let g:airline#extensions#tabline#show_tabs = 1
" 显示 tab 页编号
let g:airline#extensions#tabline#show_tab_nr = 1
" tab 编号格式
let g:airline#extensions#tabline#tab_nr_format = '%s:%n |'

" 标签栏左侧显示内容（默认显示所有 buffers）
" 可选值：
"   - 0 : 不显示
"   - 1 : 显示所有 buffers
"   - 2 : 只显示当前 tab 的 buffers
let g:airline#extensions#tabline#show_splits = 1

" 标签栏右侧显示内容（默认显示 tab 页）
" 可选值：
"   - 0 : 不显示
"   - 1 : 显示所有 tab 页
let g:airline#extensions#tabline#show_tab_type = 1

" 关闭未保存 buffer 时显示警告
let g:airline#extensions#tabline#show_close_button = 0

" 标签栏分隔符
" let g:airline#extensions#tabline#left_sep = ' ' " 左侧分隔符
" let g:airline#extensions#tabline#left_alt_sep = '|' " 左侧备用分隔符
let g:airline#extensions#tabline#right_sep = ' ' " 右侧分隔符
let g:airline#extensions#tabline#right_alt_sep = '|' " 右侧备用分隔符

" Buffer 索引模式（用于快速切换 buffer）
" 可选值：
"   - 0 : 禁用
"   - 1 : 模式 1（1-9, 0 表示第 10 个）
"   - 2 : 模式 2（11-99）
"   - 3 : 模式 3（01-99，与 :buffers 命令编号一致）
let g:airline#extensions#tabline#buffer_idx_mode = 1

" 忽略某些文件类型的 buffer（不在标签栏显示）
let g:airline#extensions#tabline#excludes = ['vimfiler', 'nerdtree', 'tagbar', 'vista']

"==============================================================
" 0.2. 获取当前字符的16进制值
"==============================================================
" 函数：获取光标下字符的16进制值（全局函数，可在 statusline 中使用）
function! GetCharHex() abort
  let l:col = col('.') - 1
  let l:line = getline('.')
  if l:col >= 0 && l:col < len(l:line)
    let l:char = l:line[l:col]
    let l:hex = printf('%02X', char2nr(l:char))
    return '0x' . l:hex
  endif
  return ''
endfunction

"==============================================================
" 0.3. 直接配置 section_z（简单样式，不使用特殊符号）
"==============================================================
" 直接设置 section_z，会覆盖函数中的动态配置
" 格式说明：
"   %3p%%  - 百分比（3位数字 + %）
"   %l     - 当前行号
"   %L     - 总行数
"   %c     - 当前列号
"   %{GetCharHex()} - 当前字符的16进制值（全局函数）
"   使用 | 和 / 作为分隔符，不使用特殊符号
let g:airline_section_z = '%3p%% | %l/%L | %c | %{GetCharHex()}'

" 设置状态栏分隔符为 > 和 <（必须在 airline 加载前设置）
" let g:airline_left_sep = '>'                                  " 左侧分隔符
" let g:airline_right_sep = '<'                                 " 右侧分隔符
" let g:airline_left_alt_sep = '>'                              " 左侧备用分隔符
" let g:airline_right_alt_sep = '<'                             " 右侧备用分隔符

"==============================================================
" 1. Airline 基础配置
"==============================================================
" 注意：标签栏配置已在 0.1.1 节中设置（必须在 airline 加载前）
" 这里只配置需要在 airline 加载后设置的选项

"==============================================================
" 2. 插件集成
"==============================================================
if exists(':AirlineRefresh')
  " coc.nvim 集成（显示 LSP 状态和诊断信息）
  let g:airline#extensions#coc#enabled = 1
  let g:airline#extensions#coc#error_symbol = 'E:'
  let g:airline#extensions#coc#warning_symbol = 'W:'
  let g:airline#extensions#coc#show_line_numbers = 0

  " fzf 集成（在 fzf 窗口中禁用 airline）
  let g:airline#extensions#fzf#enabled = 0
endif

"==============================================================
" 3. 主题配置
"==============================================================
" 判断是否为 Windows 终端
function! s:is_windows_terminal() abort
  return has('win32') || has('win64') || has('win16')
endfunction

" 检查 airline 主题是否存在
function! s:airline_theme_exists(theme_name) abort
  " 方法1：使用 airline 提供的函数（如果可用）
  if exists('*airline#util#themes')
    let l:themes = airline#util#themes('')
    return index(l:themes, a:theme_name) != -1
  endif
  " 方法2：检查主题文件是否存在
  let l:theme_file = globpath(&runtimepath, 'autoload/airline/themes/' . a:theme_name . '.vim')
  if !empty(l:theme_file)
    return 1
  endif
  " 方法3：尝试加载主题文件（最可靠的方法）
  try
    execute 'runtime autoload/airline/themes/' . a:theme_name . '.vim'
    return exists('g:airline#themes#' . a:theme_name . '#palette')
  catch
    return 0
  endtry
endfunction

if !exists('g:airline_theme')
  " Windows 终端下使用 alduin 主题
  if s:is_windows_terminal() && !has('gui_running')
    " 直接设置 alduin 主题
    " 如果主题不存在，airline 会自动回退到 dark，但我们可以手动验证
    let g:airline_theme = 'alduin'
  elseif exists('g:theme_mode')
    if g:theme_mode ==# 'day' || (g:theme_mode ==# 'auto' && str2nr(strftime('%H')) >= 7 && str2nr(strftime('%H')) < 19)
      let g:airline_theme = 'luna'        " 白天主题（或使用 light, ayu_light, base16_papercolor_light 等）
    else
      let g:airline_theme = 'luna'  " 夜间主题（或使用 dark, onedark, base16_onedark 等）
    endif
  else
    let g:airline_theme = 'luna'          " 默认暗色主题
  endif
endif

"==============================================================
" 4. 启动时间显示
"==============================================================
" 如果需要自定义状态栏组件，可在此添加
" 示例：显示当前函数名（需要 LSP 支持）
" function! AirlineInit()
"   let g:airline_section_b = airline#section#create(['branch', ' ', '%{get(b:,"coc_current_function","")}'])
" endfunction
" autocmd User AirlineAfterInit call AirlineInit()

"==============================================================
" 4.1. 启动时间显示组件
"==============================================================
" 计算并更新启动时间显示
function! s:UpdateStartupTime() abort
  if !exists('g:vim_start_time')
    return
  endif
  let l:elapsed = reltimefloat(reltime(g:vim_start_time))
  if l:elapsed < 0.001
    let g:startup_time_display = ''
    return
  endif
  " 格式化时间：如果小于 1 秒，显示毫秒；否则显示秒（保留 3 位小数）
  if l:elapsed < 1.0
    let l:time_str = printf('%dms', float2nr(l:elapsed * 1000))
  else
    let l:time_str = printf('%.3fs', l:elapsed)
  endif
  let g:startup_time_display = 'VIM! 启动 : ' . l:time_str
endfunction

" 初始化启动时间显示
function! s:AirlineStartupTimeInit() abort
  if !exists(':AirlineRefresh')
    return
  endif
  
  " 如果用户已经在文件开头直接设置了 g:airline_section_z，则不再修改
  " 检查是否包含启动时间，如果没有则添加
  if exists('g:airline_section_z') && g:airline_section_z !~# 'startup_time_display'
    " 在现有配置后添加启动时间
    let g:airline_section_z = g:airline_section_z . ' %{get(g:, "startup_time_display", "")}'
  elseif !exists('g:airline_section_z')
    " 如果没有设置，使用简单格式
    let g:airline_section_z = '%3p%% | %l/%L | %c %{get(g:, "startup_time_display", "")}'
  endif
  
  " 计算启动时间
  call s:UpdateStartupTime()
  
  " 刷新状态栏
  if exists(':AirlineRefresh')
    execute 'AirlineRefresh'
  endif
endfunction

" 在 airline 初始化后设置启动时间显示
autocmd User AirlineAfterInit call s:AirlineStartupTimeInit()

" 如果 airline 已经初始化，立即设置启动时间显示
" 这处理了 statusline.vim 在 airline 初始化之后加载的情况
if exists(':AirlineRefresh')
  call s:AirlineStartupTimeInit()
endif

" 在 Vim 完全启动后更新启动时间（此时所有插件都已加载）
autocmd VimEnter * call s:UpdateStartupTime() | if exists(':AirlineRefresh') | call s:AirlineStartupTimeInit() | endif

" 延迟初始化：确保在插件完全加载后设置启动时间显示
" 使用延迟执行，确保 airline 已经完全初始化
if has('timers')
  " 延迟 100ms 后初始化，确保 airline 已完全加载
  call timer_start(100, {-> s:AirlineStartupTimeInit()}, {'repeat': 1})
endif

" 10 秒后清除启动时间显示
function! s:ClearStartupTime() abort
  if !exists(':AirlineRefresh')
    return
  endif
  let g:startup_time_display = ''
  " 如果用户已经设置了 g:airline_section_z，移除启动时间部分
  if exists('g:airline_section_z')
    let g:airline_section_z = substitute(g:airline_section_z, ' %{get(g:, "startup_time_display", "")}', '', '')
  endif
  " 刷新状态栏
  if exists(':AirlineRefresh')
    execute 'AirlineRefresh'
  endif
endfunction

" 使用定时器在 10 秒后清除显示
if has('timers')
  let s:startup_timer = timer_start(10000, {-> s:ClearStartupTime()}, {'repeat': 1})
endif

"==============================================================
" 5. 自动刷新
"==============================================================
" 当 coc 状态改变时自动刷新状态栏
if exists('*coc#status')
  autocmd User CocStatusChange,CocDiagnosticChange if exists(':AirlineRefresh') | execute 'AirlineRefresh' | endif
endif

"==============================================================
" 验证 alduin 主题是否成功加载
"==============================================================
function! s:verify_alduin_theme() abort
  " 等待 airline 完全加载
  if !exists(':AirlineRefresh')
    return
  endif
  " 检查 alduin 主题是否真的存在
  if !s:airline_theme_exists('alduin')
    " 如果 alduin 不存在，回退到其他主题
    if s:airline_theme_exists('minimalist')
      let g:airline_theme = 'minimalist'
    elseif s:airline_theme_exists('serene')
      let g:airline_theme = 'serene'
    else
      let g:airline_theme = 'dark'
    endif
    " 应用新主题
    if exists(':AirlineTheme')
      execute 'AirlineTheme ' . g:airline_theme
    endif
  endif
endfunction
