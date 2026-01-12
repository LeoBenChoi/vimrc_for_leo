"==============================================================
" config/plugins/rainbow.vim
" Rainbow 彩虹括号配置：仅保留颜色配置和启用配置
" 注意：真正的启动调用在 config/ui/theme.vim 中
"==============================================================

if exists('g:loaded_rainbow_config')
    finish
endif
let g:loaded_rainbow_config = 1

" 启用 Rainbow
let g:rainbow_active = 1

" 根据背景色（深色/浅色）设置不同的括号颜色（全局函数）
" 深色主题：使用暖色调（红色、橙色、黄色、粉色），在深色背景下更清晰可见
" 浅色主题：使用冷色调（蓝色、绿色、青色），在浅色背景下更清晰可见
function! SetRainbowColors() abort
  if &background ==# 'dark'
    " 深色主题：浅色调（浅蓝色、浅绿色、浅青色、浅紫色）
    let g:rainbow_conf = {
    \	'guifgs': ['lightblue', 'lightcyan', 'lightgreen', 'lightmagenta'],
    \	'ctermfgs': ['lightblue', 'lightcyan', 'lightgreen', 'lightmagenta'],
    \	'operators': '_,_',
    \	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
    \	'separately': {
    \		'*': {},
    \		'tex': {
    \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
    \		},
    \		'lisp': {
    \			'guifgs': ['lightblue', 'lightcyan', 'lightgreen', 'lightmagenta', 'lightsteelblue'],
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
call SetRainbowColors()

" 在主题切换和背景色变化时重新设置颜色
augroup RainbowColors
    autocmd!
    autocmd ColorScheme * call SetRainbowColors()
    autocmd OptionSet background call SetRainbowColors()
augroup END
