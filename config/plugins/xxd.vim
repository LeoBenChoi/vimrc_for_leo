"==============================================================
" config/plugins/xxd.vim
" xxd 十六进制编辑器配置
" xxd 是 Vim 内置的十六进制编辑器，无需额外插件
" 参考：:help xxd
"==============================================================

if exists('g:loaded_xxd_config')
    finish
endif
let g:loaded_xxd_config = 1

"==============================================================
" 1. 基础配置
"==============================================================

" 自动检测二进制文件并转换为十六进制模式
" 当打开二进制文件时，自动使用 xxd 格式
augroup XxdAutoDetect
    autocmd!
    " 检测二进制文件并自动转换
    autocmd BufReadPre *.bin,*.exe,*.dll,*.so,*.dylib,*.o,*.obj,*.class,*.jar,*.zip,*.tar,*.gz,*.bz2,*.xz,*.7z,*.rar,*.pdf,*.png,*.jpg,*.jpeg,*.gif,*.ico,*.bmp,*.tiff,*.mp3,*.mp4,*.avi,*.mov,*.flv,*.wmv,*.mkv,*.iso,*.img,*.dmg,*.vmdk,*.vdi,*.vhd,*.qcow2,*.raw,*.dd,*.dump,*.mem,*.core,*.crash,*.dump,*.hprof,*.heap,*.snapshot,*.trace,*.log setlocal binary
    
    " .vimhex 文件：如果内容是二进制，转换为 xxd 格式；如果已经是 xxd 格式，直接使用
    autocmd BufReadPost *.vimhex call s:HandleVimhexFile()
    
    " 其他二进制文件：自动转换为 xxd 格式
    autocmd BufReadPost *
        \ if &binary && &filetype != 'xxd' |
        \   let s:xxd_mode = 1 |
        \   silent %!xxd |
        \   setlocal filetype=xxd |
        \   setlocal readonly |
        \   setlocal nomodifiable |
        \ endif
augroup END

" 处理 .vimhex 文件：检测内容格式并自动转换
function! s:HandleVimhexFile() abort
    " 检查文件是否已经是 xxd 格式（第一行包含地址偏移和十六进制数据）
    let l:first_line = getline(1)
    if l:first_line =~# '^[0-9a-fA-F]\{8\}:.*[0-9a-fA-F]\{2\}'
        " 已经是 xxd 格式，直接使用
        let s:xxd_mode = 1
        setlocal filetype=xxd
        setlocal readonly
        setlocal nomodifiable
    else
        " 是二进制文件，转换为 xxd 格式
        setlocal binary
        let s:xxd_mode = 1
        silent %!xxd
        setlocal filetype=xxd
        setlocal readonly
        setlocal nomodifiable
    endif
endfunction

"==============================================================
" 2. 快捷键映射
"==============================================================

" 切换十六进制模式：创建 .vimhex 文件进行编辑
function! s:ToggleXxd() abort
    " 如果当前已经是 .vimhex 文件，关闭并返回源文件
    if expand('%:e') ==# 'vimhex' && exists('b:xxd_source_file')
        " 关闭当前 .vimhex 文件，返回源文件
        let l:source_file = b:xxd_source_file
        bdelete
        if filereadable(l:source_file)
            execute 'edit ' . fnameescape(l:source_file)
        endif
        return
    endif
    
    " 如果当前是 xxd 模式但不是 .vimhex 文件，提示错误
    if &filetype == 'xxd'
        echohl ErrorMsg
        echomsg '[xxd] 当前已经是十六进制模式，请先关闭当前文件'
        echohl None
        return
    endif
    
    " 检查当前文件是否有路径
    let l:current_file = expand('%:p')
    if empty(l:current_file)
        echohl ErrorMsg
        echomsg '[xxd] 当前缓冲区没有关联文件，请先保存文件'
        echohl None
        return
    endif
    
    " 创建 .vimhex 文件路径
    let l:vimhex_file = l:current_file . '.vimhex'
    
    " 如果 .vimhex 文件已存在，直接打开
    if filereadable(l:vimhex_file)
        execute 'edit ' . fnameescape(l:vimhex_file)
        call s:SetupVimhexFile(l:current_file)
        return
    endif
    
    " 创建新的 .vimhex 文件
    " 先读取当前文件内容
    let l:content = readfile(l:current_file, 'b')
    
    " 创建临时文件并转换为 xxd 格式
    let l:temp_file = tempname()
    if !empty(l:content)
        call writefile(l:content, l:temp_file, 'b')
    else
        " 空文件，创建一个空文件
        call writefile([], l:temp_file, 'b')
    endif
    
    " 使用 xxd 转换
    let l:xxd_output = systemlist('xxd ' . shellescape(l:temp_file))
    call delete(l:temp_file)
    
    " 如果转换失败，使用空内容
    if empty(l:xxd_output)
        let l:xxd_content = ['00000000:']
    else
        let l:xxd_content = l:xxd_output
    endif
    
    " 写入 .vimhex 文件
    call writefile(l:xxd_content, l:vimhex_file)
    
    " 打开 .vimhex 文件
    execute 'edit ' . fnameescape(l:vimhex_file)
    call s:SetupVimhexFile(l:current_file)
endfunction

" 设置 .vimhex 文件的配置
function! s:SetupVimhexFile(source_file) abort
    " 保存源文件路径
    let b:xxd_source_file = a:source_file
    " 设置文件类型
    setlocal filetype=xxd
    " 允许编辑
    setlocal modifiable
    setlocal noreadonly
endfunction

" 打开当前文件的十六进制视图
function! s:OpenXxd() abort
    if &filetype == 'xxd'
        echomsg '[xxd] 当前已经是十六进制模式'
        return
    endif
    let s:xxd_mode = 1
    setlocal binary
    silent %!xxd
    setlocal filetype=xxd
    setlocal readonly
    setlocal nomodifiable
    " echomsg '[xxd] 已切换到十六进制模式'
endfunction

" 保存十六进制编辑：将 .vimhex 文件转换回源文件
" 注意：对于 .vimhex 文件，:w 命令会自动触发 HandleVimhexWrite
function! s:SaveXxd() abort
    " 如果是 .vimhex 文件，直接调用 write（会自动触发 HandleVimhexWrite）
    if expand('%:e') ==# 'vimhex' && exists('b:xxd_source_file')
        write
        return
    endif
    
    " 其他情况使用默认保存
    write
endfunction

" 保存并退出：写入源文件并删除 .vimhex 文件
function! s:SaveQuitXxd() abort
    " 检查是否是 .vimhex 文件
    if expand('%:e') !=# 'vimhex' || !exists('b:xxd_source_file')
        " 不是 .vimhex 文件，使用默认保存退出
        write
        quit
        return
    endif
    
    " 保存到源文件（会自动删除 .vimhex 文件并切换到源文件）
    call s:SaveXxd()
    
    " 退出（此时已经在源文件上了）
    quit
endfunction

" 全局快捷键映射
" <Leader>hx -> 切换十六进制模式（与之前的 ddx 快捷键保持一致）
nnoremap <silent> <Leader>hx :call <SID>ToggleXxd()<CR>

" 拦截 .vimhex 文件的保存事件
augroup XxdVimhexSave
    autocmd!
    " 拦截写入命令，自动保存到源文件
    autocmd BufWriteCmd *.vimhex call s:HandleVimhexWrite()
augroup END

" 处理 .vimhex 文件的写入
function! s:HandleVimhexWrite() abort
    if !exists('b:xxd_source_file')
        " 没有源文件信息，使用默认保存（绕过 BufWriteCmd）
        execute 'silent write! ' . fnameescape(expand('%:p'))
        setlocal nomodified
        return
    endif
    
    " 先保存 .vimhex 文件本身（绕过 BufWriteCmd 避免循环）
    let l:vimhex_file = expand('%:p')
    let l:vimhex_content = getline(1, '$')
    call writefile(l:vimhex_content, l:vimhex_file)
    
    " 转换回二进制并写入源文件
    let l:source_file = b:xxd_source_file
    
    " 使用临时缓冲区进行转换
    let l:temp_buf = bufnr('%')
    let l:cur_pos = getpos('.')
    let l:temp_input = tempname()
    let l:temp_output = tempname()
    
    " 保存当前内容到临时文件
    call writefile(l:vimhex_content, l:temp_input)
    
    " 创建临时缓冲区并转换
    let l:new_buf = bufadd('temp_xxd_convert')
    call bufload(l:new_buf)
    call setbufvar(l:new_buf, '&buftype', 'nofile')
    call setbufvar(l:new_buf, '&bufhidden', 'wipe')
    execute 'buffer ' . l:new_buf
    execute 'silent read ' . fnameescape(l:temp_input)
    execute 'silent %!xxd -r'
    " 保存转换后的二进制内容
    execute 'silent write! ' . fnameescape(l:temp_output)
    execute 'bwipeout ' . l:new_buf
    execute 'buffer ' . l:temp_buf
    call setpos('.', l:cur_pos)
    
    " 读取二进制内容并写入源文件
    if filereadable(l:temp_output)
        let l:binary_content = readfile(l:temp_output, 'b')
        call writefile(l:binary_content, l:source_file, 'b')
        call delete(l:temp_output)
        
        " 成功保存后，删除 .vimhex 文件并切换到源文件
        if filereadable(l:vimhex_file)
            call delete(l:vimhex_file)
        endif
        
        " 切换到源文件
        execute 'edit ' . fnameescape(l:source_file)
        " echomsg '[xxd] 已保存到源文件并删除 .vimhex 文件'
    else
        echohl ErrorMsg
        echomsg '[xxd] 转换失败，无法保存到源文件'
        echohl None
        " 转换失败时，标记为已保存（避免重复保存），但保留 .vimhex 文件
        setlocal nomodified
    endif
    call delete(l:temp_input)
endfunction

" 在十六进制模式下的快捷键
augroup XxdKeymaps
    autocmd!
    autocmd FileType xxd call s:XxdKeymaps()
augroup END

function! s:XxdKeymaps() abort
    " 如果是 .vimhex 文件，设置特殊快捷键
    if expand('%:e') ==# 'vimhex' && exists('b:xxd_source_file')
        " 保存：保存到源文件（:w 会自动触发）
        nnoremap <buffer> <silent> s :write<CR>
        
        " 退出：保存到源文件并删除 .vimhex 文件
        nnoremap <buffer> <silent> q :call <SID>SaveQuitXxd()<CR>
        
        " 切换：关闭 .vimhex 文件，返回源文件
        nnoremap <buffer> <silent> <Leader>hx :call <SID>ToggleXxd()<CR>
    else
        " 普通 xxd 模式的快捷键
        nnoremap <buffer> <silent> e :setlocal modifiable<CR>:setlocal noreadonly<CR>
        nnoremap <buffer> <silent> s :call <SID>SaveXxd()<CR>
        nnoremap <buffer> <silent> q :setlocal modifiable<CR>:setlocal noreadonly<CR>:silent %!xxd -r<CR>:setlocal filetype=<CR>:setlocal binary<CR>:setlocal noeol<CR>:setlocal fixeol<CR>:write<CR>:quit<CR>
        nnoremap <buffer> <silent> <Leader>hx :call <SID>ToggleXxd()<CR>
    endif
endfunction

"==============================================================
" 3. 高级功能
"==============================================================

" 使用自定义格式打开十六进制（每行字节数、分组大小等）
function! s:OpenXxdCustom(cols, groups) abort
    let l:cols = a:cols > 0 ? a:cols : 16
    let l:groups = a:groups > 0 ? a:groups : 2
    
    if &filetype == 'xxd'
        setlocal modifiable
        setlocal noreadonly
    else
        setlocal binary
    endif
    
    " 使用 xxd 的自定义格式
    " -c: 每行字节数
    " -g: 分组大小
    execute 'silent %!xxd -c' . l:cols . ' -g' . l:groups
    setlocal filetype=xxd
    setlocal readonly
    setlocal nomodifiable
    
    " echomsg '[xxd] 已切换到十六进制模式（每行 ' . l:cols . ' 字节，分组 ' . l:groups . '）'
endfunction

" 命令映射
command! -nargs=* XxdToggle call s:ToggleXxd()
command! -nargs=* XxdOpen call s:OpenXxd()
command! -nargs=* XxdSave call s:SaveXxd()
command! -nargs=* -complete=customlist,s:XxdCustomComplete XxdCustom call s:OpenXxdCustom(<f-args>)

function! s:XxdCustomComplete(ArgLead, CmdLine, CursorPos) abort
    return ['16 2', '8 1', '32 4', '16 1']
endfunction

"==============================================================
" 4. 文件类型特定配置
"==============================================================

" 为 xxd 文件类型设置语法高亮和显示选项
augroup XxdFileType
    autocmd!
    autocmd FileType xxd setlocal
        \ number
        \ relativenumber
        \ wrap
        \ listchars=
        \ tabstop=16
        \ shiftwidth=16
        \ softtabstop=16
        \ expandtab
augroup END

"==============================================================
" 5. 使用提示
"==============================================================

" 显示使用帮助
function! s:ShowXxdHelp() abort
    echohl Title
    echomsg '=============================================================='
    echomsg 'xxd 十六进制编辑器使用说明'
    echomsg '=============================================================='
    echohl None
    echomsg '快捷键：'
    echomsg '  <Leader>hx          - 切换十六进制模式'
    echomsg '  :XxdToggle          - 切换十六进制模式'
    echomsg '  :XxdOpen             - 打开十六进制视图'
    echomsg '  :XxdSave             - 保存并保持十六进制视图'
    echomsg '  :XxdCustom <cols> <groups> - 自定义格式（如 :XxdCustom 8 1）'
    echomsg ''
    echomsg '在十六进制模式下：'
    echomsg '  e                   - 启用编辑模式'
    echomsg '  s                   - 保存并保持十六进制视图'
    echomsg '  q                   - 保存并退出'
    echomsg '  <Leader>hx          - 切换回二进制模式'
    echomsg ''
    echomsg '注意事项：'
    echomsg '  - 编辑时请保持十六进制格式的完整性'
    echomsg '  - 不要添加或删除字节（保持每行格式一致）'
    echomsg '  - 修改后使用 :XxdSave 或 s 键保存'
    echomsg ''
    echohl Title
    echomsg '=============================================================='
    echohl None
endfunction

command! XxdHelp call s:ShowXxdHelp()

