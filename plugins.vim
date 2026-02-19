call plug#begin(g:vim_dir . '/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'} " 核心 LSP

Plug 'mhinz/vim-startify'                       " 启动屏/仪表盘
Plug 'luochen1990/rainbow'                      " 彩虹括号
Plug 'tpope/vim-commentary'                     " 快速注释 (gcc 注释行, gc+选区 注释块)
Plug 'yianwillis/vimcdoc', {'depth': 1}         " 中文帮助文档（浅克隆，减轻网络中断）
Plug 'airblade/vim-gitgutter'                  " 左侧显示修改标记 (+ ~ -)
Plug 'tpope/vim-fugitive'                      " Git 包装器 & 分支信息获取
Plug 'junegunn/fzf'                              " 模糊搜索核心引擎
Plug 'junegunn/fzf.vim'                          " FZF 的 Vim 桥接增强插件
Plug 'liuchengxu/vista.vim'                      " 符号大纲与函数列表视图
Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle'} " 侧边栏
if !has('gui_running')
    Plug 'junegunn/seoul256.vim'                " 终端主题
endif
Plug 'dstein64/vim-startuptime'                 " 启动时间分析 (按需加载)
Plug 'ryanoasis/vim-devicons'                   " 图标支持 (必须放在最后加载)

if has('win32') || has('win64')
    Plug 'LuaLS/lua-language-server', {
        \ 'dir': g:vim_dir . '/plugged/lua-language-server',
        \ 'do': 'curl -L -o lualsp.zip https://github.com/LuaLS/lua-language-server/releases/download/3.17.1/lua-language-server-3.17.1-win32-x64.zip && powershell -Command Expand-Archive -Force lualsp.zip .; Remove-Item lualsp.zip',
        \ 'tag': '3.17.1'
        \ }
endif

Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'cocopon/iceberg.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()
