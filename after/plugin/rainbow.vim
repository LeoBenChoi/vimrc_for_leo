" ============================================================================
" Rainbow 彩虹括号插件配置
" 文件位置: ~/.vim/after/plugin/rainbow.vim
" 说明: 此文件会在所有插件加载后自动执行，用于配置 rainbow 插件
" ============================================================================

let g:rainbow_conf = {
\	'guifgs': ['red', 'darkorange', 'yellow', 'green', 'cyan', 'lightblue', 'magenta'],
\	'ctermfgs': ['red', 'darkyellow', 'yellow', 'green', 'cyan', 'lightblue', 'magenta'],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'tex': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'lisp': {
\			'guifgs': ['red', 'darkorange', 'yellow', 'green', 'cyan', 'lightblue', 'magenta'],
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