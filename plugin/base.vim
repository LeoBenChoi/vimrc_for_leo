" leader 键
let mapleader = " "

" 真彩色
if (has("termguicolors"))
 set termguicolors
endif

" 语法高亮
syntax enable

" 主题设置
" colorscheme shades_of_purple
colorscheme kyotonight
let g:airline_theme='kyotonight'

" 显示绝对行号（当前行） " 显示相对行号（其他行）
set number relativenumber 

" 强制显示侧边栏
set signcolumn=yes

" 光标距窗口顶部/底部至少保留几行，避免贴边
set scrolloff=5
set sidescrolloff=5
