" ============================================================================
" Vim 主配置文件
" 文件位置: ~/.vim/vimrc.vim
" 说明: 此文件由 ~/.vimrc 入口文件加载
" ============================================================================

" === 启动计时锚点 ===
" 必须在所有配置之前记录，以获取最完整的启动耗时
let g:start_time = reltime()

" ============================================================================
" 1. 全局预设 (必须最先执行)
" ============================================================================

" 获取配置文件所在目录（更可靠的方式）
let g:vim_home_path = expand('<sfile>:p:h')

" 定义 Leader 键（必须在加载任何插件前定义！）
let mapleader = "\<Space>"
let maplocalleader = "\\"

" 禁用 netrw 目录历史记录（不生成 .netrwhist 文件）
let g:netrw_dirhistmax = 0

" ============================================================================
" 2. 插件管理 (插件列表)
" ============================================================================

call plug#begin(g:vim_home_path . '/plugged')

" === 基础与配置 ===
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'        " 快速注释 (gcc 注释行, gc+选区 注释块)

" === 界面美化 ===
Plug 'junegunn/seoul256.vim'       " 主题
Plug 'vim-airline/vim-airline'     " 状态栏
Plug 'vim-airline/vim-airline-themes'
Plug 'luochen1990/rainbow'         " 彩虹括号
Plug 'itchyny/vim-cursorword'      " 光标单词高亮

" --- 语言包集合 ---
" 提供 120+ 种语言的语法高亮和缩进支持
" 按需加载，不影响启动速度
Plug 'sheerun/vim-polyglot'

" --- 智能补全 (LSP) ---
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}

" === 导航与搜索 ===
" FZF (使用 lambda 自动安装二进制)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" 结构大纲
Plug 'liuchengxu/vista.vim'

" 文件树
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }

" === 启动界面 ===
Plug 'mhinz/vim-startify'

" === 编码时间统计 ===
Plug 'wakatime/vim-wakatime'

" 中文帮助文档
Plug 'yianwillis/vimcdoc'

" === 图标支持 (必须放在最后) ===
" 放在最后加载可以避免被 NERDTree 等插件覆盖图标逻辑
Plug 'ryanoasis/vim-devicons'



call plug#end()

" NOTE(): 这里是插件初始化的位置
" 全局开启彩虹括号
let g:rainbow_active = 1

