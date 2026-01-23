" =======================================================
" [Startify] 启动页高级配置
" =======================================================

" 1. 会话存储位置 (自动保存/加载工作区)
let g:startify_session_dir = '~/.vim/session'

" 2. 布局清单 (核心)
" 这里决定了启动页显示哪些板块，顺序很重要
let g:startify_lists = [
      \ { 'type': 'files',     'header': ['   MRU (最近打开文件)']            },
      \ { 'type': 'dir',       'header': ['   MRU (当前目录最近) ' . getcwd()] },
      \ { 'type': 'sessions',  'header': ['   Sessions (会话)']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks (书签)']      },
      \ { 'type': 'commands',  'header': ['   Commands (命令)']       },
      \ ]

" 3. 界面美化
let g:startify_padding_left = 3            " 左边距
let g:startify_files_number = 6            " 每个列表显示多少个文件
let g:startify_enable_special = 1          " 隐藏 'Empty Buffer' 和 'Quit' 这种没用的选项

" 4. 自动功能
let g:startify_update_oldfiles = 1         " 打开文件时自动更新列表
let g:startify_change_to_vcs_root = 1      " 打开文件时自动切换到 Git 根目录 (非常实用!)
let g:startify_session_persistence = 1     " 自动保存/更新会话 (退出 Vim 时保存会话变更)
let g:startify_fortune_use_unicode = 1     " 允许名言中使用 Unicode 字符

" 5. 自定义 Header (ASCII 艺术字)
let g:startify_custom_header = [
      \ '     ,_---~~~~~----._',
      \ '  _,,_,*^____      _____``*g*\"*,',
      \ ' / __/ /''     ^.  /      \ ^@q   f',
      \ '[  @f | @))    |  | @))   l  0 _/',
      \ ' \`/   \~____ / __ \_____/    \',
      \ '  |           _l__l_           I',
      \ '  }          [______]           I',
      \ '  ]            | | |            |',
      \ '  ]             ~ ~             |',
      \ '  |                            |',
      \ '   |                           |',
      \ '        还在Go 还在Go',
      \ '',
      \ '',
      \ ]

" 6. devicons 集成
" 让 Startify 显示文件图标 (必须确保安装了 vim-devicons)
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
