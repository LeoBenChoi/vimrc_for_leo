" ============================================================================
" 基础配置
" ============================================================================

" 编码设置
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gbk,gb2312,big5

" 文件格式
set fileformat=unix
set fileformats=unix,dos,mac

" 历史记录
set history=1000
set undolevels=1000

" ============================================================================
" 自动备份配置（集中管理）
" ============================================================================
" 备份文件目录：~/.vim/.backup/
set backup
let s:backup_dir = expand('~/.vim/.backup')
if !isdirectory(s:backup_dir)
  call mkdir(s:backup_dir, 'p', 0700)
endif
execute 'set backupdir=' . fnameescape(s:backup_dir . '//')
set backupext=.bak

" 交换文件目录：~/.vim/.swap/
set swapfile
let s:swap_dir = expand('~/.vim/.swap')
if !isdirectory(s:swap_dir)
  call mkdir(s:swap_dir, 'p', 0700)
endif
execute 'set directory=' . fnameescape(s:swap_dir . '//')

" 撤销历史目录：~/.vim/.undo/
set undofile
let s:undo_dir = expand('~/.vim/.undo')
if !isdirectory(s:undo_dir)
  call mkdir(s:undo_dir, 'p', 0700)
endif
execute 'set undodir=' . fnameescape(s:undo_dir . '//')

" 视图文件目录：~/.vim/.view/
let s:view_dir = expand('~/.vim/.view')
if !isdirectory(s:view_dir)
  call mkdir(s:view_dir, 'p', 0700)
endif
execute 'set viewdir=' . fnameescape(s:view_dir)

" viminfo 文件：~/.vim/.viminfo
" 保存标记、寄存器、历史记录等信息，用于恢复上次编辑位置
let s:viminfo_file = expand('~/.vim/.viminfo')
" viminfo 配置说明：
"   '100  : 保存 100 个文件的标记
"   <50   : 保存小于 50 行的寄存器
"   s10   : 保存小于 10KB 的寄存器
"   h     : 禁用 hlsearch（高亮搜索）恢复
"   "100  : 保存 100 个文件的标记
"   :100  : 保存 100 条命令历史
"   /100  : 保存 100 条搜索历史
"   @100  : 保存 100 条输入行历史
"   %     : 保存和恢复缓冲区列表
"   n     : 使用指定的文件名（而不是默认的 ~/.viminfo）
if has('nvim')
  " Neovim 使用 shada
  " 使用双引号字符串，双引号需要转义为 \"
  let s:shada_opts = "!,'100,<50,s10,h,\"100,:100,/100,@100,%"
  execute 'set shada=' . s:shada_opts . ',n' . fnameescape(s:viminfo_file)
else
  " Vim 使用 viminfo
  " 使用双引号字符串，双引号需要转义为 \"
  let s:viminfo_opts = "'100,<50,s10,h,\"100,:100,/100,@100,%"
  execute 'set viminfo=' . s:viminfo_opts . ',n' . fnameescape(s:viminfo_file)
endif

" 显示设置
set number                      " 显示行号
set relativenumber              " 显示相对行号
set cursorline                  " 高亮当前行
set showcmd                     " 显示命令
set showmode                    " 显示模式
set showmatch                   " 显示匹配的括号
set matchtime=1                 " 匹配括号高亮时间

" 不可见字符显示设置
" tab: 使用 |+空格 显示制表符
" trail: 使用 - 显示行尾空格
" eol: 使用 ↵ 显示行尾
" nbsp: 使用 ␣ 显示不间断空格
" extends: 使用 > 显示屏幕右侧延伸
" precedes: 使用 < 显示屏幕左侧延伸
" leadmultispace: 使用 |+空格 显示前导多个空格（Vim 8.2+）
set listchars=tab:\|\ ,trail:-,eol:↵,nbsp:␣,extends:>,precedes:<
if has('patch-8.2.3389')
    " Vim 8.2+ 支持 leadmultispace，显示前导多个空格
    set listchars+=leadmultispace:\|\ 
endif
" 默认启用 list 模式（显示不可见字符）
set list

" 搜索设置
set hlsearch                    " 高亮搜索结果
set incsearch                   " 增量搜索
set ignorecase                  " 忽略大小写
set smartcase                   " 智能大小写

" 编辑设置
set autoindent                  " 自动缩进
set smartindent                 " 智能缩进
set expandtab                   " 使用空格代替制表符
set tabstop=4                   " 制表符宽度
set shiftwidth=4                " 自动缩进宽度
set softtabstop=4               " 退格键删除的宽度
set backspace=indent,eol,start  " 退格键行为

" 界面设置
set laststatus=2                " 总是显示状态行
set ruler                       " 显示光标位置
set wildmenu                    " 命令补全菜单
set wildmode=longest:full,full  " 补全模式
set scrolloff=5                 " 光标上下保留行数
set sidescrolloff=5             " 光标左右保留列数

" 折叠设置
set foldmethod=indent           " 折叠方法
set foldlevel=99                " 默认不折叠

" 其他设置
set autoread                    " 文件被外部修改时自动重新读取
set autowrite                   " 自动保存
set hidden                      " 允许隐藏未保存的缓冲区
set mouse=a                     " 启用鼠标
set clipboard=unnamedplus       " 使用系统剪贴板（Linux/Windows）
set ttyfast                     " 快速终端连接
set lazyredraw                  " 延迟重绘

" 补全菜单设置（配合 coc.nvim 的 suggest.noselect 使用）
" 不自动选中第一项，需要手动按 Tab 选择
" noinsert: 不自动插入选中的补全项
" noselect: 不自动选中第一项
" menu: 显示补全菜单
" menuone: 即使只有一个补全项也显示菜单
set completeopt=menu,menuone,noinsert,noselect

" 颜色方案（基础设置，具体主题在 theme.vim 中配置）
syntax enable                   " 启用语法高亮
if has('termguicolors')
    set termguicolors           " 24位真彩色
endif

" 文件类型检测
filetype on
filetype plugin on
filetype indent on

" ============================================================================
" 恢复上次编辑位置
" ============================================================================
" 打开文件时自动跳转到上次编辑的位置
" 使用 viminfo 中保存的标记（'\" 表示上次编辑位置）
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif