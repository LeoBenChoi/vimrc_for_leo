" ~/.vim/config/theme.vim
" ========================
" THEME.VIM - 主题与界面美化
" 功能：
"   1. 主题加载与配色方案
"   2. 自适应亮/暗模式
"   3. 语法高亮增强
"   4. 界面元素微调
" ========================

" 确保只加载一次
if exists('g:loaded_theme_config')
  finish
endif
let g:loaded_theme_config = 1

" ========================
" 1. 基础主题配置
" ========================

" 启用真彩色支持（终端需支持）
if has('termguicolors')
  set termguicolors
endif

" ========================
" 4. 自定义高亮组
" ========================

function! s:custom_highlights()
  " 通用高亮设置
  if !has('gui')
    highlight Normal       guibg=NONE ctermbg=NONE  " 透明背景
  endif
  highlight LineNr       guifg=#5c6370 ctermfg=242
  highlight CursorLineNr guifg=#e5c07b ctermfg=214 gui=bold cterm=bold

  " 特殊语法高亮增强
  highlight! link TSVariable Identifier
  highlight! link TSParameter Special

  " Git 相关高亮
  highlight GitGutterAdd    guifg=#98c379 ctermfg=114
  highlight GitGutterChange guifg=#61afef ctermfg=75
  highlight GitGutterDelete guifg=#e06c75 ctermfg=168

  " 诊断信息高亮
  highlight DiagnosticError guifg=#e06c75 ctermfg=168
  highlight DiagnosticWarn  guifg=#e5c07b ctermfg=180
endfunction

" 终端推荐的主题
" habamax
" koehler
" lunaperche
if !has('gui_running') && (has('win32') || has('win64'))
  colorscheme lunaperche
  call s:custom_highlights() 
  finish
endif

" 根据时间切换主题深浅色
let hour = strftime("%H")
if hour >= 7 && hour < 19
    let g:theme_mode = 'light'  " 'dark' 或 'light'
else
    let g:theme_mode = 'dark'  " 'dark' 或 'light'
endif

" 默认主题设置
let g:theme_name = 'gruvbox'

" ========================
" 2. 主题加载函数
" ========================

function! s:load_theme()
  try
        " 加载主题包
    execute 'colorscheme ' . g:theme_name
    
    " 特殊主题配置
    if g:theme_name ==# 'gruvbox'
      let g:gruvbox_contrast_dark = 'medium'
      let g:gruvbox_italic = 1
    elseif g:theme_name ==# 'onedark'
      let g:onedark_terminal_italics = 1
    endif
  catch /^Vim\%((\a\+)\)\=:E185/
  " g未安装以上主题则提示
    " echohl ErrorMsg
    " echo '主题 ' . g:theme_name . ' 未安装，使用默认主题'
    " echohl None
    colorscheme default
    colorscheme retrobox
    " 切换 light放主题后，以防被主题强制改回 light 或 dark
    execute 'set background=' . g:theme_mode
  endtry
endfunction
call s:load_theme()

" ========================
" 3. 亮/暗模式切换（迁移到mapping里）
" ========================

function! ToggleThemeMode()
if g:theme_mode ==# 'dark'
    let g:theme_mode = 'light'
  else
    let g:theme_mode = 'dark'
  endif
  execute 'set background=' . g:theme_mode
  call s:load_theme()
  " call s:custom_highlights() " 重新应用自定义高亮
    

endfunction

" ========================
" 5. 状态栏与标签栏美化
" ========================

  " 方法2：检查全局变量（适用于所有插件管理器）
  if exists('g:loaded_airline') && exists('g:loaded_airline_themes')
    " airline 主题配置
let g:airline_theme = g:theme_name
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
    else 
    "echohl WarningMsg
    " echomsg "[theme.vim] vim-airline-themes 未安装，状态栏主题未配置"
    "echohl None
  endif

" 标签栏样式
highlight TabLine      guifg=#5c6370 guibg=#282c34 gui=NONE
highlight TabLineSel   guifg=#abb2bf guibg=#3e4452 gui=BOLD
highlight TabLineFill  guifg=NONE    guibg=#282c34 gui=NONE