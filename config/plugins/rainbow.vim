"==============================================================
" config/plugins/rainbow.vim
" 括号彩色显示配置：rainbow 插件配置
"==============================================================

if exists('g:loaded_rainbow_config')
  finish
endif
let g:loaded_rainbow_config = 1

let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

" 根据背景色（深色/浅色）设置不同的括号颜色
" 深色主题：使用暖色调（红色、橙色、黄色、粉色），在深色背景下更清晰可见
" 浅色主题：使用冷色调（蓝色、绿色、青色），在浅色背景下更清晰可见
function! s:set_rainbow_colors() abort
  if &background ==# 'dark'
    " 深色主题：暖色调（红色、橙色、黄色、粉色）
    let g:rainbow_conf = {
    \	'guifgs': ['firebrick', 'darkorange3', 'gold', 'hotpink'],
    \	'ctermfgs': ['red', 'yellow', 'magenta', 'lightred'],
    \	'operators': '_,_',
    \	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
    \	'separately': {
    \		'*': {},
    \		'tex': {
    \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
    \		},
    \		'lisp': {
    \			'guifgs': ['firebrick', 'darkorange3', 'gold', 'hotpink', 'indianred'],
    \		},
    \		'vim': {
    \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
    \		},
    \		'html': {
    \			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
    \		},
    \		'css': 0,
    \		'nerdtree': 0,
    \	}
    \}
  else
    " 浅色主题：冷色调（蓝色、绿色、青色）
    let g:rainbow_conf = {
    \	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
    \	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
    \	'operators': '_,_',
    \	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
    \	'separately': {
    \		'*': {},
    \		'tex': {
    \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
    \		},
    \		'lisp': {
    \			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
    \		},
    \		'vim': {
    \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
    \		},
    \		'html': {
    \			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
    \		},
    \		'css': 0,
    \		'nerdtree': 0,
    \	}
    \}
  endif
endfunction

" 初始设置（根据当前背景色）
call s:set_rainbow_colors()

" 在主题切换和背景色变化时重新设置颜色
augroup RainbowColors
  autocmd!
  autocmd ColorScheme * call s:set_rainbow_colors()
  autocmd OptionSet background call s:set_rainbow_colors()
augroup END