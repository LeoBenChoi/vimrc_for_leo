" 初始化插件系统
if has('win32') || has('win64')
    " Windows 系统使用反斜杠
    let g:plug_dir = substitute(expand('~/.vim/plugged'), '/', '\\', 'g')
else
    " Unix-like 系统使用正斜杠
    let g:plug_dir = expand('~/.vim/plugged')
endif

call plug#begin(g:plug_dir)

" >>>>>>>>> 文件管理 <<<<<<<<<
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }               " 文件树
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }   " 模糊搜索
Plug 'junegunn/fzf.vim'                                             " fzf.vim 集成 调用vim-fugitive 调用ctags

" >>>>>>>>> 界面美化 <<<<<<<<<
Plug 'morhetz/gruvbox'                      " 经典配色
" Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'              " 状态栏
Plug 'vim-airline/vim-airline-themes'
" 文件图标(需Nerd Font) (需要在NERDTree | vim-airline | CtrlP | powerline | Denite | unite | lightline.vim | vim-startify | vimfiler | flagship
Plug 'ryanoasis/vim-devicons'

" >>>>>>>>> Git集成 <<<<<<<<<
Plug 'tpope/vim-fugitive'       " Git命令集成
Plug 'airblade/vim-gitgutter'   " Git变更标记
Plug 'junegunn/gv.vim'          " 提交历史浏览

" >>>>>>>>> 程序编写 <<<<<<<<<
" 语言服务器协议（LSP）支持
" Plug 'prabirshrestha/vim-lsp' " LSP 支持
" Plug 'mattn/vim-lsp-settings' " LSP 配置
" Plug 'prabirshrestha/asyncomplete.vim' " 异步补全
" Plug 'prabirshrestha/asyncomplete-lsp.vim' " LSP 补全源
" 或coc，lsp只能二选一
" Use release branch (recommended)
Plug 'neoclide/coc.nvim', {'branch': 'release'} " 代码补全
Plug 'weirongxu/coc-explorer'                   " 文件树
" Plug 'kevinoid/vim-jsonc'                     " 支持 JSONC 语法高亮和注释

" >>>>>>>>> 高效编辑 <<<<<<<<<
Plug 'preservim/nerdcommenter'         " 代码注释
" Plug 'tomtom/tcomment_vim'          " 代码注释
Plug 'ap/vim-css-color'             " 高亮颜色
" Plug 'ycm-core/YouCompleteMe'     " 代码大纲
" Plug 'ubaldot/vim-outline'        " 代码大纲
Plug 'liuchengxu/vista.vim'       " 代码大纲
" Plug 'majutsushi/tagbar'          " 代码大纲（严重拖慢启动速度）
" Plug 'preservim/tagbar'           " 代码大纲（冲突）

" Plug 'FittenTech/fittencode.vim'    " AI 代码补全(使用体验较为单一，暂时弃用)

" vue 相关
" Plug 'mattn/emmet-vim'                        " HTML快速编写
" Plug 'posva/vim-vue'       " vue 语法和高亮 会导致注释出现问题

" >>>>>>>>> 其他实用插件 <<<<<<<<<
" Plug 'mhinz/vim-startify'  " 启动页
" Plug 'wakatime/vim-wakatime'    " 代码时间统计,需要在 ~/.wakatime.cfg 配置 API 密钥
" Plug 'dstein64/vim-startuptime' " 启动时间分析
" Plug 'lambdalisue/vim-battery' " 电池状态显示

call plug#end()

" wakatime 配置
" let g:wakatime_show_status_bar_icon = 0   " 隐藏状态栏图标
let g:wakatime_cli_path = expand('~/.wakatime/wakatime-cli.exe') " 替换为你的 wakatime CLI 实际路径
" let g:wakatime_debug = 1    " 调试模式

" Vista 配置
let g:vista_default_executive = 'coc' " ctags 或 'coc'
" 设置 vista.vim 在使用 coc 作为执行器时等待的毫秒数
" 建议值：100-300 毫秒，您可以根据实际情况调整
let g:vista_coc_executive_delay = 200

" NERD Commenter 配置
" 创建默认映射
let g:NERDCreateDefaultMappings = 1
" 默认在注释分隔符后添加空格
let g:NERDSpaceDelims = 1
" 使用紧凑语法美化多行注释
let g:NERDCompactSexyComs = 1
" 将行内注释分隔符左对齐而非跟随代码缩进
let g:NERDDefaultAlign = 'left'
" 设置语言默认使用替代分隔符
let g:NERDAltDelims_java = 1
" 添加自定义格式或覆盖默认设置
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" 允许注释和反转空行（注释区域时有用）
let g:NERDCommentEmptyLines = 1
" 启用取消注释时的尾随空格修剪
let g:NERDTrimTrailingWhitespace = 1
" 启用 NERDCommenterToggle 以检查所有选中行是否被注释
let g:NERDToggleCheckAllLines = 1
