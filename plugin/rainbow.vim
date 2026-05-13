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
