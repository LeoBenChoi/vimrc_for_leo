" ============================================================================
" UI 层配置（主题 / GUI / 状态栏 / 彩虹括号）
" ============================================================================
if exists('g:loaded_ui') || &compatible
  finish
endif
let g:loaded_ui = 1

" =======================================================
" 主题 (Theme)
" =======================================================
" 真彩色
if has('termguicolors')
  set termguicolors
endif

set background=dark

if has("gui_running")
  try
    colorscheme iceberg
  catch
    colorscheme default
  endtry
else
  try
    colorscheme iceberg
  catch
    colorscheme default
  endtry
endif

" =======================================================
" GUI 图形界面专属
" =======================================================
if has("gui_running")
  set guifont=Maple_Mono_NL_NFMono_CN:h12
  set guioptions-=m
  set guioptions-=T
  set guioptions-=e
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L
  set notitle
  " 启动时自动最大化窗口（Windows GVim）
  if has('win32') || has('win64')
    autocmd GUIEnter * simalt ~x
  endif
endif

" =======================================================
" 光标上下预留行数 (Scrolloff)
" =======================================================
" 光标距窗口顶部/底部至少保留几行，避免贴边
set scrolloff=5
set sidescrolloff=5

" =======================================================
" 状态栏 (Statusline)
" =======================================================
set laststatus=2

" 主题
"let g:airline_theme='luna'

" 只打开一个tab时，显示所有缓冲区
let g:airline#extensions#tabline#enabled = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" 图标优化
" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = ' [·]'
let g:airline_symbols.whitespace = 'Ξ'
" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''

" =======================================================
" 彩虹括号 (Rainbow)
" =======================================================
let g:rainbow_active = 1
let g:rainbow_conf = {
\   'guifgs': ['firebrick', 'darkorange2', 'goldenrod', 'seagreen3', 'darkcyan', 'royalblue3', 'darkorchid'],
\   'ctermfgs': ['red', 'darkyellow', 'yellow', 'green', 'cyan', 'blue', 'magenta'],
\   'operators': '_,_',
\   'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/'],
\   'separately': {
\       '*': {},
\       'tex': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\       },
\       'vim': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/', 'start=/(/ end=/)/'],
\       },
\       'nerdtree': 0,
\       'help': 0,
\   }
\}

" =======================================================
" vim-startify (启动页) - 自定义 banner
" =======================================================
" `vim-startify` 支持用 `g:startify_custom_header` 指定启动页自定义头部（banner）
" 这里放一份可直接使用的示例；你可以按需改数组里的每一行字符串。
let g:startify_custom_header = [
\ '__     __  ____       ____               _         ',
\ ' \ \   / / / ___|     / ___|   ___     __| |   ___  ',
\ '  \ \ / /  \___ \    | |      / _ \   / _` |  / _ \ ',
\ '   \ V /    ___) |   | |___  | (_) | | (_| | |  __/ ',
\ '    \_/    |____/     \____|  \___/   \__,_|  \___| ',
\ ' ',
\ ' ',
\ '   Welcome to vim(VS Code)',
\ ]

