"==============================================================
" config/plugins/plugins.vim
" 插件管理：使用 vim-plug 管理插件
"==============================================================

"==============================================================
" 插件目录设置
"==============================================================
call plug#begin('~/.vim/plugged')

"==============================================================
" 插件列表
"==============================================================

" 模糊查找
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" 快速注释
Plug 'tpope/vim-commentary'

" 光标下单词高亮
Plug 'itchyny/vim-cursorword'

" --- Git 集成 ---
" Git 命令封装 (必装)
Plug 'tpope/vim-fugitive'
" 提交历史浏览器 (依赖 fugitive)
Plug 'junegunn/gv.vim'
" 左侧行号旁显示修改状态 (增/删/改)
Plug 'airblade/vim-gitgutter'

" 彩虹括号
Plug 'luochen1990/rainbow'

" 文件树浏览器
Plug 'preservim/nerdtree'

" 状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" 主题
Plug 'morhetz/gruvbox'

" LSP 和代码补全
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 代码大纲视图
Plug 'liuchengxu/vista.vim'

" 启动屏幕
Plug 'mhinz/vim-startify'

"==============================================================
" 插件配置结束
"==============================================================
call plug#end()

"==============================================================
" 插件安装后自动执行（可选）
"==============================================================
" 在首次安装插件后，可以在这里添加一些自动执行的命令
" autocmd User PlugInstallDone call plug#load('插件名')
