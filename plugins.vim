call plug#begin()

" 核心插件 lsp
Plug 'neoclide/coc.nvim', {'branch': 'release'} 
" Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" 状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" 高亮单词
Plug 'itchyny/vim-cursorword'

" 主题
" Plug 'Rigellute/shades-of-purple.vim'
" Plug 'cocopon/iceberg.vim'
" Plug 'atelierbram/vim-colors_atelier-schemes'
" Plug 'shrikecode/kyotonight.vim'
" Plug 'embark-theme/vim', { 'as': 'embark', 'branch': 'main' }
" Plug 'dracula/vim', { 'as': 'dracula' }

" 彩虹括号
Plug 'luochen1990/rainbow'

" 快速注释 (gcc 注释行, gc+选区 注释块)
Plug 'tpope/vim-commentary'

" 启动页
Plug 'mhinz/vim-startify'

" 中文帮助文档（浅克隆，减轻网络中断）
Plug 'yianwillis/vimcdoc', {'depth': 1}

" 左侧显示修改标记 (+ ~ -)
Plug 'airblade/vim-gitgutter'

" Git 包装器 & 分支信息获取
Plug 'tpope/vim-fugitive'

" 符号大纲与函数列表视图
Plug 'liuchengxu/vista.vim'

" 侧边栏
Plug 'preservim/nerdtree'

" 图标 在最后
Plug 'ryanoasis/vim-devicons'

call plug#end()
