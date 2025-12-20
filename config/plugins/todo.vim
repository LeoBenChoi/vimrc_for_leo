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
        " 注意：在 Windows 上不使用管道命令，避免兼容性问题
        " ripgrep 本身不会产生重复结果，除非同一行有多个匹配
        let l:grep_cmd = 'rg --column --color=always --no-messages --no-heading --sort path -i "TODO|FIXME|NOTE|XXX|HACK|BUG|WARNING"'
    elseif executable('ag')
        " 使用 ag 搜索
        let l:grep_cmd = 'ag --column --color --no-messages --noheading -i "TODO|FIXME|NOTE|XXX|HACK|BUG|WARNING"'
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
" 注册 TODO 命令
"==============================================================
command! -bang TODO call s:todo_search()
