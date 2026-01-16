" ============================================================================
" WakaTime 编码修复
" 文件位置: ~/.vim/after/plugin/wakatime.vim
" 说明: 修复 Windows 上 WakaTime 命令输出的乱码问题
" ============================================================================

" 重写 WakaTimeToday 命令以修复编码问题
function! s:FixWakaTimeToday()
    " 检查是否已加载 WakaTime 插件
    if !exists('g:loaded_wakatime')
        echoerr '[WakaTime] 插件未加载'
        return
    endif

    " 获取 WakaTime CLI 路径（使用插件内部的变量）
    " 如果插件已经初始化，尝试使用其内部变量
    let cli_path = ''
    
    " 尝试从环境变量或默认路径获取
    if exists('$WAKATIME_HOME')
        let wakatime_dir = expand('$WAKATIME_HOME') . '/.wakatime'
    else
        let wakatime_dir = expand('$HOME') . '/.wakatime'
    endif
    
    " Windows 上的实际文件名是 wakatime-cli-windows-amd64.exe
    " 但也可能被重命名为 wakatime-cli.exe
    if has('win32') || has('win64')
        " 按优先级检查多个可能的文件名
        let possible_names = [
            \ wakatime_dir . '/wakatime-cli-windows-amd64.exe',
            \ wakatime_dir . '/wakatime-cli.exe',
            \ wakatime_dir . '/wakatime-cli'
        \ ]
        
        for name in possible_names
            if filereadable(name)
                let cli_path = name
                break
            endif
        endfor
        
        " 如果都没找到，尝试使用 PATH 中的 wakatime-cli
        if empty(cli_path)
            if executable('wakatime-cli')
                let cli_path = 'wakatime-cli'
            else
                echoerr '[WakaTime] 找不到 wakatime-cli 可执行文件，请检查: ' . wakatime_dir
                return
            endif
        endif
    else
        " 非 Windows 系统
        let cli_path = wakatime_dir . '/wakatime-cli'
        if !filereadable(cli_path) && !executable(cli_path)
            if executable('wakatime-cli')
                let cli_path = 'wakatime-cli'
            else
                echoerr '[WakaTime] 找不到 wakatime-cli 可执行文件'
                return
            endif
        endif
    endif

    " 在 Windows 上使用 PowerShell 执行命令，避免编码问题
    if has('win32') || has('win64')
        " 使用 PowerShell 执行命令，PowerShell 默认使用 UTF-8
        " 使用临时文件来捕获输出，确保编码正确
        let temp_file = tempname() . '.txt'
        " 转义路径中的特殊字符
        let cli_path_escaped = substitute(cli_path, "'", "''", 'g')
        let cli_path_escaped = substitute(cli_path_escaped, '\\', '/', 'g')
        " 使用 PowerShell 执行并设置 UTF-8 编码
        let cmd = 'powershell.exe -NoProfile -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $output = & ''' . cli_path_escaped . ''' --today; [System.IO.File]::WriteAllText(''' . substitute(temp_file, '\\', '/', 'g') . ''', $output, [System.Text.Encoding]::UTF8)"'
        call system(cmd)
        
        " 读取输出文件（UTF-8 编码）
        if filereadable(temp_file)
            let output = join(readfile(temp_file, 'b'), "\n")
            call delete(temp_file)
            
            " 如果 PowerShell 方法失败或输出为空，尝试备用方法
            if empty(output)
                let temp_file2 = tempname() . '.txt'
                let cmd_fallback = 'chcp 65001 >nul && ' . shellescape(cli_path) . ' --today > ' . shellescape(temp_file2) . ' 2>&1'
                call system(cmd_fallback)
                if filereadable(temp_file2)
                    let output = join(readfile(temp_file2, 'b'), "\n")
                    call delete(temp_file2)
                endif
            endif
        else
            " 如果临时文件不存在，尝试直接执行
            let cmd_direct = shellescape(cli_path) . ' --today'
            let output = system(cmd_direct)
        endif
    else
        " 非 Windows 系统直接执行
        let cmd = shellescape(cli_path) . ' --today'
        let output = system(cmd)
    endif

    " 清理输出（移除换行符和空白）
    let output = substitute(output, '\n\+$', '', '')
    let output = substitute(output, '\r', '', 'g')
    let output = substitute(output, '^\s*', '', '')
    let output = substitute(output, '\s*$', '', '')

    " 显示结果
    if empty(output)
        echo '[WakaTime] 今天: 无数据'
    else
        echo '[WakaTime] 今天: ' . output
    endif
endfunction

" 重定义 WakaTimeToday 命令
" 使用 -bang 允许覆盖原命令
command! -nargs=0 -bang WakaTimeToday call s:FixWakaTimeToday()
