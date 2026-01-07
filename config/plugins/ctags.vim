"==============================================================
" config/plugins/ctags.vim
" Ctags 配置：Tags 文件集中管理和自动更新
"
" 功能特性：
" - 集中管理所有项目的 tags 文件
" - 自动检测项目根目录
" - 异步更新 tags 文件（不阻塞 Vim）
" - 支持 Universal Ctags 和 Exuberant Ctags
" - 防抖机制避免频繁更新
" - 定期自动更新
" - 跨平台支持（Windows/Unix/Linux/macOS）
"
" 最佳实践：
" - 使用 Universal Ctags（推荐）
" - 每个项目生成独立的 tags 文件
" - 集中存储在 ~/.vim/.tags/ 目录
" - 异步更新避免阻塞编辑器
"==============================================================

" 防止重复加载
if exists('g:loaded_ctags_config')
    finish
endif
let g:loaded_ctags_config = 1

" 脚本局部变量（避免污染全局命名空间）
let s:save_cpo = &cpo
set cpo&vim

"==============================================================
" 1. 配置选项和常量定义
"==============================================================

" 集中存储 tags 文件的目录
let s:tags_dir = expand('~/.vim/.tags')

" 用户可配置选项（使用 get() 提供默认值，避免覆盖用户设置）
let g:tags_auto_update = get(g:, 'tags_auto_update', 0)              " 是否启用自动更新（默认禁用，避免卡顿）
let g:tags_update_on_save = get(g:, 'tags_update_on_save', 0)         " 保存时更新（默认禁用）
let g:tags_update_interval = get(g:, 'tags_update_interval', 900)    " 定期更新间隔（秒，默认15分钟）
let g:tags_update_delay = get(g:, 'tags_update_delay', 10)            " 防抖延迟（秒，避免频繁更新，默认10秒）
let g:tags_update_min_size = get(g:, 'tags_update_min_size', 100)    " 最小文件大小（字节），小于此大小的文件不触发更新
let g:tags_update_filetypes = get(g:, 'tags_update_filetypes', [])   " 指定文件类型列表，空列表表示所有类型
let g:tags_verbose = get(g:, 'tags_verbose', 0)                      " 是否显示详细消息（默认关闭）
let g:tags_min_update_interval = get(g:, 'tags_min_update_interval', 30)  " 同一项目最小更新间隔（秒，避免频繁更新）

" 项目根目录标记文件（按优先级排序）
let s:root_markers = [
    \ '.git',
    \ '.svn',
    \ '.hg',
    \ '.bzr',
    \ 'Makefile',
    \ 'CMakeLists.txt',
    \ 'package.json',
    \ 'Cargo.toml',
    \ 'go.mod',
    \ 'pom.xml',
    \ 'build.gradle',
    \ 'setup.py',
    \ 'requirements.txt',
    \ '.project',
    \ '.idea',
    \ 'composer.json',
    \ 'Gemfile',
    \ 'Rakefile',
    \ 'mix.exs',
    \ 'dub.json',
    \ 'pubspec.yaml',
    \]

" 内部状态变量
let s:tags_last_update = {}           " 跟踪每个项目的最后更新时间
let s:tags_update_jobs = {}           " 跟踪正在运行的更新任务
let s:tags_update_timer = -1          " 防抖定时器
let s:tags_periodic_timer = -1        " 定期更新定时器
let s:ctags_executable = ''           " 缓存的 ctags 可执行文件路径
let s:ctags_version_info = {}         " 缓存的 ctags 版本信息

" 创建集中存储目录（如果不存在）
if !isdirectory(s:tags_dir)
    call mkdir(s:tags_dir, 'p', 0700)
endif

"==============================================================
" 2. Tags 文件路径管理和集中存储
"==============================================================

" 规范化路径（统一使用正斜杠，Vim 内部使用正斜杠）
function! s:NormalizePath(path) abort
    let l:path = a:path
    if has('win32') || has('win64') || has('win16')
        let l:path = substitute(l:path, '\\', '/', 'g')
    endif
    return l:path
endfunction

" 动态加载集中目录下的所有 .tags 文件
" 最佳实践：按修改时间排序，最新的优先
function! s:LoadCentralTagsFiles() abort
    if !isdirectory(s:tags_dir)
        return
    endif

    " 查找所有 .tags 文件
    let l:tags_files = glob(s:tags_dir . '/*.tags', 0, 1)
    if empty(l:tags_files)
        return
    endif

    " 按修改时间排序（最新的优先）
    let l:files_with_time = []
    for l:file in l:tags_files
        if filereadable(l:file)
            let l:mtime = getftime(l:file)
            call add(l:files_with_time, [l:mtime, l:file])
        endif
    endfor

    " 按修改时间降序排序
    call sort(l:files_with_time, {a, b -> b[0] - a[0]})

    " 构建 tags 路径字符串
    let l:tags_paths = []
    for l:item in l:files_with_time
        let l:file = l:item[1]
        " 使用绝对路径，确保 Vim 能找到
        let l:abs_path = fnamemodify(l:file, ':p')
        let l:abs_path = s:NormalizePath(l:abs_path)
        call add(l:tags_paths, l:abs_path)
    endfor

    " 添加到 tags 选项（放在最前面，优先级最高）
    if !empty(l:tags_paths)
        let l:central_tags = join(l:tags_paths, ',')
        " 如果 tags 选项已设置，在前面添加；否则直接设置
        if !empty(&tags)
            " 避免重复添加
            let l:existing_tags = split(&tags, ',')
            let l:new_tags = split(l:central_tags, ',')
            let l:combined = []
            for l:tag in l:new_tags
                if index(l:existing_tags, l:tag) == -1
                    call add(l:combined, l:tag)
                endif
            endfor
            for l:tag in l:existing_tags
                call add(l:combined, l:tag)
            endfor
            let &tags = join(l:combined, ',')
        else
            " 设置默认的 tags 搜索路径
            " 优先级：集中目录 > 当前目录 > 递归向上查找
            let l:default_tags = ',./tags,./TAGS,tags,TAGS;'
            let &tags = l:central_tags . l:default_tags
        endif
    endif
endfunction

" 设置 tags 搜索路径（按优先级顺序）：
" 1. 集中管理的 tags 目录（所有项目的 tags，优先级最高）
"   动态加载所有 .tags 文件
" 2. 当前文件所在目录的 tags 文件（项目本地）
" 3. 向上递归查找父目录的 tags 文件（传统方式）
" 注意：使用 ; 表示向上递归查找，直到找到或到达根目录
let s:tags_dir_normalized = s:NormalizePath(s:tags_dir)
execute 'set tags=' . fnameescape(s:tags_dir_normalized . '//') . ',./tags,./TAGS,tags,TAGS;'

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
" 2. Tags 文件路径管理和集中存储
"==============================================================

" 检测项目根目录（通过查找标记文件）
" 最佳实践：使用多种标记文件，按优先级查找
function! s:FindProjectRoot(file) abort
    if empty(a:file)
        return ''
    endif

    let l:dir = fnamemodify(a:file, ':p:h')
    if empty(l:dir)
        return ''
    endif

    " 规范化路径
    let l:dir = s:NormalizePath(l:dir)

    " 向上查找项目根目录
    let l:current = l:dir
    let l:prev = ''
    let l:max_depth = 20  " 防止无限循环
    let l:depth = 0

    while l:current !=# l:prev && l:depth < l:max_depth
        " 检查每个标记文件
        for l:marker in s:root_markers
            let l:marker_path = l:current . '/' . l:marker
            if isdirectory(l:marker_path) || filereadable(l:marker_path)
                return l:current
            endif
        endfor

        let l:prev = l:current
        let l:parent = fnamemodify(l:current, ':h')
        " 如果到达根目录，停止查找
        if l:parent ==# l:current || l:parent ==# l:prev
            break
        endif
        let l:current = l:parent
        let l:depth += 1
    endwhile

    " 如果找不到项目根目录，使用文件所在目录
    return l:dir
endfunction

" 生成项目 tags 文件名（基于项目根目录名）
" 最佳实践：使用项目根目录名，确保唯一性
function! s:GetProjectTagsFile(project_root) abort
    if empty(a:project_root)
        return s:tags_dir . '/default.tags'
    endif

    let l:project_name = fnamemodify(a:project_root, ':t')
    
    " 如果项目名称为空或为 '.'，使用父目录名
    if empty(l:project_name) || l:project_name ==# '.'
        let l:project_name = fnamemodify(a:project_root, ':h:t')
    endif

    " 如果还是为空，使用完整路径的哈希值
    if empty(l:project_name)
        " 使用路径的哈希值作为项目名（避免冲突）
        let l:path_hash = substitute(a:project_root, '[^a-zA-Z0-9]', '_', 'g')
        let l:project_name = 'project_' . l:path_hash[-16:]  " 使用最后16个字符
    endif

    " 清理项目名（移除特殊字符，确保文件名有效）
    let l:project_name = substitute(l:project_name, '[^a-zA-Z0-9._-]', '_', 'g')
    
    return s:tags_dir . '/' . l:project_name . '.tags'
endfunction

"==============================================================
" 4. Ctags 可执行文件检测和版本兼容
"==============================================================

" 检测 ctags 可执行文件（Windows 兼容）
" 最佳实践：优先使用 Universal Ctags，缓存检测结果
function! s:FindCtagsExecutable() abort
    " 如果已缓存，直接返回
    if !empty(s:ctags_executable) && executable(s:ctags_executable)
        return s:ctags_executable
    endif

    " 按优先级检测可执行文件
    let l:candidates = []
    
    if has('win32') || has('win64') || has('win16')
        " Windows 下的检测顺序
        let l:candidates = [
            \ 'uctags.exe',
            \ 'uctags',
            \ 'ctags.exe',
            \ 'ctags',
            \]
    else
        " Unix/Linux/macOS 下的检测顺序
        let l:candidates = [
            \ 'uctags',
            \ 'ctags',
            \]
    endif

    " 检测每个候选可执行文件
    for l:candidate in l:candidates
        if executable(l:candidate)
            let s:ctags_executable = l:candidate
            return l:candidate
        endif
    endfor

    " 未找到可执行文件
    return ''
endfunction

" 检测 ctags 版本信息（缓存结果，避免重复检测）
function! s:GetCtagsVersionInfo(ctags_cmd) abort
    if empty(a:ctags_cmd)
        return {}
    endif

    " 如果已缓存，直接返回
    if has_key(s:ctags_version_info, a:ctags_cmd)
        return s:ctags_version_info[a:ctags_cmd]
    endif

    let l:info = {
        \ 'is_universal': 0,
        \ 'supports_output': 0,
        \ 'version': '',
        \}

    try
        " 检测版本
        let l:version_output = system(a:ctags_cmd . ' --version 2>&1')
        let l:info.version = l:version_output

        " 检查是否是 Universal Ctags
        if l:version_output =~# 'Universal Ctags'
            let l:info.is_universal = 1
        endif

        " 检查是否支持 --output 选项
        let l:help_output = system(a:ctags_cmd . ' --help 2>&1')
        if l:help_output =~# '--output'
            let l:info.supports_output = 1
        endif
    catch
        " 检测失败，使用默认值
    endtry

    " 缓存结果
    let s:ctags_version_info[a:ctags_cmd] = l:info
    return l:info
endfunction

" 构建 ctags 命令（根据版本选择不同选项）
function! s:BuildCtagsCommand(ctags_cmd, tags_file, project_root) abort
    if empty(a:ctags_cmd) || empty(a:tags_file) || empty(a:project_root)
        return ''
    endif

    " 获取版本信息
    let l:version_info = s:GetCtagsVersionInfo(a:ctags_cmd)
    
    " 规范化路径
    let l:tags_file = s:NormalizePath(a:tags_file)
    let l:project_root = s:NormalizePath(a:project_root)

    " 根据版本选择不同的选项
    if l:version_info.supports_output
        " Universal Ctags 或支持 --output 的版本
        " 使用 --output 选项（推荐）
        if has('win32') || has('win64') || has('win16')
            " Windows 下使用双引号包裹路径
            let l:cmd = printf('%s -R --output="%s" --append=no "%s"',
                        \ a:ctags_cmd, l:tags_file, l:project_root)
        else
            " Unix/Linux/macOS 使用 shellescape
            let l:cmd = printf('%s -R --output=%s --append=no %s',
                        \ a:ctags_cmd,
                        \ shellescape(l:tags_file),
                        \ shellescape(l:project_root))
        endif
    else
        " Exuberant Ctags 或旧版本，使用 -f 选项
        if has('win32') || has('win64') || has('win16')
            " Windows 下使用双引号包裹路径
            let l:cmd = printf('%s -R -f "%s" "%s"',
                        \ a:ctags_cmd, l:tags_file, l:project_root)
        else
            " Unix/Linux/macOS 使用 shellescape
            let l:cmd = printf('%s -R -f %s %s',
                        \ a:ctags_cmd,
                        \ shellescape(l:tags_file),
                        \ shellescape(l:project_root))
        endif
    endif

    return l:cmd
endfunction

"==============================================================
" 5. 异步更新 tags 文件的核心逻辑
"==============================================================

" 检查是否应该更新 tags 文件
function! s:ShouldUpdateTags(file) abort
    " 检查自动更新是否启用
    if !g:tags_auto_update
        return 0
    endif

    " 检查文件是否有效
    if empty(a:file) || !filereadable(a:file)
        return 0
    endif

    " 文件类型过滤
    if !empty(g:tags_update_filetypes)
        let l:bufnr = bufnr(a:file)
        let l:filetype = l:bufnr > 0 ? getbufvar(l:bufnr, '&filetype') : ''
        if empty(l:filetype)
            let l:filetype = &filetype
        endif
        if index(g:tags_update_filetypes, l:filetype) == -1
            return 0
        endif
    endif

    " 文件大小过滤（小文件可能不需要更新）
    let l:file_size = getfsize(a:file)
    if l:file_size > 0 && l:file_size < g:tags_update_min_size
        return 0
    endif

    return 1
endfunction

" 检查任务是否正在运行
function! s:IsJobRunning(job_key) abort
    if !has_key(s:tags_update_jobs, a:job_key)
        return 0
    endif

    let l:job = s:tags_update_jobs[a:job_key]

    " Vim 8.0+ 的 job 状态检查
    if has('job') && has('patch-8.0.0027')
        try
            return job_status(l:job) ==# 'run'
        catch
            return 0
        endtry
    " Neovim 的 job 状态检查
    elseif has('nvim')
        try
            let l:job_info = jobpid(l:job)
            return l:job_info > 0
        catch
            return 0
        endtry
    endif

    return 0
endfunction

" Tags 更新完成回调
function! s:OnTagsUpdateComplete(job, status, tags_file, job_key) abort
    " 从任务字典中移除
    if has_key(s:tags_update_jobs, a:job_key)
        call remove(s:tags_update_jobs, a:job_key)
    endif

    " 只在成功时显示消息（可选，通过 g:tags_verbose 控制）
    if a:status == 0 && g:tags_verbose
        echohl MoreMsg
        echomsg '[Tags] ✓ 已更新: ' . fnamemodify(a:tags_file, ':t')
        echohl None
    elseif a:status != 0 && g:tags_verbose
        echohl WarningMsg
        echomsg '[Tags] ✗ 更新失败: ' . fnamemodify(a:tags_file, ':t')
        echohl None
    endif

    " 重新加载 tags 文件（确保 Vim 能识别新生成的 tags）
    if a:status == 0
        " 延迟重新加载，避免频繁操作
        if has('timers')
            call timer_start(100, { -> s:LoadCentralTagsFiles() })
        else
            call s:LoadCentralTagsFiles()
        endif
    endif
endfunction

" 更新 tags 文件（异步执行，不阻塞 Vim）
" 最佳实践：异步执行、错误处理、避免重复更新
function! s:UpdateTagsFile(file) abort
    " 检查是否应该更新
    if !s:ShouldUpdateTags(a:file)
        return
    endif

    " 检查 ctags 是否可用
    let l:ctags_cmd = s:FindCtagsExecutable()
    if empty(l:ctags_cmd)
        if g:tags_verbose
            echohl WarningMsg
            echomsg '[Tags] ✗ 未找到 ctags 可执行文件'
            echohl None
        endif
        return
    endif

    " 查找项目根目录
    let l:project_root = s:FindProjectRoot(a:file)
    if empty(l:project_root)
        return
    endif

    " 生成 tags 文件路径
    let l:tags_file = s:GetProjectTagsFile(l:project_root)

    " 检查是否需要更新（避免频繁更新同一项目）
    let l:current_time = localtime()
    let l:last_update = get(s:tags_last_update, l:project_root, 0)
    if l:current_time - l:last_update < g:tags_min_update_interval
        return
    endif

    " 检查是否已有更新任务在运行
    let l:job_key = 'tags_' . l:project_root
    if s:IsJobRunning(l:job_key)
        return
    endif

    " 记录更新时间
    let s:tags_last_update[l:project_root] = l:current_time

    " 构建 ctags 命令
    let l:cmd = s:BuildCtagsCommand(l:ctags_cmd, l:tags_file, l:project_root)
    if empty(l:cmd)
        return
    endif

    " 在后台异步执行（不阻塞 Vim）
    if has('job') && has('patch-8.0.0027')
        " Vim 8.0+ 使用 job_start 异步执行
        try
            let l:job = job_start([&shell, &shellcmdflag, l:cmd], {
                        \ 'out_io': 'null',
                        \ 'err_io': 'null',
                        \ 'exit_cb': {job, status -> s:OnTagsUpdateComplete(job, status, l:tags_file, l:job_key)}
                        \})
            let s:tags_update_jobs[l:job_key] = l:job
        catch
            " 如果异步执行失败，尝试同步执行
            if g:tags_verbose
                echohl WarningMsg
                echomsg '[Tags] 异步执行失败，使用同步方式'
                echohl None
            endif
            silent! call system(l:cmd)
        endtry
    elseif has('nvim')
        " Neovim 使用 jobstart
        try
            let l:job = jobstart([&shell, &shellcmdflag, l:cmd], {
                        \ 'stdout_buffered': v:false,
                        \ 'stderr_buffered': v:false,
                        \ 'on_exit': {job, code -> s:OnTagsUpdateComplete(job, code, l:tags_file, l:job_key)}
                        \})
            let s:tags_update_jobs[l:job_key] = l:job
        catch
            " 如果异步执行失败，尝试同步执行
            if g:tags_verbose
                echohl WarningMsg
                echomsg '[Tags] 异步执行失败，使用同步方式'
                echohl None
            endif
            silent! call system(l:cmd)
        endtry
    else
        " 旧版本 Vim，使用同步方式（但使用 silent 减少干扰）
        " 注意：这会阻塞，但旧版本 Vim 不支持异步
        silent! call system(l:cmd)
        if v:shell_error == 0
            if g:tags_verbose
                echohl MoreMsg
                echomsg '[Tags] ✓ 已更新: ' . fnamemodify(l:tags_file, ':t')
                echohl None
            endif
            " 重新加载 tags 文件
            call s:LoadCentralTagsFiles()
        endif
    endif
endfunction

"==============================================================
" 6. 自动更新触发机制（保存时、定期更新）
"==============================================================

" 防抖更新（避免频繁更新）
" 最佳实践：使用定时器实现防抖，避免短时间内多次触发
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
        let s:tags_update_timer = timer_start(
                    \ g:tags_update_delay * 1000,
                    \ { -> s:UpdateTagsFile(a:file) })
    else
        " 不支持定时器，直接更新
        call s:UpdateTagsFile(a:file)
    endif
endfunction

" 启动定期更新定时器
function! s:StartPeriodicUpdate() abort
    " 停止之前的定时器
    if s:tags_periodic_timer != -1
        if has('timers')
            call timer_stop(s:tags_periodic_timer)
        endif
        let s:tags_periodic_timer = -1
    endif

    " 启动新的定时器（定期更新）
    if has('timers') && g:tags_auto_update
        let s:tags_periodic_timer = timer_start(
                    \ g:tags_update_interval * 1000,
                    \ { -> s:DoPeriodicUpdate() },
                    \ {'repeat': -1})  " 无限重复
    endif
endfunction

" 执行定期更新
function! s:DoPeriodicUpdate() abort
    if !g:tags_auto_update
        return
    endif

    let l:current_file = expand('%:p')
    if !empty(l:current_file) && &buftype ==# ''
        call s:UpdateTagsFile(l:current_file)
    endif
endfunction

" 停止定期更新定时器
function! s:StopPeriodicUpdate() abort
    if s:tags_periodic_timer != -1
        if has('timers')
            call timer_stop(s:tags_periodic_timer)
        endif
        let s:tags_periodic_timer = -1
    endif
endfunction

"==============================================================
" 7. 用户命令和调试工具
"==============================================================

" 手动更新 tags 命令
command! -nargs=0 UpdateTags call s:UpdateTagsFile(expand('%:p'))

" 强制更新 tags 命令（忽略时间间隔限制）
command! -nargs=0 UpdateTagsForce call s:ForceUpdateTagsFile(expand('%:p'))

" 强制更新 tags 文件（忽略时间间隔限制）
function! s:ForceUpdateTagsFile(file) abort
    if empty(a:file)
        echohl ErrorMsg
        echomsg '[Tags] ✗ 错误：没有打开的文件'
        echohl None
        return
    endif

    " 临时清除最后更新时间，强制更新
    let l:project_root = s:FindProjectRoot(a:file)
    if !empty(l:project_root)
        let s:tags_last_update[l:project_root] = 0
    endif

    call s:UpdateTagsFile(a:file)
endfunction

" 检查 tags 文件是否可被找到
" 最佳实践：提供详细的诊断信息，帮助用户排查问题
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

    " 6. 检查 ctags 可执行文件
    echohl Question
    echomsg '[6] Ctags 可执行文件:'
    echohl None
    let l:ctags_cmd = s:FindCtagsExecutable()
    if !empty(l:ctags_cmd)
        echohl MoreMsg
        echomsg '  ✓ 找到: ' . l:ctags_cmd
        echohl None
        let l:version_info = s:GetCtagsVersionInfo(l:ctags_cmd)
        if !empty(l:version_info.version)
            echo '  版本信息: ' . split(l:version_info.version, "\n")[0]
        endif
        if l:version_info.is_universal
            echo '  类型: Universal Ctags'
        else
            echo '  类型: Exuberant Ctags 或其他'
        endif
    else
        echohl WarningMsg
        echomsg '  ✗ 未找到 ctags 可执行文件'
        echohl None
        echohl Question
        echomsg '[提示] 请安装 ctags：'
        echomsg '  - Universal Ctags（推荐）: https://github.com/universal-ctags/ctags'
        echomsg '  - Exuberant Ctags: http://ctags.sourceforge.net/'
        echohl None
    endif
    echo ''

    " 7. 检查配置选项
    echohl Question
    echomsg '[7] 配置选项:'
    echohl None
    echo '  自动更新: ' . (g:tags_auto_update ? '启用' : '禁用')
    echo '  保存时更新: ' . (g:tags_update_on_save ? '启用' : '禁用')
    echo '  更新间隔: ' . g:tags_update_interval . ' 秒'
    echo '  防抖延迟: ' . g:tags_update_delay . ' 秒'
    echo '  最小文件大小: ' . g:tags_update_min_size . ' 字节'
    if !empty(g:tags_update_filetypes)
        echo '  文件类型过滤: ' . join(g:tags_update_filetypes, ', ')
    else
        echo '  文件类型过滤: 无（所有类型）'
    endif
    echo ''

    echohl Title
    echomsg '========================================'
    echohl None
endfunction

command! -nargs=0 CheckTagsFiles call s:CheckTagsFiles()

" 显示 ctags 配置信息
command! -nargs=0 TagsInfo call s:ShowTagsInfo()

function! s:ShowTagsInfo() abort
    echohl Title
    echomsg '========================================'
    echomsg '  Ctags 配置信息'
    echomsg '========================================'
    echohl None
    echo ''
    echo '集中存储目录: ' . s:tags_dir
    echo 'Ctags 可执行文件: ' . (empty(s:ctags_executable) ? '未找到' : s:ctags_executable)
    echo ''
    echo '配置选项:'
    echo '  g:tags_auto_update = ' . g:tags_auto_update
    echo '  g:tags_update_on_save = ' . g:tags_update_on_save
    echo '  g:tags_update_interval = ' . g:tags_update_interval
    echo '  g:tags_update_delay = ' . g:tags_update_delay
    echo '  g:tags_update_min_size = ' . g:tags_update_min_size
    echo '  g:tags_verbose = ' . g:tags_verbose
    echo ''
    echohl Title
    echomsg '========================================'
    echohl None
endfunction


" 设置自动更新 autocmd
" 最佳实践：只在需要时触发，避免不必要的更新
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

        " 在进入 buffer 时启动定期更新
        autocmd BufEnter *
                    \ if expand('<afile>') !=# '' && &buftype ==# '' |
                    \   call s:StartPeriodicUpdate() |
                    \ endif

        " 在离开 buffer 时停止定期更新（节省资源）
        autocmd BufLeave *
                    \ if expand('<afile>') !=# '' && &buftype ==# '' |
                    \   call s:StopPeriodicUpdate() |
                    \ endif
    augroup END
endif

" 监听 tag 查找失败，显示提示
augroup TagsHint
    autocmd!
    " 当进入文件时检查是否需要 tags 文件（延迟检查，避免干扰）
    autocmd BufEnter *
                \ if expand('<afile>') !=# '' && &buftype ==# '' |
                \   if has('timers') |
                \     call timer_start(2000, { -> s:CheckAndShowTagsHint() }) |
                \   else |
                \     call s:CheckAndShowTagsHint() |
                \   endif |
                \ endif
augroup END

" 检查并显示 tags 提示（仅在需要时显示一次）
let s:tags_hint_shown = {}
function! s:CheckAndShowTagsHint() abort
    let l:current_file = expand('%:p')
    if empty(l:current_file) || &buftype !=# ''
        return
    endif

    " 检查是否已经显示过提示（每个文件只显示一次）
    if has_key(s:tags_hint_shown, l:current_file)
        return
    endif

    " 检查是否有 tags 文件
    let l:tagfiles = tagfiles()
    if empty(l:tagfiles)
        let l:project_root = s:FindProjectRoot(l:current_file)
        if !empty(l:project_root)
            " 在状态栏显示提示（使用 echomsg 不会阻塞）
            echohl WarningMsg
            echomsg '[Tags] 未找到 tags 文件，使用 :UpdateTags 命令生成'
            echohl None
            let s:tags_hint_shown[l:current_file] = 1
        endif
    endif
endfunction

"==============================================================
" 8. 清理和说明
"==============================================================

" 恢复 cpo 选项
let &cpo = s:save_cpo
unlet s:save_cpo

" 使用说明：
" 
" 1. 生成 tags 文件（手动更新，避免卡顿）：
"    - 手动：使用 :UpdateTags 命令生成/更新 tags 文件
"    - 强制：使用 :UpdateTagsForce 命令（忽略时间间隔限制）
"    - 提示：当打开文件且未找到 tags 文件时，会在状态栏提示使用 :UpdateTags
"
" 2. 检查 tags 文件：
"    - 使用 :CheckTagsFiles 命令查看详细信息
"    - 使用 :TagsInfo 命令查看配置信息
"
" 3. 配置选项（在 vimrc 中设置，默认已禁用自动更新）：
"    let g:tags_auto_update = 0              " 自动更新（默认禁用，避免卡顿）
"    let g:tags_update_on_save = 0           " 保存时更新（默认禁用）
"    let g:tags_update_interval = 900        " 定期更新间隔（秒）
"    let g:tags_update_delay = 10            " 防抖延迟（秒）
"    let g:tags_update_min_size = 100        " 最小文件大小（字节）
"    let g:tags_update_filetypes = []        " 文件类型过滤（空=所有类型）
"    let g:tags_verbose = 0                  " 显示详细消息
"
" 4. 项目根目录检测：
"    - 自动检测项目根目录（通过查找 .git、package.json 等标记文件）
"    - 每个项目生成独立的 tags 文件
"    - 存储在 ~/.vim/.tags/ 目录
"
" 5. 推荐使用 Universal Ctags：
"    - 更好的语言支持
"    - 更活跃的维护
"    - 下载地址：https://github.com/universal-ctags/ctags
"
"==============================================================
