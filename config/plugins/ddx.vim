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
" 1. ddx.vim 基础配置
"==============================================================

" 注意：必须在 denops.vim 初始化后才能配置
" 使用 DenopsReady 事件确保 denops 已就绪
function! s:SetupDdx() abort
    " 检查 ddx 是否可用
    if !exists('*ddx#custom#patch_global')
        return
    endif

    " 设置默认 UI（必须首先设置）
    " 参考：https://github.com/Shougo/ddx-ui-hex
    try
        call ddx#custom#patch_global({
                    \   'ui': 'hex',
                    \ })
    catch /.*/
        " 如果设置失败，可能是 ddx-ui-hex 未安装
        echohl WarningMsg
        echomsg '[ddx] UI 配置失败: ' . v:exception
        echomsg '[ddx] 请确保已安装 ddx-ui-hex 插件'
        echohl None
        return
    endtry

    " 设置默认选项
    " length: 文件长度（0 表示完整文件，默认 1MB）
    " 如果文件太大，可能会冻结
    try
        call ddx#custom#patch_global({
                    \   'length': 1 * 1024 * 1024,
                    \   'offset': 0,
                    \ })
    catch /.*/
        " 忽略选项设置错误
    endtry
endfunction

" 在 denops 就绪后设置配置
augroup DdxSetup
    autocmd!
    " 等待 denops 初始化完成
    autocmd User DenopsReady call s:SetupDdx()
augroup END

" 如果 denops 已经就绪，立即设置（延迟检查）
" 使用多次尝试，确保 ddx.vim 加载
function! s:TrySetupDdx() abort
    " 如果 denops 未运行，等待
    if !exists('*denops#server#status') || denops#server#status() !=# 'running'
        call timer_start(500, { -> s:TrySetupDdx() })
        return
    endif
    
    " 如果 ddx 未加载，尝试加载
    if !exists('*ddx#custom#patch_global')
        " 尝试加载 ddx.vim 的 autoload
        let l:ddx_path = expand('~/.vim/plugged/ddx.vim')
        if isdirectory(l:ddx_path) && filereadable(l:ddx_path . '/autoload/ddx.vim')
            try
                execute 'source ' . fnameescape(l:ddx_path . '/autoload/ddx.vim')
            catch
                " 加载失败，稍后重试
                call timer_start(1000, { -> s:TrySetupDdx() })
                return
            endtry
        else
            " 插件未安装，不再重试
            return
        endif
    endif
    
    " ddx 已加载，设置配置
    call s:SetupDdx()
endfunction

" 立即尝试设置（如果 denops 已就绪）
if exists('*denops#server#status') && denops#server#status() ==# 'running'
    call timer_start(500, { -> s:TrySetupDdx() })
else
    " 等待 denops 就绪
    call timer_start(1000, { -> s:TrySetupDdx() })
endif

" 手动加载 ddx.vim 插件（诊断用，通常不需要）
function! s:LoadDdxPlugin() abort
    " 检查插件是否已安装
    let l:ddx_path = expand('~/.vim/plugged/ddx.vim')
    if !isdirectory(l:ddx_path)
        echohl ErrorMsg
        echomsg '[ddx] 插件未安装，请执行 :PlugInstall'
        echohl None
        return
    endif

    " 尝试手动加载插件
    try
        " 加载 ddx.vim 的 autoload 文件
        if filereadable(l:ddx_path . '/autoload/ddx.vim')
            execute 'source ' . fnameescape(l:ddx_path . '/autoload/ddx.vim')
            echomsg '[ddx] 插件已手动加载'
        endif

        " 等待一下让 denops 处理，然后设置配置
        call timer_start(500, { -> s:SetupDdx() })
    catch /.*/
        echohl ErrorMsg
        echomsg '[ddx] 加载失败: ' . v:exception
        echohl None
    endtry
endfunction

"==============================================================
" 2. 打开十六进制编辑器
"==============================================================

function! s:OpenHexEditor(filepath) abort
    " 检查 ddx 是否可用
    if !exists('*ddx#start')
        " 尝试自动加载
        call s:TrySetupDdx()
        
        " 等待一下再检查（最多等待 3 秒）
        if !exists('s:ddx_wait_count')
            let s:ddx_wait_count = 0
        endif
        let s:ddx_wait_count += 1
        
        if s:ddx_wait_count < 6  " 等待最多 3 秒（6 * 500ms）
            echomsg '[ddx] 正在加载 ddx.vim，请稍候...'
            call timer_start(500, { -> 
                  \ if exists('*ddx#start')
                  \   | let s:ddx_wait_count = 0
                  \   | call s:OpenHexEditor(a:filepath)
                  \ else
                  \   | call s:OpenHexEditor(a:filepath)
                  \ endif
                  \ })
            return
        else
            " 等待超时，提示用户
            let s:ddx_wait_count = 0
            echohl ErrorMsg
            echomsg '[ddx] ddx.vim 加载超时'
            echomsg '[ddx] 请执行 :DdxLoad 手动加载，或重启 Vim'
            echohl None
            return
        endif
    endif
    
    " 重置等待计数
    if exists('s:ddx_wait_count')
        let s:ddx_wait_count = 0
    endif

    " 如果没有指定文件路径，使用当前文件
    let l:path = empty(a:filepath) ? expand('%:p') : a:filepath

    if empty(l:path)
        echohl ErrorMsg
        echomsg '[ddx] 请指定文件路径或打开一个文件'
        echohl None
        return
    endif

    " 确保文件存在
    if !filereadable(l:path)
        echohl ErrorMsg
        echomsg '[ddx] 文件不存在: ' . l:path
        echohl None
        return
    endif

    " 确保配置已设置
    if !exists('*ddx#custom#patch_global')
        call s:SetupDdx()
    endif
    
    " 确保 UI 配置已设置（如果还没有）
    if exists('*ddx#custom#get_global')
        let l:global_opts = ddx#custom#get_global()
        if empty(get(l:global_opts, 'ui', ''))
            call s:SetupDdx()
        endif
    endif

    " 启动 ddx（明确指定 UI，确保配置正确）
    try
        " 明确指定 UI 参数
        call ddx#start({
                    \   'path': l:path,
                    \   'name': 'hex',
                    \   'ui': 'hex',
                    \ })
    catch /.*/
        echohl ErrorMsg
        echomsg '[ddx] 打开失败: ' . v:exception
        echomsg '[ddx] 提示：请确保已安装 ddx-ui-hex 插件'
        echohl None
    endtry
endfunction

"==============================================================
" 3. 快捷键映射
"==============================================================

" 打开当前文件的十六进制编辑器
nnoremap <silent> <Leader>hx :call <SID>OpenHexEditor('')<CR>
" 打开指定文件的十六进制编辑器
command! -nargs=1 -complete=file Ddx call <SID>OpenHexEditor(<q-args>)
" 手动加载 ddx 插件（诊断用）
command! DdxLoad call <SID>LoadDdxPlugin()

"==============================================================
" 4. 帮助信息
"==============================================================

" ddx.vim 的主要功能：
"   - 异步十六进制编辑器 UI
"   - 支持大文件编辑
"   - 支持二进制文件分析
"
" 系统要求：
"   - Vim 9.1.1646+ 或 Neovim 0.11.0+
"   - Deno 2.3.0+（需要单独安装）
"   - denops.vim v8.0+
"   - ddx-ui-hex（UI 插件）
"
" 安装步骤：
"   1. 安装 Deno: https://deno.land/
"   2. 执行 :PlugInstall 安装插件
"   3. 重启 Vim
"
" 快捷键：
"   <Leader>hx        - 打开当前文件的十六进制编辑器
"   :Ddx <文件路径>  - 打开指定文件的十六进制编辑器
"
" 诊断命令：
"   :echo denops#server#status()  - 检查 denops 状态
"   :echo exists('*ddx#start')     - 检查 ddx 是否加载
"   :call ddx#load()               - 手动加载 ddx 插件（如果未自动加载）
"
" 更多信息：
"   :help ddx
"   https://github.com/Shougo/ddx.vim

