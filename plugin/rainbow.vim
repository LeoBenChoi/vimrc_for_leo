" Rainbow configuration
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'guis': [''],
\	'cterms': [''],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\   'separately': {
\		'*': {},
\		'vim': {
\			'parentheses_options': 'containedin=vimFuncBody',
\		},
\		'css': 0,
\       'nerdtree': 0,
\       'help': 0,
\   }
\}

au FileType * RainbowToggleOff
au FileType json RainbowToggleOn
au FileType jsonc RainbowToggleOn


