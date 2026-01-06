"==============================================================
" config/plugins/ctags.vim
" Ctags 配置：Tags 文件集中管理和自动更新
"==============================================================

if exists('g:loaded_ctags_config')
    finish
endif
let g:loaded_ctags_config = 1

"==============================================================
" 1. Tags 文件集中管理配置
"==============================================================
" 集中存储所有项目的 tags 文件到 ~/.vim/.tags/
let s:tags_dir = expand('~/.vim/.tags')
if !isdirectory(s:tags_dir)
    call mkdir(s:tags_dir, 'p', 0700)
endif

" 动态加载集中目录下的所有 .tags 文件
function! s:LoadCentralTagsFiles() abort
    if !isdirectory(s:tags_dir)
        return
    endif

    " 查找所有 .tags 文件
    let l:tags_files = glob(s:tags_dir . '/*.tags', 0, 1)
    if empty(l:tags_files)
        return
    endif

    " 构建 tags 路径字符串
    let l:tags_paths = []
    for l:file in l:tags_files
        " 使用绝对路径，确保 Vim 能找到
        let l:abs_path = fnamemodify(l:file, ':p')
        " Windows 路径转换为正斜杠（Vim 内部使用正斜杠）
        if has('win32') || has('win64') || has('win16')
            let l:abs_path = substitute(l:abs_path, '\\', '/', 'g')
        endif
        call add(l:tags_paths, l:abs_path)
    endfor

    " 添加到 tags 选项（放在最前面，优先级最高）
    if !empty(l:tags_paths)
        let l:central_tags = join(l:tags_paths, ',')
        " 如果 tags 选项已设置，在前面添加；否则直接设置
        if !empty(&tags)
            let &tags = l:central_tags . ',' . &tags
        else
            let &tags = l:central_tags . ',./tags,./TAGS,tags,TAGS;'
        endif
    endif
endfunction

" 设置 tags 搜索路径（按优先级顺序）：
" 1. 集中管理的 tags 目录（所有项目的 tags，优先级最高）
"   动态加载所有 .tags 文件
" 2. 当前文件所在目录的 tags 文件（项目本地）
" 3. 向上递归查找父目录的 tags 文件（传统方式）
" 注意：使用 ; 表示向上递归查找，直到找到或到达根目录
" 先设置基础路径
if has('win32') || has('win64') || has('win16')
    " Windows 下，将路径中的反斜杠转换为正斜杠（Vim 内部统一使用正斜杠）
    let s:tags_dir_normalized = substitute(s:tags_dir, '\\', '/', 'g')
    execute 'set tags=' . fnameescape(s:tags_dir_normalized . '//') . ',./tags,./TAGS,tags,TAGS;'
else
    execute 'set tags=' . fnameescape(s:tags_dir . '//') . ',./tags,./TAGS,tags,TAGS;'
endif

" 动态加载所有 .tags 文件
call s:LoadCentralTagsFiles()

" 在打开文件时重新加载（确保新生成的 tags 文件能被找到）
augroup LoadCentralTags
    autocmd! BufReadPost * call s:LoadCentralTagsFiles()
augroup END

" 说明：
" - ~/.vim/.tags/ 目录用于存储所有项目的 tags 文件
" - 建议为每个项目生成独立的 tags 文件，命名为：项目名.tags
" - 例如：~/.vim/.tags/myproject.tags
" - 生成命令示例：
"   ctags -R --output=~/.vim/.tags/myproject.tags /path/to/myproject
"   或使用相对路径：
"   cd /path/to/myproject && ctags -R --output=~/.vim/.tags/myproject.tags .

"==============================================================
" 2. Tags 文件自动更新配置
"==============================================================
" 配置选项
let g:tags_auto_update = get(g:, 'tags_auto_update', 1)           " 是否启用自动更新（默认启用）
let g:tags_update_on_save = get(g:, 'tags_update_on_save', 1)      " 保存时更新（默认启用）
let g:tags_update_interval = get(g:, 'tags_update_interval', 900) " 定期更新间隔（秒，默认15分钟）
let g:tags_update_delay = get(g:, 'tags_update_delay', 10)        " 防抖延迟（秒，避免频繁更新，默认10秒）
let g:tags_update_min_size = get(g:, 'tags_update_min_size', 100) " 最小文件大小（字节），小于此大小的文件不触发更新
let g:tags_update_filetypes = get(g:, 'tags_update_filetypes', []) " 指定文件类型列表，空列表表示所有类型

" 跟踪每个项目的最后更新时间，避免频繁更新
let s:tags_last_update = {}

" 检测项目根目录（通过查找 .git、.svn、Makefile 等标记）
function! s:FindProjectRoot(file) abort
    let l:dir = fnamemodify(a:file, ':p:h')
    let l:root_markers = ['.git', '.svn', '.hg', 'Makefile', 'CMakeLists.txt', 'package.json', 'Cargo.toml', 'go.mod', 'pom.xml', 'build.gradle']

    " 向上查找项目根目录
    let l:current = l:dir
    let l:prev = ''
    while l:current !=# l:prev
        for l:marker in l:root_markers
            if isdirectory(l:current . '/' . l:marker) || filereadable(l:current . '/' . l:marker)
                return l:current
            endif
        endfor
        let l:prev = l:current
        let l:current = fnamemodify(l:current, ':h')
    endwhile

    " 如果找不到项目根目录，使用文件所在目录
    return l:dir
endfunction

" 生成项目 tags 文件名（基于项目根目录名）
function! s:GetProjectTagsFile(project_root) abort
    let l:project_name = fnamemodify(a:project_root, ':t')
    if empty(l:project_name) || l:project_name ==# '.'
        " 如果项目名称为空或为 '.'，使用父目录名
        let l:project_name = fnamemodify(a:project_root, ':h:t')
    endif
    if empty(l:project_name)
        " 如果还是为空，使用默认名称
        let l:project_name = 'default'
    endif
    return s:tags_dir . '/' . l:project_name . '.tags'
endfunction

" 检测 ctags 可执行文件（Windows 兼容）
function! s:FindCtagsExecutable() abort
    " Windows 下可能需要检测 ctags.exe
    if has('win32') || has('win64') || has('win16')
        " 先尝试检测 ctags（可能在 PATH 中）
        if executable('ctags')
            return 'ctags'
        endif
        " 再尝试检测 ctags.exe
        if executable('ctags.exe')
            return 'ctags.exe'
        endif
        " 尝试检测 Universal Ctags（uctags）
        if executable('uctags')
            return 'uctags'
        endif
        if executable('uctags.exe')
            return 'uctags.exe'
        endif
    else
        " Unix/Linux/macOS 下检测
        if executable('ctags')
            return 'ctags'
        endif
        " 尝试检测 Universal Ctags
        if executable('uctags')
            return 'uctags'
        endif
    endif
    return ''
endfunction

" 更新 tags 文件（异步执行，不阻塞 Vim）
function! s:UpdateTagsFile(file) abort
    if !g:tags_auto_update
        return
    endif

    " 检查文件是否有效
    if empty(a:file) || !filereadable(a:file)
        return
    endif

    " 文件类型过滤
    if !empty(g:tags_update_filetypes)
        let l:filetype = getbufvar(bufnr(a:file), '&filetype')
        if empty(l:filetype)
            let l:filetype = &filetype
        endif
        if index(g:tags_update_filetypes, l:filetype) == -1
            return
        endif
    endif

    " 文件大小过滤（小文件可能不需要更新）
    let l:file_size = getfsize(a:file)
    if l:file_size > 0 && l:file_size < g:tags_update_min_size
        return
    endif

    " 检查 ctags 是否可用（Windows 兼容）
    let l:ctags_cmd = s:FindCtagsExecutable()
    if empty(l:ctags_cmd)
        return
    endif

    let l:project_root = s:FindProjectRoot(a:file)
    let l:tags_file = s:GetProjectTagsFile(l:project_root)

    " 检查是否需要更新（避免频繁更新同一项目）
    let l:current_time = localtime()
    let l:last_update = get(s:tags_last_update, l:project_root, 0)
    " 如果 30 秒内已经更新过，跳过
    if l:current_time - l:last_update < 30
        return
    endif

    " 记录更新时间
    let s:tags_last_update[l:project_root] = l:current_time

    " 构建 ctags 命令
    " 根据 ctags 版本选择不同的选项
    " 检测是否支持 --output（Universal Ctags）
    let l:version_output = system(l:ctags_cmd . ' --version 2>&1')
    let l:supports_output = l:version_output =~# 'Universal Ctags' || system(l:ctags_cmd . ' --help 2>&1') =~# '--output'

    if l:supports_output
        " Universal Ctags 或支持 --output 的版本
        if has('win32') || has('win64') || has('win16')
            " Windows 下使用双引号包裹路径
            let l:cmd = printf('%s -R --output="%s" --append=no "%s"',
                        \ l:ctags_cmd,
                        \ l:tags_file,
                        \ l:project_root)
        else
            " Unix/Linux/macOS 使用 shellescape
            let l:cmd = printf('%s -R --output=%s --append=no %s',
                        \ l:ctags_cmd,
                        \ shellescape(l:tags_file),
                        \ shellescape(l:project_root))
        endif
    else
        " Exuberant Ctags 或旧版本，使用 -f 选项
        if has('win32') || has('win64') || has('win16')
            " Windows 下使用双引号包裹路径
            let l:cmd = printf('%s -R -f "%s" "%s"',
                        \ l:ctags_cmd,
                        \ l:tags_file,
                        \ l:project_root)
        else
            " Unix/Linux/macOS 使用 shellescape
            let l:cmd = printf('%s -R -f %s %s',
                        \ l:ctags_cmd,
                        \ shellescape(l:tags_file),
                        \ shellescape(l:project_root))
        endif
    endif

    " 检查是否已有更新任务在运行（避免重复更新）
    let l:job_key = 'tags_' . l:project_root
    if has_key(s:tags_update_jobs, l:job_key)
        let l:existing_job = s:tags_update_jobs[l:job_key]
        " 检查任务是否还在运行
        if has('job') && has('patch-8.0.0027')
            if job_status(l:existing_job) ==# 'run'
                return  " 已有任务在运行，跳过
            endif
        elseif has('nvim')
            " Neovim 的 job 状态检查
            try
                let l:job_info = jobpid(l:existing_job)
                if l:job_info > 0
                    return  " 已有任务在运行，跳过
                endif
            catch
                " 任务已结束，继续
            endtry
        endif
    endif

    " 在后台异步执行（不阻塞 Vim）
    if has('job') && has('patch-8.0.0027')
        " 使用 job_start 异步执行（Vim 8.0+）
        let l:job = job_start([&shell, &shellcmdflag, l:cmd], {
                    \ 'out_io': 'null',
                    \ 'err_io': 'null',
                    \ 'exit_cb': {job, status -> s:OnTagsUpdateComplete(job, status, l:tags_file, l:job_key)}
                    \})
        let s:tags_update_jobs[l:job_key] = l:job
    elseif has('nvim')
        " Neovim 使用 jobstart
        let l:job = jobstart([&shell, &shellcmdflag, l:cmd], {
                    \ 'stdout_buffered': v:false,
                    \ 'stderr_buffered': v:false,
                    \ 'on_exit': {job, code -> s:OnTagsUpdateComplete(job, code, l:tags_file, l:job_key)}
                    \})
        let s:tags_update_jobs[l:job_key] = l:job
    else
        " 旧版本 Vim，使用同步方式（但使用 silent 减少干扰）
        " 注意：这会阻塞，但旧版本 Vim 不支持异步
        silent! call system(l:cmd)
        if v:shell_error == 0
            " 静默更新，不显示消息（减少干扰）
            if get(g:, 'tags_verbose', 0)
                echo "Tags 已更新: " . fnamemodify(l:tags_file, ':t')
            endif
        endif
    endif
endfunction

" Tags 更新任务字典（跟踪正在运行的任务）
let s:tags_update_jobs = {}

" Tags 更新完成回调
function! s:OnTagsUpdateComplete(job, status, tags_file, job_key) abort
    " 从任务字典中移除
    if has_key(s:tags_update_jobs, a:job_key)
        call remove(s:tags_update_jobs, a:job_key)
    endif

    " 只在成功时显示消息（可选，通过 g:tags_verbose 控制）
    if a:status == 0 && get(g:, 'tags_verbose', 0)
        echohl MoreMsg
        echomsg '[Tags] ✓ 已更新: ' . fnamemodify(a:tags_file, ':t')
        echohl None
    endif
endfunction

" 防抖更新（避免频繁更新）
let s:tags_update_timer = -1
function! s:UpdateTagsFileDebounced(file) abort
    if !g:tags_auto_update
        return
    endif

    " 停止之前的定时器
    if s:tags_update_timer != -1
        if has('timers')
            call timer_stop(s:tags_update_timer)
        endif
        let s:tags_update_timer = -1
    endif

    " 设置新的定时器（防抖）
    if has('timers')
        let s:tags_update_timer = timer_start(g:tags_update_delay * 1000, { -> s:UpdateTagsFile(a:file) })
    else
        " 不支持定时器，直接更新
        call s:UpdateTagsFile(a:file)
    endif
endfunction

" 手动更新 tags 命令
command! -nargs=0 UpdateTags call s:UpdateTagsFile(expand('%:p'))

" 检查 tags 文件是否可被找到
function! s:CheckTagsFiles() abort
    echohl Title
    echomsg '========================================'
    echomsg '  Tags 文件检查'
    echomsg '========================================'
    echohl None
    echo ''

    " 1. 检查 tags 搜索路径
    echohl Question
    echomsg '[1] Tags 搜索路径:'
    echohl None
    echo '  ' . &tags
    echo ''

    " 2. 检查集中目录
    echohl Question
    echomsg '[2] 集中 tags 目录:'
    echohl None
    echo '  路径: ' . s:tags_dir
    echo '  存在: ' . (isdirectory(s:tags_dir) ? '是' : '否')

    " 列出目录下的所有 tags 文件
    if isdirectory(s:tags_dir)
        let l:tags_files = glob(s:tags_dir . '/*.tags', 0, 1)
        if !empty(l:tags_files)
            echohl MoreMsg
            echomsg '  找到的 tags 文件:'
            echohl None
            for l:file in l:tags_files
                let l:file_size = getfsize(l:file)
                echo '    - ' . fnamemodify(l:file, ':t') . ' (' . l:file_size . ' 字节)'
            endfor
        else
            echohl WarningMsg
            echomsg '  ⚠ 未找到任何 .tags 文件'
            echohl None
        endif
    endif
    echo ''

    " 3. 测试 tags 文件是否可读
    echohl Question
    echomsg '[3] 测试 tags 文件读取:'
    echohl None
    let l:test_files = glob(s:tags_dir . '/*.tags', 0, 1)
    if !empty(l:test_files)
        for l:file in l:test_files[:2]  " 只测试前 3 个
            let l:readable = filereadable(l:file)
            echo '  ' . fnamemodify(l:file, ':t') . ': ' . (l:readable ? '可读' : '不可读')
            if l:readable
                let l:lines = readfile(l:file, '', 5)  " 读取前 5 行
                if !empty(l:lines)
                    echo '    首行: ' . l:lines[0]
                endif
            endif
        endfor
    else
        echohl WarningMsg
        echomsg '  ⚠ 没有找到 tags 文件进行测试'
        echohl None
    endif
    echo ''

    " 4. 检查当前文件的 tags
    echohl Question
    echomsg '[4] 当前文件信息:'
    echohl None
    let l:current_file = expand('%:p')
    if !empty(l:current_file)
        echo '  文件: ' . l:current_file
        let l:project_root = s:FindProjectRoot(l:current_file)
        echo '  项目根目录: ' . l:project_root
        let l:expected_tags = s:GetProjectTagsFile(l:project_root)
        echo '  预期 tags 文件: ' . l:expected_tags
        echo '  存在: ' . (filereadable(l:expected_tags) ? '是' : '否')
    else
        echohl WarningMsg
        echomsg '  ⚠ 没有打开的文件'
        echohl None
    endif
    echo ''

    " 5. 测试 tag 查找
    echohl Question
    echomsg '[5] 测试 tag 查找:'
    echohl None
    let l:tagfiles = tagfiles()
    if !empty(l:tagfiles)
        echohl MoreMsg
        echomsg '  ✓ 找到 ' . len(l:tagfiles) . ' 个 tags 文件:'
        echohl None
        for l:tagfile in l:tagfiles
            echo '    - ' . l:tagfile
        endfor
    else
        echohl WarningMsg
        echomsg '  ✗ 未找到任何 tags 文件'
        echohl None
        echohl Question
        echomsg '[提示] 请检查：'
        echomsg '  1. tags 文件是否在 ~/.vim/.tags/ 目录下'
        echomsg '  2. 文件扩展名是否为 .tags'
        echomsg '  3. 运行 :UpdateTags 生成 tags 文件'
        echohl None
    endif

    echohl Title
    echomsg '========================================'
    echohl None
endfunction

command! -nargs=0 CheckTagsFiles call s:CheckTagsFiles()

" 自动更新 tags 的 autocmd
if g:tags_auto_update
    augroup AutoUpdateTags
        autocmd!

        " 保存文件时更新 tags（如果启用）
        if g:tags_update_on_save
            autocmd BufWritePost *
                        \ if expand('<afile>') !=# '' && &buftype ==# '' |
                        \   call s:UpdateTagsFileDebounced(expand('<afile>:p')) |
                        \ endif
        endif

        " 定期更新 tags（使用定时器，更精确控制）
        " 不再使用 CursorHold，改为使用定时器，避免过于频繁
        let s:tags_periodic_timer = -1
        function! s:StartPeriodicUpdate() abort
            " 停止之前的定时器
            if s:tags_periodic_timer != -1
                if has('timers')
                    call timer_stop(s:tags_periodic_timer)
                endif
            endif

            " 启动新的定时器
            if has('timers') && g:tags_auto_update
                let s:tags_periodic_timer = timer_start(g:tags_update_interval * 1000, 
                            \ { -> s:DoPeriodicUpdate() }, {'repeat': -1})
            endif
        endfunction

        function! s:DoPeriodicUpdate() abort
            if !g:tags_auto_update
                return
            endif

            let l:current_file = expand('%:p')
            if !empty(l:current_file) && &buftype ==# ''
                call s:UpdateTagsFile(l:current_file)
            endif
        endfunction

        " 在进入 buffer 时启动定期更新
        autocmd BufEnter *
                    \ if expand('<afile>') !=# '' && &buftype ==# '' |
                    \   call s:StartPeriodicUpdate() |
                    \ endif
    augroup END
endif

