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

" 设置 coc.nvim 配置文件位置（必须在插件加载前设置）
" 使用 ~/.vim/coc-settings.json 作为配置文件
let g:coc_config_home = g:vim_home_path

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

    " === 开发工具 ===
    Plug 'https://github.com/junegunn/vim-easy-align.git' " 对齐工具
    
    " --- 语言包集合 ---
    " 提供 120+ 种语言的语法高亮和缩进支持
    " 按需加载，不影响启动速度
    Plug 'sheerun/vim-polyglot'
    
    " --- Go 开发环境 ---
    " 锁定 Tag 版本以求稳定，同时更新二进制工具
    Plug 'fatih/vim-go', { 'tag': '*', 'do': ':GoUpdateBinaries' }
    
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

    " === Git 三剑客 ===
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'junegunn/gv.vim'

    " === 启动界面 ===
    Plug 'mhinz/vim-startify'

    " === 图标支持 (必须放在最后) ===
    " 放在最后加载可以避免被 NERDTree 等插件覆盖图标逻辑
    Plug 'ryanoasis/vim-devicons'

call plug#end()

" 必要的插件初始化
" 全局开启彩虹括号
let g:rainbow_active = 1

" ============================================================================
" 3. 配置加载说明
" ============================================================================

" 注意：以下目录中的配置文件会被 Vim 自动加载，无需手动 source：
"
" 1. ~/.vim/plugin/*.vim
"    - 在启动时自动加载
"    - 适合放置：基础配置、选项设置、键位映射等
"
" 2. ~/.vim/after/plugin/*.vim
"    - 在所有插件加载后自动加载
"    - 适合放置：覆盖插件设置、后处理配置等
"
" 3. ~/.vim/ftplugin/*.vim
"    - 按文件类型自动加载
"    - 适合放置：特定文件类型的配置
"
" 如果需要手动加载配置文件，可以使用：
" if filereadable(g:vim_home_path . '/path/to/config.vim')
"     execute 'source ' . g:vim_home_path . '/path/to/config.vim'
" endif

" ============================================================================
" 4. 配置文件说明
" ============================================================================

" 当前配置文件结构：
" - plugin/options.vim  - 基础选项配置（自动加载）
" - plugin/keymaps.vim  - 键位映射配置（自动加载）
" - plugin/ui.vim       - UI、主题和字体配置（自动加载）
"
" 所有 plugin/*.vim 文件会在 vimrc.vim 加载后自动执行
