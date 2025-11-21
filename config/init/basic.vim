"==============================================================
" config/init/basic.vim
" 跨平台基础设置：无插件环境下也能安全运行
"==============================================================

if exists('g:loaded_basic_config')
  finish
endif
let g:loaded_basic_config = 1

"==============================================================
" 1. 编码策略（兼顾中英文与多平台）
"==============================================================
set encoding=utf-8                 " 内部编码统一为 UTF-8（影响脚本和寄存器）
set fileencodings=utf-8,ucs-bom,gbk,latin1
                                   " 读取文件时按优先级尝试以上编码，兼容常见中文编码

"==============================================================
" 1.1. 换行符设置（统一使用 LF）
"==============================================================
" 新文件默认使用 Unix 格式（LF）
set fileformat=unix
" 读取文件时优先识别 Unix 格式，也兼容 DOS 格式（读取后会自动转换）
set fileformats=unix,dos
" 注意：保存文件时会自动使用 fileformat 设置的格式（unix = LF）

"==============================================================
" 2. 编辑体验（不依赖任何插件）
"==============================================================
set number                         " 显示绝对行号
set relativenumber                 " 同时显示相对行号，便于跳行
set hidden                         " 允许切换 buffer 时保留未保存内容
set expandtab                      " 将 Tab 转换为空格
set tabstop=4                      " Tab 视觉宽度（只影响显示）
set shiftwidth=4                   " 自动缩进宽度
set smartcase                      " 搜索包含大写时自动切换到大小写敏感
set ignorecase                     " 默认忽略大小写，配合 smartcase 更智能
set mouse=a                        " 全模式启用鼠标（终端支持时生效）

"==============================================================
" 3. 自动备份配置（集中管理）
"==============================================================
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

"==============================================================
" 4. 预留扩展位
"==============================================================
" 可在此继续追加更多跨平台基础设置，例如剪贴板、行宽、折行等。

