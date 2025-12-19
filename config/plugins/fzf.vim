"==============================================================
" config/plugins/fzf.vim
" FZF 模糊搜索配置：使用默认配置
"==============================================================

if exists('g:loaded_fzf_config')
    finish
endif
let g:loaded_fzf_config = 1

" 使用 fzf 插件的默认配置
" 如需自定义，可以在此处添加更多配置

let g:fzf_vim = {}

"==============================================================
" Windows 预览窗口配置
"==============================================================
" 在 Windows 上，Git Bash 路径已在 .vimrc 中提前配置
" 如果 preview_bash 未设置或找不到，则禁用预览窗口

" 默认额外按键绑定
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" 操作可以是处理选定行的函数的引用
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
  copen
  cc
endfunction

" FZF 默认布局
" - 弹窗窗口（居中居屏）
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" - 弹窗窗口（居当前窗口中心）
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true } }

" - 弹窗窗口（锚定在当前窗口底部）
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }

" 必需参数：
" - width [浮点 0 ~ 1 或整数 8 以上]
" - height [浮点 0 ~ 1 或整数 4 以上]
"
" 可选参数：
" - xoffset [浮点 默认0.5 范围 0~1]
" - yoffset [浮点 默认0.5 范围 0~1]
" - relative [布尔 默认v:false]
" - border [字符串 默认 'rounded'] 边框样式
"   - 'rounded' / 'sharp' / 'horizontal' / 'vertical' / 'top' / 'bottom' / 'left' / 'right'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" 参见 man fzf 中 `--tmux` 选项说明
" [center|top|bottom|left|right][,SIZE[%]][,SIZE[%]]
if exists('$TMUX')
    let g:fzf_layout = { 'tmux': '90%,70%' }
else
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif


" - 通过 Vim 命令开启新窗口
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10new' }

" 配色：自定义 FZF 颜色以匹配你的配色方案
" - fzf#wrap 会把这转换为 `--color` 选项
let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'query':   ['fg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }

" 启用每个命令独立历史记录
" - 历史文件将存储在以下目录（fzf-history 目录）
" - 当设置后，CTRL-N 和 CTRL-P 映射为切换历史记录而不是上下
" - 所有平台统一使用 ~/.vim/fzf-history
let g:fzf_history_dir = expand('~/.vim/fzf-history')

" seoul256 配色方案下的终端色
if has('nvim')
    let g:terminal_color_0 = '#4e4e4e'
    let g:terminal_color_1 = '#d68787'
    let g:terminal_color_2 = '#5f865f'
    let g:terminal_color_3 = '#d8af5f'
    let g:terminal_color_4 = '#85add4'
    let g:terminal_color_5 = '#d7afaf'
    let g:terminal_color_6 = '#87afaf'
    let g:terminal_color_7 = '#d0d0d0'
    let g:terminal_color_8 = '#626262'
    let g:terminal_color_9 = '#d75f87'
    let g:terminal_color_10 = '#87af87'
    let g:terminal_color_11 = '#ffd787'
    let g:terminal_color_12 = '#add4fb'
    let g:terminal_color_13 = '#ffafaf'
    let g:terminal_color_14 = '#87d7d7'
    let g:terminal_color_15 = '#e4e4e4'
else
    let g:terminal_ansi_colors = [
                \ '#4e4e4e', '#d68787', '#5f865f', '#d8af5f',
                \ '#85add4', '#d7afaf', '#87afaf', '#d0d0d0',
                \ '#626262', '#d75f87', '#87af87', '#ffd787',
                \ '#add4fb', '#ffafaf', '#87d7d7', '#e4e4e4'
                \ ]
endif



let g:fzf_layout = { 'down': '30%' }
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler


" 高级定制
" 重写 Files 命令，不使用预览以避免 Windows 上的 winpath 错误
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, <bang>0)

" 重写 Buffers 命令，不使用预览以避免 Windows 上的 winpath 错误
" 默认定义：call fzf#vim#buffers(<q-args>, fzf#vim#with_preview({ "placeholder": "{1}" }), <bang>0)
" 修改为：不使用 with_preview，直接调用 fzf#vim#buffers
command! -bar -bang -nargs=? -complete=buffer Buffers call fzf#vim#buffers(<q-args>, <bang>0)

" 重写 GFiles 命令，不使用预览以避免 Windows 上的 winpath 错误
" 默认定义：call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(<q-args> == "?" ? { "placeholder": "" } : {}), <bang>0)
" 修改为：不使用 with_preview，直接调用 fzf#vim#gitfiles
command! -bang -nargs=? GFiles call fzf#vim#gitfiles(<q-args>, <bang>0)

" 重写 Windows 命令，不使用预览以避免 Windows 上的 winpath 错误
" 默认定义：call fzf#vim#windows(fzf#vim#with_preview({ "placeholder": "{2}" }), <bang>0)
" 修改为：不使用 with_preview，直接调用 fzf#vim#windows
command! -bar -bang Windows call fzf#vim#windows(<bang>0)
" 同时定义 :W 作为 :Windows 的简写
command! -bar -bang W call fzf#vim#windows(<bang>0)

" 补全功能
" 使用自定义源命令完成路径
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')

" 使用自定义 spec 完成单词补全
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})

