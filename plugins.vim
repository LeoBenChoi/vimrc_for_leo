call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'} " 核心 LSP
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
Plug 'ryanoasis/vim-devicons'                       " 图标支持 (必须放在最后加载)
call plug#end()