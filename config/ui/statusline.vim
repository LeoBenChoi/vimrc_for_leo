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
let g:airline#extensions#vista#enabled = 0

"==============================================================
" 1. Airline 基础配置
"==============================================================
" 仅在 vim-airline 已加载时配置基础设置
if exists(':AirlineRefresh')
  let g:airline#extensions#tabline#enabled = 1          " 启用标签栏（显示所有 buffer）
  let g:airline#extensions#tabline#formatter = 'unique_tail' " 标签栏显示文件名（不含路径）
  let g:airline#extensions#tabline#buffer_nr_show = 0   " 不显示 buffer 编号
  let g:airline_powerline_fonts = 1                     " 使用 Powerline 字体（如果已安装）
endif

"==============================================================
" 2. 插件集成
"==============================================================
if exists(':AirlineRefresh')
  " coc.nvim 集成（显示 LSP 状态和诊断信息）
  let g:airline#extensions#coc#enabled = 1
  let g:airline#extensions#coc#error_symbol = 'E:'
  let g:airline#extensions#coc#warning_symbol = 'W:'
  let g:airline#extensions#coc#show_line_numbers = 0

  " vim-fugitive 集成（显示 Git 分支和状态）
  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#branch#vcs_priority = ['git', 'mercurial']

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
  if !exists(':AirlineRefresh')
    return 0
  endif
  " 检查主题文件是否存在
  let l:theme_file = globpath(&runtimepath, 'autoload/airline/themes/' . a:theme_name . '.vim')
  return !empty(l:theme_file)
endfunction

if !exists('g:airline_theme')
  " Windows 终端下使用 selenized 主题
  if s:is_windows_terminal() && !has('gui_running')
    " 尝试使用 selenized 主题，如果不存在则使用 base16_selenized 或 luna
    if s:airline_theme_exists('selenized')
      let g:airline_theme = 'selenized'
    elseif s:airline_theme_exists('base16_selenized')
      let g:airline_theme = 'base16_selenized'
    else
      " 如果 selenized 主题不存在，使用 luna 作为回退
      let g:airline_theme = 'luna'
    endif
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
  
  " 保存原始的 section_z 配置（如果还没有保存）
  if !exists('s:original_section_z_saved')
    if exists('g:airline_section_z')
      let s:original_section_z = g:airline_section_z
    else
      let s:original_section_z = ''
    endif
    let s:original_section_z_saved = 1
  endif
  
  " 计算启动时间
  call s:UpdateStartupTime()
  
  " 如果用户没有自定义 section_z，使用默认配置并添加启动时间
  if empty(s:original_section_z)
    let g:airline_section_z = '%3p%% ☰ %l:%c %{get(g:, "startup_time_display", " ")}'
  else
    " 如果用户已自定义，在现有配置中添加启动时间
    " 检查是否已经包含 startup_time_display，避免重复添加
    if s:original_section_z !~# 'startup_time_display'
      let g:airline_section_z = s:original_section_z . ' %{get(g:, "startup_time_display", " ")}'
    else
      let g:airline_section_z = s:original_section_z
    endif
  endif
  
  " 刷新状态栏以显示启动时间
  " 使用命令方式刷新，更安全
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
  " 恢复原始的 section_z 配置
  if exists('s:original_section_z') && !empty(s:original_section_z)
    let g:airline_section_z = s:original_section_z
  else
    " 如果没有原始配置，使用默认配置（不包含启动时间）
    let g:airline_section_z = '%3p%% ☰ %l:%c'
  endif
  " 使用命令方式刷新，更安全
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
