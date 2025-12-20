"==============================================================
" config/plugins/todo.vim
" TODO 搜索功能：使用 FZF 搜索代码中的 TODO 注释
"==============================================================

if exists('g:loaded_todo_config')
    finish
endif
let g:loaded_todo_config = 1

" 检查 fzf 是否已加载
if !exists('g:loaded_fzf_config')
    echohl WarningMsg
    echomsg '[todo.vim] 警告: fzf.vim 未加载，TODO 功能需要 fzf 支持'
    echohl None
    finish
endif

"==============================================================
" TODO 搜索函数
"==============================================================
function! s:todo_search() abort
    " 检测可用的搜索工具（优先使用 ripgrep，其次 ag）
    let l:grep_cmd = ''
    
    if executable('rg')
        " 使用 ripgrep 搜索 TODO、FIXME、NOTE、XXX、HACK 等注释
        " --column: 显示列号
        " --color=always: 保持颜色（fzf 需要）
        " -i: 忽略大小写
        " --no-messages: 不显示错误信息
        " --no-heading: 不显示文件头（避免重复）
        " --sort path: 按路径排序
        " -e: 使用多个 -e 参数指定模式，避免 Windows PowerShell 解析管道符的问题
        let l:grep_cmd = 'rg --column --color=always --no-messages --no-heading --sort path -i -e "TODO" -e "FIXME" -e "NOTE" -e "XXX" -e "HACK" -e "BUG" -e "WARNING"'
    elseif executable('ag')
        " 使用 ag 搜索
        " -e: 使用多个 -e 参数指定模式，避免 Windows PowerShell 解析管道符的问题
        let l:grep_cmd = 'ag --column --color --no-messages --noheading -i -e "TODO" -e "FIXME" -e "NOTE" -e "XXX" -e "HACK" -e "BUG" -e "WARNING"'
    else
        echohl ErrorMsg
        echomsg '[todo.vim] 错误: 未找到搜索工具 (rg/ag)，请安装 ripgrep 或 ag'
        echohl None
        return
    endif

    " 检测当前主题是否为浅色主题
    let l:is_light = &background ==# 'light'
    
    " 配置 fzf 选项
    " - 窗口在底部显示（使用 down 布局）
    " - 高度为 30%
    let l:spec = {
        \ 'down': '30%',
        \ 'options': ['--prompt', 'TODO> ']
    \ }
    
    " 为浅色主题添加自定义配色，确保足够的对比度
    if l:is_light
        " 浅色主题配色：参考 seoul256 light 主题，确保高对比度
        " bg+: 选中行背景色（浅灰色 #D9D9D9，与深色前景形成对比）
        " fg+: 选中行前景色（深灰色 #616161，确保在浅色背景上可读）
        " bg: 普通行背景色（白色 #FFFFFF）
        " fg: 普通行前景色（深灰色 #616161，确保在浅色背景上可读）
        " hl: 高亮颜色（深绿色 #719872，用于匹配文本）
        " hl+: 选中行高亮颜色（深绿色 #719899，用于匹配文本）
        call extend(l:spec.options, [
            \ '--color', 'fg:#616161,fg+:#616161,bg:#FFFFFF,bg+:#D9D9D9',
            \ '--color', 'hl:#719872,hl+:#719899,border:#E1E1E1',
            \ '--color', 'prompt:#0099BD,pointer:#E12672,marker:#E17899',
            \ '--color', 'info:#727100,spinner:#719899,header:#719872'
        \ ])
    endif

    " 使用 fzf#vim#grep 函数，它会自动处理结果格式和跳转
    " 参数: grep_command, [spec], [fullscreen]
    " spec 字典中的 'down' 键会设置窗口在底部显示
    call fzf#vim#grep(l:grep_cmd, l:spec, 0)
endfunction

"==============================================================
" TODO 文件搜索函数（仅搜索当前文件）
"==============================================================
function! s:todo_file_search() abort
    " 检查是否有当前文件
    if empty(expand('%'))
        echohl ErrorMsg
        echomsg '[todo.vim] 错误: 当前没有打开的文件'
        echohl None
        return
    endif

    " 获取当前文件的绝对路径并转义
    let l:file_path = expand('%:p')
    " 在 Windows 上，手动用双引号包裹路径，并转义路径中的双引号
    " 这样可以确保在 PowerShell 中正确解析
    if has('win32') || has('win64')
        " 转义路径中的双引号（将 " 替换为 ""）
        let l:file_path_escaped = '"' . substitute(l:file_path, '"', '""', 'g') . '"'
    else
        " Unix 系统使用 shellescape
        let l:file_path_escaped = shellescape(l:file_path)
    endif
    
    " 检测可用的搜索工具（优先使用 ripgrep，其次 ag）
    let l:grep_cmd = ''
    
    if executable('rg')
        " 直接复用 todo_search 的逻辑，只需在命令后添加文件路径
        " 注意：移除 --sort path，因为只有一个文件，不需要排序
        " -e: 使用多个 -e 参数指定模式，避免 Windows PowerShell 解析管道符的问题
        let l:grep_cmd = 'rg --column --color=always --no-messages --no-heading -i -e "TODO" -e "FIXME" -e "NOTE" -e "XXX" -e "HACK" -e "BUG" -e "WARNING" ' . l:file_path_escaped
    elseif executable('ag')
        " 直接复用 todo_search 的逻辑，只需在命令后添加文件路径
        " -e: 使用多个 -e 参数指定模式，避免 Windows PowerShell 解析管道符的问题
        let l:grep_cmd = 'ag --column --color --no-messages --noheading -i -e "TODO" -e "FIXME" -e "NOTE" -e "XXX" -e "HACK" -e "BUG" -e "WARNING" ' . l:file_path_escaped
    else
        echohl ErrorMsg
        echomsg '[todo.vim] 错误: 未找到搜索工具 (rg/ag)，请安装 ripgrep 或 ag'
        echohl None
        return
    endif

    " 检测当前主题是否为浅色主题
    let l:is_light = &background ==# 'light'
    
    " 配置 fzf 选项（与 todo_search 相同，只是 prompt 不同）
    let l:spec = {
        \ 'down': '30%',
        \ 'options': ['--prompt', 'TODOFile> ']
    \ }
    
    " 为浅色主题添加自定义配色（与 todo_search 相同）
    if l:is_light
        call extend(l:spec.options, [
            \ '--color', 'fg:#616161,fg+:#616161,bg:#FFFFFF,bg+:#D9D9D9',
            \ '--color', 'hl:#719872,hl+:#719899,border:#E1E1E1',
            \ '--color', 'prompt:#0099BD,pointer:#E12672,marker:#E17899',
            \ '--color', 'info:#727100,spinner:#719899,header:#719872'
        \ ])
    endif

    " 使用 fzf#vim#grep 函数，它会自动处理结果格式和跳转
    call fzf#vim#grep(l:grep_cmd, l:spec, 0)
endfunction

"==============================================================
" 注册 TODO 命令
"==============================================================
command! -bang TODO call s:todo_search()
command! -bang TODOFile call s:todo_file_search()
