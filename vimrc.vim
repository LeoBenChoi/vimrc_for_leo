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

" 设置 Leader 键为空格键
" 注意：必须在所有使用 <leader> 的映射之前定义
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" 2. 取消空格键在 Normal 模式下的默认行为 (向右移动)
" 这样可以防止按 Leader 时出现延迟或光标抖动
nnoremap <Space> <Nop>
xnoremap <Space> <Nop>

" ============================================================================
" 2. 插件管理 (插件列表)
" ============================================================================

call plug#begin(g:vim_home_path . '/plugged')

" === 基础与配置 ===
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'        " 快速注释 (gcc 注释行, gc+选区 注释块)

" === 界面美化 ===
Plug 'junegunn/seoul256.vim'       " 主题
"Plug 'vim-airline/vim-airline'     " 状态栏
"Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'       " 轻量 Git 分支名（供 airline 等状态栏使用）
Plug 'luochen1990/rainbow'         " 彩虹括号
Plug 'itchyny/vim-cursorword'      " 光标单词高亮

" git hunks 提示
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
endif

" --- 智能补全 (LSP) ---
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}

" === 启动界面 ===
Plug 'mhinz/vim-startify'

" 文件树
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }

" 结构大纲
Plug 'liuchengxu/vista.vim'

" === 导航与搜索 ===
" FZF (使用 lambda 自动安装二进制)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" === 编码时间统计 ===
Plug 'wakatime/vim-wakatime'

" === 翻译 ===
Plug 'voldikss/vim-translator'

" 中文帮助文档
Plug 'yianwillis/vimcdoc'

" === 图标支持 (必须放在最后) ===
" 放在最后加载可以避免被 NERDTree 等插件覆盖图标逻辑
Plug 'ryanoasis/vim-devicons'

call plug#end()

" 启动时间：VimEnter 时冻结，供 lightline 等状态栏显示固定值（避免持续递增到 10s）
augroup startup_time
    autocmd!
    autocmd VimEnter * call startup_time#freeze()
augroup END

" NOTE(): 这里是插件初始化的位置
" 全局开启彩虹括号
let g:rainbow_active = 1

" ============================================================================
" TODO 管理 (基于 FZF + Rg，零插件)
" ============================================================================

" =======================================================
" 自定义 TODO 检索命令 (基于 FZF + Rg)
" =======================================================
" 搜索关键词：TODO, FIXME, XXX, BUG, HACK
" 也就是搜索这些全大写的单词
command! -bang -nargs=0 Todo
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- "TODO|FIXME|XXX|BUG|HACK"', 1,
  \   fzf#vim#with_preview(), <bang>0)

" =======================================================
" 原生 TODO 高亮 (无需插件)
" =======================================================
augroup vim_todo_highlight
  autocmd!
  " 在所有文件类型的注释中，匹配这些关键词
  autocmd Syntax * syntax keyword MyTodo TODO FIXME XXX BUG HACK containedin=.*Comment,.*String
  " 将其链接到 Vim 内置的 Todo 高亮组 (通常是显眼的黄色或红色)
  autocmd Syntax * hi def link MyTodo Todo
augroup END

