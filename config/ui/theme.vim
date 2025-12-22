"==============================================================
" config/ui/theme.vim
" 主题配置：支持日夜切换、GUI/终端区分、透明背景
" 参考自：vimrc_for_leo-main 项目
"==============================================================

if exists('g:loaded_theme_config')
  finish
endif
let g:loaded_theme_config = 1

"==============================================================
" 1. 主题配置变量
"==============================================================
" 根据时间切换主题深浅色（7:00-19:00 为日间）
let hour = strftime("%H")
if hour >= 7 && hour < 19
  let g:theme_mode = get(g:, 'theme_mode', 'light')  " 日间模式
else
  let g:theme_mode = get(g:, 'theme_mode', 'dark')   " 夜间模式
endif

" 主题模式：auto（自动切换）、day/light（日间）、night/dark（夜间）
" 如果未设置，使用时间判断的结果
if !exists('g:theme_mode_override')
  let g:theme_mode_override = 'auto'
endif

" 确保 theme_mode 变量存在
if !exists('g:theme_mode')
  let g:theme_mode = s:is_daytime() ? 'light' : 'dark'
endif

" 日间主题：Solarized8（默认，但终端下使用 PaperColor）
let g:theme_day = get(g:, 'theme_day', 'solarized8')  " 日间模式
" 夜间主题：Gruvbox（深色主题）
let g:theme_night = get(g:, 'theme_night', 'gruvbox')  " 夜间模式

" GUI 模式下的主题（可选）
let g:theme_day_gui = get(g:, 'theme_day_gui', 'PaperColor')
let g:theme_night_gui = get(g:, 'theme_night_gui', '')

" 终端模式下的主题（可选）
" Linux 终端下使用 one（高对比度，清晰易读）
" Windows 终端推荐使用支持透明背景的主题：
"   - one (One Dark/Light) - 经典、高对比度，完美支持透明背景 ⭐ 强力推荐
"   - dracula - 现代、柔和，完美支持透明背景
"   - PaperColor - 浅色主题，支持透明背景
"   - gruvbox - 深色主题，支持透明背景
"   - darkblue - Vim 内置深色主题，支持透明背景
let g:theme_day_term = get(g:, 'theme_day_term', has('unix') && !has('mac') ? 'one' : (has('win32') || has('win64') || has('win16') ? 'gruvbox' : ''))
" Windows 终端下使用 gruvbox（深色主题）
let g:theme_night_term = get(g:, 'theme_night_term', has('win32') || has('win64') || has('win16') ? 'gruvbox' : '')

" 透明背景设置（Windows Terminal 推荐启用）
" 启用后，Vim 背景将透明，显示 Windows Terminal 的背景
" Windows Terminal 透明配置：在设置中添加 "useAcrylic": true, "acrylicOpacity": 0.75
let g:theme_transparent_bg = get(g:, 'theme_transparent_bg', 1)

"==============================================================
" 2. 辅助函数
"==============================================================
" 判断是否为日间时间
function! s:is_daytime() abort
  let hour = strftime("%H")
  return hour >= 7 && hour < 19
endfunction

" 判断是否为 GUI 模式
function! s:is_gui() abort
  return has('gui_running')
endfunction

" 检查主题是否存在
function! s:has_colorscheme(name) abort
  if empty(a:name)
    return 0
  endif
  " darkblue 是 Vim 内置主题，总是存在
  if a:name ==# 'darkblue' || a:name ==# 'default' || a:name ==# 'desert' || a:name ==# 'evening'
    return 1
  endif
  return !empty(globpath(&runtimepath, 'colors/' . a:name . '.vim'))
endfunction

" 获取当前应该使用的主题名称
function! s:get_theme_name(mode) abort
  let l:is_gui = s:is_gui()
  let l:base_theme = a:mode ==# 'light' || a:mode ==# 'day' ? g:theme_day : g:theme_night
  
  " 优先使用 GUI/终端特定主题
  if l:is_gui
    let l:specific_theme = (a:mode ==# 'light' || a:mode ==# 'day') ? g:theme_day_gui : g:theme_night_gui
  else
    let l:specific_theme = (a:mode ==# 'light' || a:mode ==# 'day') ? g:theme_day_term : g:theme_night_term
  endif
  
  " Windows 终端下，优先使用 darkblue（内置主题，完美支持透明背景）
  if !l:is_gui && (has('win32') || has('win64') || has('win16'))
    " 如果指定了特定主题且存在，使用特定主题
    if !empty(l:specific_theme) && s:has_colorscheme(l:specific_theme)
      return l:specific_theme
    " 否则优先使用 darkblue（日间和夜间都使用）
    else
      return 'darkblue'
    endif
  " 非 Windows 终端，使用指定主题或基础主题
  elseif !empty(l:specific_theme) && s:has_colorscheme(l:specific_theme)
    return l:specific_theme
  " Linux 终端下，如果 one 不存在，尝试 solarized8
  elseif !l:is_gui && has('unix') && !has('mac') && (a:mode ==# 'light' || a:mode ==# 'day')
    if s:has_colorscheme('solarized8')
      return 'solarized8'
    endif
  " 使用基础主题
  elseif s:has_colorscheme(l:base_theme)
    return l:base_theme
  else
    " 回退到默认主题
    return 'default'
  endif
endfunction

"==============================================================
" 3. 主题设置函数（参考原项目）
"==============================================================
function! s:set_theme()
  try
    " 确定主题模式
    if g:theme_mode_override ==# 'auto'
      let l:mode = s:is_daytime() ? 'light' : 'dark'
    elseif g:theme_mode_override ==# 'day'
      let l:mode = 'light'
    elseif g:theme_mode_override ==# 'night'
      let l:mode = 'dark'
    else
      " 兼容旧配置
      let l:mode = g:theme_mode_override
    endif
    
    " 获取主题名称
    let g:theme_name = s:get_theme_name(l:mode)
    let g:theme_mode = l:mode
    
    " 设置自定义高亮（在 VimEnter 时执行）
    augroup CustomHighlights
      autocmd!
      " 在 Vim 完全初始化后执行（包括插件加载）
      autocmd VimEnter * call s:custom_highlights()
    augroup END
  catch /^Vim\%((\a\+)\)\=:E185/
    echo "主题未加载"
  endtry
endfunction

"==============================================================
" 4. 主题加载函数（参考原项目）
" 确保主题和背景色同步切换
"==============================================================
function! s:load_theme()
  try
    " 确保主题模式已设置
    if !exists('g:theme_mode') || empty(g:theme_mode)
      " 如果未设置，根据时间判断
      let g:theme_mode = s:is_daytime() ? 'light' : 'dark'
    endif
    
    " Windows Terminal 环境下启用真彩色支持
    if !s:is_gui() && (has('win32') || has('win64') || has('win16'))
      set termguicolors
    endif
    
    " 根据背景模式确定主题名称（确保主题和背景同步）
    if g:theme_mode ==# 'light' || g:theme_mode ==# 'day'
      " 日间模式：使用 PaperColor 主题
      let g:theme_name = s:get_theme_name('light')
      let &background = 'light'
    else
      " 夜间模式：使用 Gruvbox 主题
      let g:theme_name = s:get_theme_name('dark')
      let &background = 'dark'
    endif
    
    " 如果主题名称未获取到，使用默认值
    if !exists('g:theme_name') || empty(g:theme_name)
      let g:theme_name = (g:theme_mode ==# 'light' || g:theme_mode ==# 'day') ? g:theme_day : g:theme_night
    endif
    
    " 特殊主题配置（必须在应用主题前设置）
    if g:theme_name ==# 'gruvbox'
      " Windows 终端下使用 soft 对比度，避免白底过于凸显
      if (has('win32') || has('win64') || has('win16')) && !s:is_gui()
        if !exists('g:gruvbox_contrast_dark')
          let g:gruvbox_contrast_dark = 'soft'  " soft 对比度，更柔和
        endif
      else
        if !exists('g:gruvbox_contrast_dark')
          let g:gruvbox_contrast_dark = 'medium'
        endif
      endif
      if !exists('g:gruvbox_italic')
        let g:gruvbox_italic = 1
      endif
      " 禁用透明背景，确保在 Windows 终端中显示正常
      if (has('win32') || has('win64') || has('win16')) && !s:is_gui()
        let g:gruvbox_transparent_bg = 0
      endif
      " Windows Terminal 下强制使用深色背景
      if (has('win32') || has('win64') || has('win16')) && !s:is_gui()
        set background=dark
      endif
    elseif g:theme_name ==# 'PaperColor'
      " PaperColor 配置（浅色主题，适合 Windows 终端）
      if !exists('g:PaperColor_Theme_Options')
        let g:PaperColor_Theme_Options = {
              \   'theme': {
              \     'default': {
              \       'transparent_background': g:theme_transparent_bg ? 1 : 0,
              \       'allow_bold': 1,
              \       'allow_italic': 1
              \     }
              \   }
              \ }
      endif
      " PaperColor 在终端下的优化配置
      if !s:is_gui()
        " 确保在终端下使用浅色模式
        set background=light
        " Windows 终端下特别配置
        if (has('win32') || has('win64') || has('win16'))
          let g:PaperColor_Theme_Options.theme.default.transparent_background = g:theme_transparent_bg ? 1 : 0
        else
          let g:PaperColor_Theme_Options.theme.default.transparent_background = g:theme_transparent_bg ? 1 : 0
        endif
      endif
    elseif g:theme_name ==# 'onedark'
      if !exists('g:onedark_terminal_italics')
        let g:onedark_terminal_italics = 1
      endif
    elseif g:theme_name ==# 'one'
      " One 主题配置（高对比度主题，适合终端，支持透明背景）
      if !exists('g:one_allow_italics')
        let g:one_allow_italics = 1
      endif
      " Windows 终端下使用深色模式，Linux 终端下根据主题模式决定
      if (has('win32') || has('win64') || has('win16')) && !s:is_gui()
        " Windows 终端下使用 One Dark（深色模式）
        set background=dark
        " 确保 Windows 终端下使用透明背景
        if g:theme_transparent_bg
          let g:one_allow_italics = 1
        endif
      elseif g:theme_mode ==# 'light' || g:theme_mode ==# 'day'
        " Linux 终端下根据主题模式决定
        set background=light
      else
        set background=dark
      endif
    elseif g:theme_name ==# 'darkblue'
      " Darkblue 主题配置（Vim 内置深色主题，适合 Windows 终端，支持透明背景）
      " Windows 终端下确保使用深色模式
      if (has('win32') || has('win64') || has('win16')) && !s:is_gui()
        set background=dark
      endif
    elseif g:theme_name ==# 'dracula'
      " Dracula 主题配置（现代、流行，适合 Windows 终端，支持透明背景）
      if !exists('g:dracula_colorterm')
        let g:dracula_colorterm = 1  " 启用真彩色支持
      endif
      if !exists('g:dracula_italic')
        let g:dracula_italic = 1  " 启用斜体
      endif
      " Windows 终端下确保使用深色模式
      if (has('win32') || has('win64') || has('win16')) && !s:is_gui()
        set background=dark
      endif
    elseif g:theme_name ==# 'tokyonight'
      " Tokyo Night 主题配置（现代、优雅，适合 Windows 终端，支持透明背景）
      if !exists('g:tokyonight_style')
        let g:tokyonight_style = 'night'  " 可选: night, storm, day, moon
      endif
      if !exists('g:tokyonight_transparent')
        let g:tokyonight_transparent = g:theme_transparent_bg ? 1 : 0
      endif
      if !exists('g:tokyonight_italic_functions')
        let g:tokyonight_italic_functions = 1
      endif
      " Windows 终端下确保使用深色模式
      if (has('win32') || has('win64') || has('win16')) && !s:is_gui()
        set background=dark
      endif
    elseif g:theme_name ==# 'catppuccin'
      " Catppuccin 主题配置（柔和、护眼，适合 Windows 终端，支持透明背景）
      if !exists('g:catppuccin_flavour')
        let g:catppuccin_flavour = 'mocha'  " 可选: latte, frappe, macchiato, mocha
      endif
      " Windows 终端下确保使用深色模式
      if (has('win32') || has('win64') || has('win16')) && !s:is_gui()
        set background=dark
      endif
    endif
    
    " 应用主题（在配置设置后）
    execute 'colorscheme ' . g:theme_name
    
    " 确保背景色与主题一致
    if g:theme_mode ==# 'light' || g:theme_mode ==# 'day'
      set background=light
    else
      set background=dark
    endif
    
  catch /^Vim\%((\a\+)\)\=:E185/
    " 未安装以上主题则使用默认主题
    " Windows 终端下优先使用 darkblue
    if !s:is_gui() && (has('win32') || has('win64') || has('win16'))
      try
        colorscheme darkblue
        set background=dark
      catch
        " 如果 darkblue 也不存在，尝试 default
        try
          colorscheme default
          set background=dark
        catch
          " 如果 default 也不存在，至少设置背景色
          set background=dark
        endtry
      endtry
    else
      " 非 Windows 终端，使用默认主题
      try
        colorscheme default
        colorscheme retrobox
      catch
        " 如果 retrobox 也不存在，至少设置背景色
        if exists('g:theme_mode')
          execute 'set background=' . g:theme_mode
        else
          set background=dark
        endif
      endtry
    endif
  catch
    " 其他错误，至少设置背景色
    " Windows 终端下尝试使用 darkblue
    if !s:is_gui() && (has('win32') || has('win64') || has('win16'))
      try
        colorscheme darkblue
        set background=dark
      catch
        set background=dark
      endtry
    else
      if exists('g:theme_mode')
        execute 'set background=' . g:theme_mode
      else
        set background=dark
      endif
    endif
  endtry
endfunction

"==============================================================
" 5. 自定义高亮配置（参考原项目）
"==============================================================
function! s:custom_highlights()
  " 基础背景色（透明背景）
  " 只设置编辑器主背景为透明，不影响文字背景色
  if !s:is_gui() && g:theme_transparent_bg
    " 只设置 Normal（编辑器主背景）为透明，让文字背景由主题自己控制
    highlight Normal       guibg=NONE ctermbg=NONE
    " 设置文件末尾标记为透明
    highlight EndOfBuffer  ctermbg=NONE guibg=NONE
    " 设置非文本区域（如行号列）背景为透明，但不影响行号文字本身
    highlight NonText      ctermbg=NONE guibg=NONE
    " 设置垂直分割线背景为透明
    highlight VertSplit    ctermbg=NONE guibg=NONE
    " 注意：不设置 LineNr、CursorLine 等，让主题自己控制文字背景
  endif
  
  " 行号高亮
  highlight LineNr       guifg=#5c6370 ctermfg=242
  highlight CursorLineNr guifg=#e5c07b ctermfg=214 gui=bold cterm=bold
  
  " 特殊语法高亮增强
  highlight! link TSVariable Identifier
  highlight! link TSParameter Special
  
  " Git 相关高亮
  highlight GitGutterAdd    guifg=#98c379 ctermfg=114
  highlight GitGutterChange guifg=#61afef ctermfg=75
  highlight GitGutterDelete guifg=#e06c75 ctermfg=168
  
  " 诊断信息高亮（区分浅/深背景，确保可读性）
  if &background ==# 'light'
    highlight DiagnosticError guifg=#b00020 ctermfg=160
    highlight DiagnosticWarn  guifg=#8a6d00 ctermfg=94
    highlight DiagnosticInfo  guifg=#005f87 ctermfg=24
    highlight DiagnosticHint  guifg=#2b6300 ctermfg=28
  else
    highlight DiagnosticError guifg=#e06c75 ctermfg=168
    highlight DiagnosticWarn  guifg=#e5c07b ctermfg=180
    highlight DiagnosticInfo  guifg=#61afef ctermfg=75
    highlight DiagnosticHint  guifg=#98c379 ctermfg=114
  endif
 
  " 标签栏样式
  highlight TabLine      guifg=#5c6370 guibg=#282c34 gui=NONE
  highlight TabLineSel   guifg=#abb2bf guibg=#3e4452 gui=BOLD
  highlight TabLineFill  guifg=NONE    guibg=#282c34 gui=NONE
endfunction

"==============================================================
" 6. 主题切换函数（公开接口）
" 确保切换背景时同时切换主题
"==============================================================
function! ToggleThemeMode()
  " 确保所有必要的变量都已初始化
  if !exists('g:theme_mode_override')
    let g:theme_mode_override = 'auto'
  endif
  
  " 获取当前实际模式（用于判断切换方向）
  let l:current_mode = g:theme_mode_override
  if l:current_mode ==# 'auto'
    " 自动模式下，根据时间判断当前模式
    let l:current_mode = s:is_daytime() ? 'day' : 'night'
  endif
  
  " 确定要切换到的模式
  if l:current_mode ==# 'day'
    " 从日间切换到夜间
    let g:theme_mode_override = 'night'
    let g:theme_mode = 'dark'
  else
    " 从夜间切换到日间
    let g:theme_mode_override = 'day'
    let g:theme_mode = 'light'
  endif
  
  " 重新设置主题名称
  call s:set_theme()
  
  " 加载并应用主题
  call s:load_theme()
  
  " 强制应用主题（确保主题真正被应用）
  if exists('g:theme_name') && !empty(g:theme_name)
    try
      " 先设置背景色
      if g:theme_mode ==# 'light' || g:theme_mode ==# 'day'
        set background=light
      else
        set background=dark
      endif
      
      " 再应用主题
      execute 'colorscheme ' . g:theme_name
      
      " 验证主题是否应用成功（使用 g:colors_name 变量）
      if exists('g:colors_name') && g:colors_name !=# g:theme_name
        " 如果主题未应用成功，重试
        execute 'colorscheme ' . g:theme_name
      endif
    catch /^Vim\%((\a\+)\)\=:E185/
      " 主题不存在，尝试使用默认主题
      echohl WarningMsg
      echomsg '主题 ' . g:theme_name . ' 未找到，使用默认主题'
      echohl None
      try
        colorscheme default
      catch
        " 如果默认主题也不存在，至少设置背景色
        if g:theme_mode ==# 'light' || g:theme_mode ==# 'day'
          set background=light
        else
          set background=dark
        endif
      endtry
    catch
      " 其他错误
      echohl ErrorMsg
      echomsg '应用主题时出错: ' . v:exception
      echohl None
    endtry
  endif
  
  " 显示切换结果
  let l:status = '主题模式: ' . g:theme_mode_override
  if exists('g:theme_name')
    let l:status .= ' | 主题: ' . g:theme_name
  endif
  let l:status .= ' | 背景: ' . g:theme_mode
  echo l:status
endfunction

" 强制切换到日间主题（PaperColor + light 背景）
function! SetDayTheme()
  let g:theme_mode_override = 'day'
  let g:theme_mode = 'light'
  
  " 设置主题名称
  call s:set_theme()
  
  " 加载并应用主题
  call s:load_theme()
  
  " 强制应用主题
  if exists('g:theme_name') && !empty(g:theme_name)
    try
      set background=light
      execute 'colorscheme ' . g:theme_name
    catch /^Vim\%((\a\+)\)\=:E185/
      echohl WarningMsg
      echomsg '主题 ' . g:theme_name . ' 未找到'
      echohl None
      set background=light
    endtry
  endif
  
  echo '已切换到日间主题: ' . (exists('g:theme_name') ? g:theme_name : '未知') . ' (背景: light)'
endfunction

" 强制切换到夜间主题（Gruvbox + dark 背景）
function! SetNightTheme()
  let g:theme_mode_override = 'night'
  let g:theme_mode = 'dark'
  
  " 设置主题名称
  call s:set_theme()
  
  " 加载并应用主题
  call s:load_theme()
  
  " 强制应用主题
  if exists('g:theme_name') && !empty(g:theme_name)
    try
      set background=dark
      execute 'colorscheme ' . g:theme_name
    catch /^Vim\%((\a\+)\)\=:E185/
      echohl WarningMsg
      echomsg '主题 ' . g:theme_name . ' 未找到'
      echohl None
      set background=dark
    endtry
  endif
  
  echo '已切换到夜间主题: ' . (exists('g:theme_name') ? g:theme_name : '未知') . ' (背景: dark)'
endfunction

" 切换到自动模式
function! SetAutoTheme()
  let g:theme_mode_override = 'auto'
  call s:set_theme()
  call s:load_theme()
  echo '已切换到自动模式，当前主题: ' . g:theme_name
endfunction

"==============================================================
" 7. 自动切换功能（根据时间自动切换主题和背景）
"==============================================================
function! s:check_and_switch_theme() abort
  if g:theme_mode_override !=# 'auto'
    return
  endif
  
  " 检查当前时间，确定应该使用的模式
  let l:should_be_day = s:is_daytime()
  let l:current_is_day = (g:theme_mode ==# 'light' || g:theme_mode ==# 'day')
  
  " 如果模式需要切换，则切换主题和背景
  if l:should_be_day != l:current_is_day
    let g:theme_mode = l:should_be_day ? 'light' : 'dark'
    call s:set_theme()
    call s:load_theme()
  endif
endfunction

"==============================================================
" 8. 初始化
"==============================================================
" 设置主题（在插件加载后执行）
call s:set_theme()

" 加载主题（在 VimEnter 时执行，确保所有插件已加载）
augroup ThemeLoad
  autocmd! VimEnter * nested call s:load_theme()
  " 定期检查并自动切换（在 CursorHold 时检查）
  autocmd! CursorHold * call s:check_and_switch_theme()
augroup END

" 如果是在配置重新加载时（插件已存在），延迟加载主题
" 使用 timer 确保插件已完全加载
if exists('g:loaded_plugin_bootstrap')
  " 延迟加载，确保插件已完全初始化
  if has('timers')
    call timer_start(100, {-> s:load_theme()})
  else
    call s:load_theme()
  endif
endif







