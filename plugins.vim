call plug#begin(g:vim_dir . '/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'} " 核心 LSP
Plug 'bufbuild/vim-buf'                           " Protocol Buffers / Buf 集成

Plug 'mhinz/vim-startify'                       " 启动屏/仪表盘
Plug 'luochen1990/rainbow'                      " 彩虹括号
Plug 'tpope/vim-commentary'                     " 快速注释 (gcc 注释行, gc+选区 注释块)
Plug 'itchyny/vim-cursorword'                   " 高亮当前光标下单词的其它出现位置

Plug 'yianwillis/vimcdoc', {'depth': 1}         " 中文帮助文档（浅克隆，减轻网络中断）
Plug 'airblade/vim-gitgutter'                  " 左侧显示修改标记 (+ ~ -)
Plug 'tpope/vim-fugitive'                      " Git 包装器 & 分支信息获取
Plug 'airblade/vim-rooter'                     " 自动将 cwd 设为项目根（.git 等）
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

if has('win32') || has('win64')
    " 自动化下载 clangd 独立包 (体积小，需项目内 .clangd 指定标准库路径如 MSYS2 MinGW)
    Plug 'clangd/clangd', {
        \ 'dir': g:vim_dir . '/plugged/clangd',
        \ 'do': 'curl -L -o clangd.zip https://github.com/clangd/clangd/releases/download/18.1.3/clangd-windows-18.1.3.zip && powershell -Command Expand-Archive -Force clangd.zip .; Remove-Item clangd.zip',
        \ }
    " 仅在此次 Vim 会话中把 clangd 加入 PATH，便于 coc 等调用（兼容 zip 解压后的目录名）
    let s:clangd_bin = g:vim_dir . '/plugged/clangd/clangd_18.1.3/bin'
    if !isdirectory(s:clangd_bin)
        let s:clangd_bin = g:vim_dir . '/plugged/clangd/clangd-windows-18.1.3/bin'
    endif
    if isdirectory(s:clangd_bin)
        let $PATH = s:clangd_bin . ';' . $PATH
    endif
endif

Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'cocopon/iceberg.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

"以下为一些lsp需要进行安装

" go install github.com/bufbuild/buf/cmd/buf@latest

" pip install pipx
" pipx ensurepath
" pipx install ruff
