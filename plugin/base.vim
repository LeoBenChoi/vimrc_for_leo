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

" 开启 wildmenu (基础必须)
" 允许按下 Tab 键时显示补全列表
set wildmenu

" 定义补全行为
" longest: 先补全到最长的公共字符串
" full:    如果还有多种可能，触发菜单
" full:    再次按 Tab 在菜单中循环
set wildmode=longest:full,full

" 启用竖向弹出菜单 (PopUp Menu)
if has("patch-8.2.4325") || has('nvim')
    set wildoptions=pum
    if exists('&pumblend')
        set pumblend=10
    endif
endif