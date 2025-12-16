"==============================================================
" config/plugins/fzf.vim
" FZF 模糊搜索配置：文件、内容、缓冲区、Git 等搜索功能
"==============================================================

if exists('g:loaded_fzf_config')
    finish
endif
let g:loaded_fzf_config = 1

"==============================================================
" FZF 配置
"==============================================================
" 在此处添加您的 FZF 配置

" 初始化配置字典
let g:fzf_vim = {}

"==============================================================
" 窗口布局配置（解决底部信息显示不完整问题）
"==============================================================
" 将 fzf 窗口位置设置为底部（down），确保底部信息完整显示
" 格式：{ 'down': '高度' } - 高度可以是百分比（如 '40%'）或行数（如 '20'）
" 总窗口位置大小

" See `--tmux` option in `man fzf` for available options
" [center|top|bottom|left|right][,SIZE[%]][,SIZE[%]]
if exists('$TMUX')
    let g:fzf_layout = { 'tmux': '90%,70%' }
else
    let g:fzf_layout = { 'down': '~40%' }
endif

"==============================================================
" 预览窗口滚动配置
"==============================================================
" 绑定 Ctrl+Up/Down 来滚动预览窗口
" preview-up: 向上滚动预览窗口
" preview-down: 向下滚动预览窗口
" 注意：如果 ctrl-up/ctrl-down 不工作，可以尝试使用 ctrl-k/ctrl-j
" 为常用命令添加预览窗口滚动绑定
let g:fzf_vim.files_options = ['--bind', 'ctrl-up:preview-up,ctrl-down:preview-down']
let g:fzf_vim.buffers_options = ['--bind', 'ctrl-up:preview-up,ctrl-down:preview-down']
let g:fzf_vim.git_files_options = ['--bind', 'ctrl-up:preview-up,ctrl-down:preview-down']
let g:fzf_vim.grep_options = ['--bind', 'ctrl-up:preview-up,ctrl-down:preview-down']

" 如果 Ctrl+Up/Down 在您的终端中不工作，可以取消下面的注释使用替代方案：
" 使用 Ctrl+K/J 来滚动预览窗口（更兼容）
" let g:fzf_vim.files_options = ['--bind', 'ctrl-k:preview-up,ctrl-j:preview-down']
" let g:fzf_vim.buffers_options = ['--bind', 'ctrl-k:preview-up,ctrl-j:preview-down']
" let g:fzf_vim.git_files_options = ['--bind', 'ctrl-k:preview-up,ctrl-j:preview-down']
" let g:fzf_vim.grep_options = ['--bind', 'ctrl-k:preview-up,ctrl-j:preview-down']



" [缓冲区] 如果可能，跳转到已有窗口（默认：0）
let g:fzf_vim.buffers_jump = 1

" [Ag|Rg|RG] 在窄屏幕下让路径单独显示一行（默认：0）
" * 需要 Perl 且 fzf 版本 >= 0.56.0
let g:fzf_vim.grep_multi_line = 0
" 格式：PATH:LINE:COL:LINE
" let g:fzf_vim.grep_multi_line = 1
" 格式：PATH:LINE:COL:
"       LINE
" let g:fzf_vim.grep_multi_line = 2
" 格式：PATH:LINE:COL:
"       LINE
"       （每项之间有空行，需要 --gap 选项）

" 自定义 fzf 颜色以适配你的配色方案
" - fzf#wrap 会将其转换为一组 `--color` 选项
" let g:fzf_colors =
"             \ { 'fg':      ['fg', 'Normal'],
"             \ 'bg':      ['bg', 'Normal'],
"             \ 'query':   ['fg', 'Normal'],
"             \ 'hl':      ['fg', 'Comment'],
"             \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"             \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"             \ 'hl+':     ['fg', 'Statement'],
"             \ 'info':    ['fg', 'PreProc'],
"             \ 'border':  ['fg', 'Ignore'],
"             \ 'prompt':  ['fg', 'Conditional'],
"             \ 'pointer': ['fg', 'Exception'],
"             \ 'marker':  ['fg', 'Keyword'],
"             \ 'spinner': ['fg', 'Label'],
"             \ 'header':  ['fg', 'Comment'] }

" 256配色方案的终端颜色
" if has('nvim')
"     let g:terminal_color_0 = '#4e4e4e'
"     let g:terminal_color_1 = '#d68787'
"     let g:terminal_color_2 = '#5f865f'
"     let g:terminal_color_3 = '#d8af5f'
"     let g:terminal_color_4 = '#85add4'
"     let g:terminal_color_5 = '#d7afaf'
"     let g:terminal_color_6 = '#87afaf'
"     let g:terminal_color_7 = '#d0d0d0'
"     let g:terminal_color_8 = '#626262'
"     let g:terminal_color_9 = '#d75f87'
"     let g:terminal_color_10 = '#87af87'
"     let g:terminal_color_11 = '#ffd787'
"     let g:terminal_color_12 = '#add4fb'
"     let g:terminal_color_13 = '#ffafaf'
"     let g:terminal_color_14 = '#87d7d7'
"     let g:terminal_color_15 = '#e4e4e4'
" else
"     let g:terminal_ansi_colors = [
"                 \ '#4e4e4e', '#d68787', '#5f865f', '#d8af5f',
"                 \ '#85add4', '#d7afaf', '#87afaf', '#d0d0d0',
"                 \ '#626262', '#d75f87', '#87af87', '#ffd787',
"                 \ '#add4fb', '#ffafaf', '#87d7d7', '#e4e4e4'
"                 \ ]
" endif

" FZF 历史记录文件
let g:fzf_history_dir = expand('~/.vim/fzf-history')

" 创建历史记录目录（如果不存在）
if !isdirectory(g:fzf_history_dir)
    call mkdir(g:fzf_history_dir, 'p')
endif

"==============================================================
" 内容搜索：ripgrep (Rg) 配置
"==============================================================

" ripgrep 命令参数
" --column: 显示列号
" --line-number: 显示行号
" --no-heading: 不显示文件头
" --color=always: 始终显示颜色
" --smart-case: 智能大小写匹配
" --hidden: 搜索隐藏文件
" --follow: 跟随符号链接
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" 自定义 Rg 命令（如果 ripgrep 可用）
if executable('rg')
    " 使用 ripgrep 进行内容搜索
    command! -bang -nargs=* Rg
                \ call fzf#vim#grep(
                \   'rg --column --line-number --no-heading --color=always --smart-case --hidden --follow '.shellescape(<q-args>),
                \   1,
                \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%'),
                \   <bang>0)
else
    " 如果 ripgrep 不可用，使用 grep 作为后备
    " 静默记录到消息历史，不显示（可通过 :messages 查看）
    silent! echohl WarningMsg
    silent! echomsg '[环境检测] ripgrep (rg) 未安装，<Space>fr 命令将无法使用'
    silent! echomsg '[安装方法] Windows: choco install ripgrep 或 scoop install ripgrep'
    silent! echomsg '[安装方法] 或访问: https://github.com/BurntSushi/ripgrep/releases'
    silent! echomsg '[FZF] ripgrep (rg) 未安装，内容搜索功能将受限'
    silent! echomsg '请安装: choco install ripgrep 或 scoop install ripgrep'
    silent! echohl None
endif

" 单独设置 :Files 使用底部窗口（高度 ~40%）
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({ 'down': '~40%' }), <bang>0)

command! -bang -nargs=? -complete=dir Buffers
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({ 'down': '~40%' }), <bang>0)

command! -bang -nargs=? -complete=dir Maps
            \ call fzf#vim#maps('n', { 'down': '~40%' }, <bang>0)


