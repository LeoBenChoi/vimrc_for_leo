" ~/.vim/config/vim-plug.vim
" ========================
" vim-plug 插件定义文件
" 功能：集中管理所有插件声明
" ========================

" 确保只加载一次
if exists('g:package_manage_tool_vim_plug')
    finish
endif
let g:package_manage_tool_vim_plug = 1

" 自动安装 vim-plug（Windows 特供版）
" let s:plug_path = expand('~/.vim/autoload/plug.vim')
" if !filereadable(s:plug_path)
"     silent execute '!powershell -c "iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni \"' . s:plug_path . '\" -Force"'
"     autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
" endif

" 初始化插件系统
if has('win32') || has('win64')
    " Windows 系统使用反斜杠
    let g:plug_dir = substitute(expand('~/.vim/plugged'), '/', '\\', 'g')
else
    " Unix-like 系统使用正斜杠
    let g:plug_dir = expand('~/.vim/plugged')
endif

call plug#begin(g:plug_dir)

" >>>>>>>>> 基础增强 <<<<<<<<<
Plug 'tpope/vim-sensible'         " 合理默认设置

" >>>>>>>>> 界面美化 <<<<<<<<<
Plug 'morhetz/gruvbox'            " 经典配色
Plug 'vim-airline/vim-airline'    " 状态栏
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'     " 文件图标（需Nerd Font）

" >>>>>>>>> 高效编辑 <<<<<<<<<
Plug 'tpope/vim-commentary'       " 快速注释
" Plug 'tpope/vim-surround'         " 环绕符号操作
" Plug 'jiangmiao/auto-pairs'       " 智能括号补全

" >>>>>>>>> 文件管理 <<<<<<<<<
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' } " 文件树
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " 模糊搜索
Plug 'junegunn/fzf.vim'

" >>>>>>>>> 会话管理 <<<<<<<<<
Plug 'xolox/vim-session'    " 会话自动保存与恢复
Plug 'xolox/vim-misc'       " 会话依赖项

" >>>>>>>>> Git集成 <<<<<<<<<
Plug 'tpope/vim-fugitive'   " Git命令集成
Plug 'airblade/vim-gitgutter' " 变更标记
Plug 'junegunn/gv.vim'      " 提交历史浏览

" >>>>>>>>> 程序编写 <<<<<<<<<
" 语言服务器协议（LSP）支持
" Plug 'prabirshrestha/vim-lsp' " LSP 支持
" Plug 'mattn/vim-lsp-settings' " LSP 配置
" Plug 'prabirshrestha/asyncomplete.vim' " 异步补全
" Plug 'prabirshrestha/asyncomplete-lsp.vim' " LSP 补全源
" 或coc，lsp只能二选一
" Use release branch (recommended)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Or build from source code by using npm
" Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}


" 代码浏览与分析
Plug 'liuchengxu/vista.vim' " 代码结构浏览
Plug 'universal-ctags/ctags'  " 代码标签生成

" php lsp
Plug 'felixfbecker/php-language-server', {
            \ 'do': 'composer install && composer run-script parse-stubs',
            \ 'for': ['php']
            \ }

" html + css + js
" 语法高亮
Plug 'yuezk/vim-js'           " 更好的 JS/TS 高亮
Plug 'othree/html5.vim'       " HTML5 高亮
Plug 'ap/vim-css-color'       " CSS 颜色预览
" 工具链
Plug 'mattn/emmet-vim'        " Emmet 快速编写 HTML/CSS
Plug 'dense-analysis/ale', { 'for': ['javascript', 'html', 'css'] } " 异步语法检查
Plug 'prettier/vim-prettier'
Plug 'preservim/tagbar', { 'on': 'TagbarToggle' }   " 代码结构浏览
Plug 'othree/yajs.vim', { 'for': 'javascript' } " 更好的 JS/TS 支持（折叠）

" >>>>>>>>> 其他实用插件 <<<<<<<<<
Plug 'mhinz/vim-startify'  " 启动页
" Plug 'dstein64/vim-startuptime' " 启动时间分析
" Plug 'lambdalisue/vim-battery' " 电池状态显示

" >>>>>>>>> 性能优化 <<<<<<<<<
Plug 'vim-scripts/LargeFile' " 大文件优化

call plug#end()

" Emmet 快捷键
imap <C-e> <plug>(emmet-expand-abbr)

" Coc 快捷键
let g:coc_global_extensions = ['coc-html', 'coc-css', 'coc-tsserver']
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> <leader>rn <Plug>(coc-rename)
