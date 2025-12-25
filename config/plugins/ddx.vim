"==============================================================
" config/plugins/ddx.vim
" ddx.vim 配置：十六进制编辑器
" ddx = "dark deno-powered heXadecimal"
" 参考：https://github.com/Shougo/ddx.vim/blob/main/doc/ddx.txt
"==============================================================

if exists('g:loaded_ddx_config')
    finish
endif
let g:loaded_ddx_config = 1

"==============================================================
" 1. 基础配置（必须首先设置 UI）
"==============================================================

" 设置默认 UI（必须首先设置）
call ddx#custom#patch_global({
    \   'ui': 'hex',
    \ })

"==============================================================
" 2. 全局选项
"==============================================================

" length: 文件长度（0 表示完整文件，默认 1MB）
" 注意：如果文件太大，设置为 0 可能会导致冻结
" 0 表示加载完整文件
" 从文件开头开始
call ddx#custom#patch_global({
    \   'length': 0,
    \   'offset': 0,
    \ })

"==============================================================
" 3. UI 参数配置（可选）
"==============================================================

" ddx-ui-hex 的参数配置
" 可以根据需要调整以下参数
" 编码：'utf-8' 或 'cp932'
" 分割模式：'horizontal', 'vertical', 'floating', 'no'
" 分割方向：'botright', 'topleft'
" 窗口高度（horizontal 模式）
" 窗口宽度（vertical 模式，0 表示自动）
" 是否覆盖状态行
" 是否覆盖标题
call ddx#custom#patch_global({
    \   'uiParams': {
    \       'hex': {
    \           'encoding': 'utf-8',
    \           'split': 'horizontal',
    \           'splitDirection': 'botright',
    \           'winHeight': 20,
    \           'winWidth': 0,
    \           'overwriteStatusline': v:true,
    \           'overwriteTitle': v:false,
    \       },
    \   },
    \ })

"==============================================================
" 4. 快捷键映射
"==============================================================

" 打开当前文件的十六进制编辑器
function! s:OpenCurrentFileHex() abort
    " 直接使用当前文件名（相对路径或绝对路径，取决于文件如何打开）
    let l:filepath = expand('%')
    if empty(l:filepath)
        echohl ErrorMsg
        echomsg '[ddx] 当前缓冲区没有关联文件，请先保存文件或使用 :Ddx <文件路径>'
        echohl None
        return
    endif
    " 使用 fnameescape 转义特殊字符，然后传递给命令
    execute 'Ddx -path=' . fnameescape(l:filepath)
endfunction

nnoremap <silent> <Leader>hx :call <SID>OpenCurrentFileHex()<CR>

" 在 ddx-hex 模式下配置编辑快捷键
augroup DdxHexKeymaps
    autocmd!
    autocmd FileType ddx-hex call s:DdxHexKeymaps()
augroup END

function! s:DdxHexKeymaps() abort
    " 确保缓冲区可修改
    setlocal modifiable
    setlocal noreadonly
    
    " 基本编辑操作
    " 注意：这些快捷键会覆盖默认的 Vim 快捷键
    " 如果不需要，可以注释掉或修改
    nnoremap <buffer> <silent> c <Cmd>call ddx#ui#hex#do_action('change')<CR>
    nnoremap <buffer> <silent> i <Cmd>call ddx#ui#hex#do_action('insert')<CR>
    nnoremap <buffer> <silent> x <Cmd>call ddx#ui#hex#do_action('remove')<CR>
    nnoremap <buffer> <silent> p <Cmd>call ddx#ui#hex#do_action('paste')<CR>
    nnoremap <buffer> <silent> s <Cmd>call ddx#ui#hex#do_action('save')<CR>
    nnoremap <buffer> <silent> u <Cmd>call ddx#ui#hex#do_action('undo')<CR>
    nnoremap <buffer> <silent> <C-r> <Cmd>call ddx#ui#hex#do_action('redo')<CR>
    nnoremap <buffer> <silent> / <Cmd>call ddx#ui#hex#do_action('search')<CR>
    nnoremap <buffer> <silent> v <Cmd>call ddx#ui#hex#do_action('selectAddress')<CR>
    nnoremap <buffer> <silent> y <Cmd>call ddx#ui#hex#do_action('copy')<CR>
    nnoremap <buffer> <silent> q <Cmd>call ddx#ui#hex#do_action('quit')<CR>
    
    " 字符串模式
    nnoremap <buffer> <silent> cs <Cmd>call ddx#ui#hex#do_action('change', {'type': 'string'})<CR>
    nnoremap <buffer> <silent> is <Cmd>call ddx#ui#hex#do_action('insert', {'type': 'string'})<CR>
    nnoremap <buffer> <silent> /s <Cmd>call ddx#ui#hex#do_action('search', {'type': 'string'})<CR>
endfunction
