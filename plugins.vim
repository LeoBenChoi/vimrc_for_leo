call plug#begin()

" 核心插件 lsp
Plug 'neoclide/coc.nvim', {'branch': 'release'} 

" 状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" 主题
" Plug 'Rigellute/shades-of-purple.vim'
" Plug 'cocopon/iceberg.vim'
" Plug 'atelierbram/vim-colors_atelier-schemes'
Plug 'shrikecode/kyotonight.vim'

" 自动回到上次编辑位置
Plug 'farmergreg/vim-lastplace'

" 彩虹括号
Plug 'luochen1990/rainbow'

" 快速注释 (gcc 注释行, gc+选区 注释块)
Plug 'tpope/vim-commentary'

" 高亮当前光标下单词的其它出现位置
Plug 'itchyny/vim-cursorword'

" 启动页
Plug 'mhinz/vim-startify'
call plug#end()
