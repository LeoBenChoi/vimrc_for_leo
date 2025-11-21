"==============================================================
" config/plugins/plugins.vim
" 插件管理入口：默认使用 vim-plug，便于未来替换为其他管理器
"==============================================================

if exists('g:loaded_plugin_bootstrap')
  finish
endif
let g:loaded_plugin_bootstrap = 1

"==============================================================
" 1. 目录约定
"==============================================================
let s:plugged_dir = expand('~/.vim/plugged')    " 插件安装目录
let s:plug_vim = expand('~/.vim/autoload/plug.vim') " vim-plug 脚本位置

"==============================================================
" 2. 加载 vim-plug 核心脚本
"==============================================================
" 注意：vim-plug 应该已经存在于项目中（~/.vim/autoload/plug.vim）
if filereadable(s:plug_vim)
  execute 'source ' . fnameescape(s:plug_vim)
else
  echohl ErrorMsg
  echomsg '[vimrc] 未找到 vim-plug，请确保 ~/.vim/autoload/plug.vim 存在'
  echohl None
  finish
endif

"==============================================================
" 3. 性能优化：插件延迟加载配置
"==============================================================
" 延迟加载配置：提高启动速度，按需加载插件
" 使用 { 'on': '命令' } 表示只有调用该命令时才加载插件
" 使用 { 'for': '文件类型' } 表示只有打开该文件类型时才加载插件

"==============================================================
" 4. 插件定义
"==============================================================
call plug#begin(s:plugged_dir)

" FZF 模糊搜索（延迟加载：只有使用 FZF 命令时才加载）
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " FZF 核心（含二进制）
Plug 'junegunn/fzf.vim', { 'on': ['Files', 'GFiles', 'Rg', 'Buffers'] } " FZF 与 Vim 的桥接层

" LSP/补全框架（coc.nvim 需要启动时加载，不延迟）
Plug 'neoclide/coc.nvim', { 'branch': 'release' }   " LSP/补全框架

" Git 集成（延迟加载：只有使用 Git 命令时才加载）
Plug 'tpope/vim-fugitive', { 'on': ['G', 'Git', 'Gstatus', 'Gcommit', 'Gwrite'] } " Git 集成

" 快速注释（延迟加载：只有使用注释命令时才加载）
Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' } " 快速注释

" 状态栏（需要启动时加载以显示状态）
Plug 'vim-airline/vim-airline'                      " 功能强大的状态栏（支持 coc/fugitive 集成）
Plug 'vim-airline/vim-airline-themes'               " Airline 主题包

" 主题（延迟加载：只有切换主题时才加载）
Plug 'NLKNguyen/papercolor-theme', { 'on': [] }     " PaperColor 主题（日间主题）
Plug 'morhetz/gruvbox', { 'on': [] }                " Gruvbox 主题（夜间主题）

" 文件浏览器（延迟加载：只有打开 NERDTree 时才加载）
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' } " 经典文件浏览器（侧边栏）
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' } " NERDTree Git 状态显示
Plug 'ryanoasis/vim-devicons', { 'on': 'NERDTreeToggle' } " 文件图标（需要 Nerd Fonts）

" 代码大纲（延迟加载：只有打开 Vista 时才加载）
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }      " 代码大纲视图（支持 LSP/ctags）

call plug#end()

