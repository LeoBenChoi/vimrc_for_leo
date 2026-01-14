" ============================================================================
" vim-airline 状态栏插件配置
" 文件位置: ~/.vim/after/plugin/airline.vim
" 说明: 此文件会在所有插件加载后自动执行，用于配置 vim-airline 插件
" ============================================================================

" ============================================================================
" 1. 核心外观设置
" ============================================================================

" 启用 Powerline 字体 (必须安装 Nerd Fonts 或 Powerline 字体才能看到三角形箭头)
" 如果出现乱码或方框，请安装 Nerd Font（如 JetBrainsMono Nerd Font）
" 或者将此项设置为 0 使用普通字符模式
let g:airline_powerline_fonts = 1

" 设置主题
" 如果你之前安装了 seoul256，这里可以用 'seoul256'
" 其他好看的推荐: 'gruvbox', 'desert', 'molokai', 'dracula'
let g:airline_theme = 'seoul256'

" ============================================================================
" 2. Tabline 设置 (顶部的 Buffer 标签栏)
" ============================================================================

" 开启顶部标签栏 (像 IDE 一样显示打开的文件)
let g:airline#extensions#tabline#enabled = 1

" 只显示文件名，不显示冗长的路径 (unique_tail: 只有重名时才显示路径)
let g:airline#extensions#tabline#formatter = 'unique_tail'

" 显示 Buffer 编号 (方便用 :b 1 跳转，可选)
let g:airline#extensions#tabline#buffer_nr_show = 0

" ============================================================================
" 3. 集成设置 (Git & COC)
" ============================================================================

" 集成 coc.nvim: 在状态栏显示错误和警告数量
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#coc#error_symbol = 'E:'
let g:airline#extensions#coc#warning_symbol = 'W:'

" 集成 vim-gitgutter: 显示变更统计 (增加/修改/删除的行数)
let g:airline#extensions#hunks#enabled = 1

" 集成 vim-fugitive: 显示当前分支名
let g:airline#extensions#branch#enabled = 1

" ============================================================================
" 4. 精简模式 (去掉没用的信息)
" ============================================================================

" 不显示 'utf-8[unix]' 这种显而易见的信息，除非它不是 utf-8
"let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" 简化符号 (可选)
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
" 这里的符号可以根据你的字体喜好微调
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = '🔒'
let g:airline_symbols.dirty='⚡'

" ============================================================================
" 5. 右侧状态栏显示优化 (Section Z)
" ============================================================================

" 获取当前光标下字符的十六进制值（简化逻辑）
function! GetHexChar()
    let l:line = getline('.')
    let l:col = col('.') - 1
    " 检查列号是否在行内，如果不在则字符不存在，返回 NULL
    if l:col >= len(l:line) || l:col < 0
        return 'NULL'
    endif
    let l:char = l:line[l:col]
    let l:code = char2nr(l:char)
    return printf("0x%02X", l:code)
endfunction

" 优化右侧状态栏显示格式：百分比 + 行号/总行数:列号 + 当前字符十六进制
" 格式说明：
"   %p%%   : 文件位置百分比
"   %l     : 当前行号
"   %L     : 文件总行数
"   %v     : 当前列号
"   %{GetHexChar()} : 当前字符的十六进制值（小写，无前缀）
" 显示效果：50% 123/456:45 41
let g:airline_section_z = '%3p%% %l/%L:%02v|%{GetHexChar()}'
