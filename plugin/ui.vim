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
set background=dark

if has("gui_running")
  try
    colorscheme gruvbox
  catch
    colorscheme default
  endtry
else
  if globpath(&rtp, 'colors/seoul256.vim') != ""
    let g:seoul256_background = 234
    silent! colorscheme iceberg
  else
    colorscheme default
  endif
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

function! StatusGitBranch() abort
  if !exists('*FugitiveHead')
    return ''
  endif
  let head = FugitiveHead()
  return empty(head) ? '' : ' ['.head.'] '
endfunction

function! StatusGitHunks() abort
  if !exists('*GitGutterGetHunkSummary')
    return ''
  endif
  let [a, m, r] = GitGutterGetHunkSummary()
  if a == 0 && m == 0 && r == 0
    return ''
  endif
  let l:summary = ''
  if a > 0 | let l:summary .= '+' . a . ' ' | endif
  if m > 0 | let l:summary .= '~' . m . ' ' | endif
  if r > 0 | let l:summary .= '-' . r . ' ' | endif
  return '[' . substitute(l:summary, ' $', '', '') . '] '
endfunction

function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)   | call add(msgs, 'E' . info['error']) | endif
  if get(info, 'warning', 0) | call add(msgs, 'W' . info['warning']) | endif
  return empty(msgs) ? '' : '[' . join(msgs, ' ') . ']'
endfunction

function! StatusCoc() abort
  let status = get(g:, 'coc_status', '')
  return empty(status) ? '' : ' (' . status . ') '
endfunction

function! StatusFileFormat() abort
  let l:fmt = &fileformat
  if l:fmt ==# 'dos'  | return 'DOS'   | endif
  if l:fmt ==# 'unix' | return 'Linux' | endif
  if l:fmt ==# 'mac'  | return 'Mac'   | endif
  return l:fmt
endfunction

set statusline=
set statusline+=%f
set statusline+=%{StatusGitBranch()}
set statusline+=%{StatusGitHunks()}
set statusline+=%m%r%h%w
set statusline+=%{StatusDiagnostic()}
set statusline+=%=
set statusline+=%{StatusCoc()}
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ [%{StatusFileFormat()}]
set statusline+=\ %-14.(%l,%c%V%)\ %P

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
