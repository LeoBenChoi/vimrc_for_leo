"==============================================================
" config/ui/startify.vim
" 启动页配置：vim-startify 插件设置
"==============================================================

if exists('g:loaded_startify_config')
    finish
endif
let g:loaded_startify_config = 1

"==============================================================
" 自定义头部
"==============================================================
let g:startify_custom_header = [
            \ '    _    _______ ______          __    ',
            \ '   | |  / / ___// ____/___  ____/ /__  ',
            \ '   | | / /\__ \/ /   / __ \/ __  / _ \ ',
            \ '   | |/ /___/ / /___/ /_/ / /_/ /  __/ ',
            \ '   |___//____/\____/\____/\__,_/\___/  ',
            \'',
            \ '  (ﾉ>ω<)ﾉ  Welcome to vim!  ヽ(>ω<ヽ) ',
            \ ]

"==============================================================
" 文件列表配置
"==============================================================
" 显示最近打开的文件数量
let g:startify_files_number = 10

" 显示书签
let g:startify_bookmarks = [
            \ { 'c': '~/.vim/config/vimrc.vim' },
            \ { 'i': '~/.vim/config/init/basic.vim' },
            \ { 'p': '~/.vim/config/plugins/plugins.vim' },
            \ ]

"==============================================================
" 列表配置
"==============================================================
" 自定义列表项
let g:startify_lists = [
            \ { 'type': 'files',     'header': ['   最近打开的文件'] },
            \ { 'type': 'dir',       'header': ['   当前目录: '. getcwd()] },
            \ { 'type': 'sessions',  'header': ['   会话'] },
            \ { 'type': 'bookmarks', 'header': ['   书签'] },
            \ { 'type': 'commands',  'header': ['   命令'] },
            \ ]

"==============================================================
" 命令快捷方式
"==============================================================
let g:startify_commands = [
            \ { 'up': [ '更新插件', 'PlugUpdate' ] },
            \ { 'pi': [ '安装插件', 'PlugInstall' ] },
            \ { 'pc': [ '清理插件', 'PlugClean' ] },
            \ { 'ps': [ '插件状态', 'PlugStatus' ] },
            \ ]

"==============================================================
" 会话管理
"==============================================================
" 会话保存目录
let g:startify_session_dir = '~/.vim/sessions'

" 自动保存会话
let g:startify_session_autoload = 0

" 自动保存会话
let g:startify_session_persistence = 0

"==============================================================
" 其他配置
"==============================================================
" 更新最近文件列表的时间间隔（秒）
let g:startify_update_oldfiles = 1

" 在启动页中显示相对路径
let g:startify_relative_path = 1

" 使用特殊字符
let g:startify_use_unicode = 1

" 更改目录时更新列表
let g:startify_change_to_dir = 1

" 更改到文件所在目录
let g:startify_change_to_vcs_root = 1

" 忽略某些文件类型
let g:startify_skiplist = [
            \ 'COMMIT_EDITMSG',
            \ 'bundle/.*/doc',
            \ ]
