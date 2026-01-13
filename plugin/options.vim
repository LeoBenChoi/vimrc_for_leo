" ============================================================================
" 选项配置 - Vim 基础选项设置
" 文件位置: ~/.vim/plugin/options.vim
" 说明: 此文件会在 Vim 启动时自动加载
" ============================================================================

" ============================================================================
" 显示选项
" ============================================================================

" 显示行号
set number

" 显示相对行号（可选，取消注释启用）
" set relativenumber

" 显示命令
set showcmd

" 显示匹配的括号
set showmatch
set matchtime=1

" 最后一行显示状态
set laststatus=2

" 命令行高度
set cmdheight=2

" 显示制表符和尾随空格（可选）
" set list
set listchars=tab:\|\ ,trail:-,eol:↵,nbsp:␣,extends:>,precedes:<

" ============================================================================
" 搜索选项
" ============================================================================

" 高亮搜索
set hlsearch

" 增量搜索
set incsearch

" 忽略大小写搜索
set ignorecase
set smartcase

" ============================================================================
" 编辑选项
" ============================================================================

" 自动缩进
set autoindent
set smartindent

" Tab 设置
set tabstop=4
set shiftwidth=4
set expandtab

" 自动换行（可选）
" set wrap
" set linebreak

" 允许隐藏未保存的缓冲区
set hidden

" 自动重新加载外部修改的文件
set autoread

" 退格键行为
set backspace=indent,eol,start

" ============================================================================
" 文件选项
" ============================================================================

" 编码设置
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gbk,gb2312,big5

" 文件格式
set fileformat=unix
set fileformats=unix,dos,mac

" 自动检测文件类型
filetype on
filetype plugin on
filetype indent on

" ============================================================================
" 备份和交换文件
" ============================================================================

" 禁用备份文件的原因：
" 1. 现代开发通常使用版本控制系统（Git/SVN），已有完整历史记录
" 2. 减少文件系统混乱，避免工作目录中出现大量 .bak 文件
" 3. 避免意外覆盖重要文件（备份文件可能覆盖同名文件）
" 4. 减少磁盘空间占用
"
" 如果需要启用备份文件（适用于不使用版本控制的场景）：
" set backup
" set backupdir=~/.vim/backup
" set backupext=.bak
" if !isdirectory(&backupdir)
"     call mkdir(&backupdir, 'p')
" endif

" 禁用备份文件
set nobackup
set nowritebackup

" 禁用交换文件（.swp）
" 交换文件用于崩溃恢复，但也会在工作目录产生文件
" 如果担心崩溃丢失数据，可以启用并指定目录：
" set swapfile
" set directory=~/.vim/swap
" if !isdirectory(&directory)
"     call mkdir(&directory, 'p')
" endif
set noswapfile

" ============================================================================
" 历史记录
" ============================================================================

" 命令历史记录数量
set history=1000

" 撤销历史记录（Vim 8.1+）
if has('persistent_undo')
    set undofile
    set undodir=~/.vim/undodir
    " 创建撤销目录（如果不存在）
    if !isdirectory(&undodir)
        call mkdir(&undodir, 'p')
    endif
endif

" ============================================================================
" 其他选项
" ============================================================================

" 鼠标支持（可选，取消注释启用）
" set mouse=a

" 分割窗口时新窗口在下方/右侧
set splitbelow
set splitright

" 补全菜单
set completeopt=menuone,longest,preview

" 时间格式（用于时间戳等）
set timeoutlen=500

" 更新间隔（毫秒）
set updatetime=300

" ============================================================================
" 代码规范提示列（已移至 plugin/ui.vim）
" ============================================================================

" 注意：colorcolumn 和 formatoptions 的配置已移至 plugin/ui.vim
" 这样可以更好地组织 UI 相关的配置
