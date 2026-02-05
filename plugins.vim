call plug#begin(g:vim_dir . '/plugged')

" === 基础优化 ===
Plug 'tpope/vim-sensible'                       " 默认优化配置

" === 语言服务/LSP ===
Plug 'neoclide/coc.nvim', {'branch': 'release'} " 核心 LSP

" === 界面美化和辅助 ===
Plug 'mhinz/vim-startify'                       " 启动屏/仪表盘
Plug 'luochen1990/rainbow'                      " 彩虹括号
Plug 'tpope/vim-commentary'                     " 快速注释 (gcc 注释行, gc+选区 注释块)
Plug 'yianwillis/vimcdoc', {'depth': 1}         " 中文帮助文档（浅克隆，减轻网络中断）

" === Git ===
Plug 'airblade/vim-gitgutter'                  " 左侧显示修改标记 (+ ~ -)
Plug 'tpope/vim-fugitive'                      " Git 包装器 & 分支信息获取

" === 侧边栏与图标 ===
Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle'} " 侧边栏

" === 主题 ===
if !has('gui_running')
    Plug 'junegunn/seoul256.vim'                " 终端主题
endif

" === 性能分析 ===
Plug 'dstein64/vim-startuptime'                 " 启动时间分析 (按需加载)

" === 编码统计 ===
Plug 'wakatime/vim-wakatime'                    " 编码时间统计

Plug 'ryanoasis/vim-devicons'                   " 图标支持 (必须放在最后加载)
call plug#end()
