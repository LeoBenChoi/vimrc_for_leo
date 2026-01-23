call plug#begin('~/.vim/plugged')

" === 基础与配置 ===
Plug 'tpope/vim-commentary'        " 快速注释 (gcc 注释行, gc+选区 注释块)
" === 界面美化 ===
Plug 'junegunn/seoul256.vim'       " 主题
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'luochen1990/rainbow'         " 彩虹括号
" === Git 黄金组合 ===
" 1. 核心工具：提供 :G status, :G blame 等所有 Git 操作
Plug 'tpope/vim-fugitive'
" 2. 视觉反馈：极速显示左侧增删改标记 (+ ~ -)
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
endif
" --- 智能补全 (LSP) ---
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
" === Go 开发 ===
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'   " 异步任务执行器（后台编译、测试、搜索）
" === 启动界面 ===
Plug 'mhinz/vim-startify'
" 文件树
  Plug 'preservim/nerdtree'
" 结构大纲
Plug 'liuchengxu/vista.vim'
" === 导航与搜索 ===
" FZF (使用 lambda 自动安装二进制)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" === 编码时间统计 ===
Plug 'wakatime/vim-wakatime'
" === 开发工具 ===
Plug 'dstein64/vim-startuptime', { 'on': 'StartupTime' }  " Vim 启动时间分析工具
" === 翻译 ===
Plug 'voldikss/vim-translator'
" 中文帮助文档
Plug 'yianwillis/vimcdoc'
" === 图标支持 始终最后 ===
Plug 'ryanoasis/vim-devicons'

call plug#end()