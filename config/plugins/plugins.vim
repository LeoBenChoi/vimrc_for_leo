"==============================================================
" config/plugins/plugins.vim
" 插件管理：vim-plug 插件定义与配置
"==============================================================

if exists('g:loaded_plugin_bootstrap')
  finish
endif
let g:loaded_plugin_bootstrap = 1

"==============================================================
" 1. 路径设置
"==============================================================
let s:plugged_dir = expand('~/.vim/plugged')    " 插件安装目录
let s:plug_vim = expand('~/.vim/autoload/plug.vim') " vim-plug 脚本位置

"==============================================================
" 2. 加载 vim-plug
"==============================================================
if filereadable(s:plug_vim)
  execute 'source ' . fnameescape(s:plug_vim)
else
  echohl ErrorMsg
  echomsg '[vimrc] 未找到 vim-plug，请确保 ~/.vim/autoload/plug.vim 存在'
  echohl None
  finish
endif

"==============================================================
" 3. 插件定义
"==============================================================
call plug#begin(s:plugged_dir)

" FZF 模糊搜索（延迟加载：只有使用 FZF 命令时才加载）
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " FZF 核心（含二进制）
Plug 'junegunn/fzf.vim', { 'on': ['Files', 'GFiles', 'Rg', 'Buffers'] } " FZF 与 Vim 的桥接层

" LSP/补全框架（coc.nvim 需要启动时加载，不延迟）
Plug 'neoclide/coc.nvim', { 'branch': 'release' }   " LSP/补全框架

" Git 集成
Plug 'tpope/vim-fugitive'              " Git 命令集成
Plug 'airblade/vim-gitgutter'          " Git 变更标记（在侧边栏显示 Git 状态）

" 快速注释（延迟加载：只有使用注释命令时才加载）
Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' } " 快速注释

" 状态栏（需要启动时加载以显示状态）
Plug 'vim-airline/vim-airline'                      " 功能强大的状态栏（支持 coc/fugitive 集成）
Plug 'vim-airline/vim-airline-themes'               " Airline 主题包

" 主题（需要启动时加载以应用主题）
Plug 'lifepillar/vim-solarized8'                    " Solarized8 主题（支持浅色/深色）
Plug 'NLKNguyen/papercolor-theme'                   " PaperColor 主题（日间主题，浅色）
Plug 'morhetz/gruvbox'                              " Gruvbox 主题（夜间主题，深色）
Plug 'rakr/vim-one'                                 " One 主题（高对比度浅色主题，适合终端）

" 文件浏览器（延迟加载：只有打开 NERDTree 时才加载）
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' } " 经典文件浏览器（侧边栏）
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' } " NERDTree Git 状态显示
Plug 'ryanoasis/vim-devicons', { 'on': 'NERDTreeToggle' } " 文件图标（需要 Nerd Fonts）

" 代码大纲（延迟加载：只有打开 Vista 时才加载）
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }      " 代码大纲视图（支持 LSP/ctags）

" Perl 语言支持
Plug 'vim-perl/vim-perl'                            " Perl 语法高亮和缩进支持

" 启动页（需要启动时加载以显示启动界面）
Plug 'mhinz/vim-startify'                           " 美观的启动页（显示最近文件、会话等）

call plug#end()
