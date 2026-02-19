" ============================================================================
" UI 层配置（主题 / GUI / 状态栏 / 彩虹括号）
" ============================================================================
if exists('g:loaded_ui') || &compatible
  finish
endif
let g:loaded_ui = 1

" =======================================================
" 1. 主题 (Theme)
" =======================================================
" 真彩色
if has('termguicolors')
  set termguicolors
endif

set background=dark

if has("gui_running")
  try
    colorscheme gruvbox
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
" 2. GUI 图形界面专属
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
endif

" =======================================================
" 3. 状态栏 (Statusline)
" =======================================================
set laststatus=2

" 主题
"let g:airline_theme='luna'

" 只打开一个tab时，显示所有缓冲区
let g:airline#extensions#tabline#enabled = 1

" 行号优化
function! MyLineNumber()
  return substitute(line('.'), '\d\@<=\(\(\d\{3\}\)\+\)$', ',&', 'g'). ' | '.
    \    substitute(line('$'), '\d\@<=\(\(\d\{3\}\)\+\)$', ',&', 'g')
endfunction
call airline#parts#define('linenr', {'function': 'MyLineNumber', 'accents': 'bold'})
let g:airline_section_z = airline#section#create(['%3p%%: ', 'linenr', ':%3v'])

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
" 4. 彩虹括号 (Rainbow)
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
