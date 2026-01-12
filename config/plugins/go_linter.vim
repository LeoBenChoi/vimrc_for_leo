"==============================================================
" config/plugins/go_linter.vim
" Go 语言 Linter 配置：个人配置隔离
"==============================================================

if exists('g:loaded_go_linter_config')
    finish
endif
let g:loaded_go_linter_config = 1

"==============================================================
" 配置文件路径
"==============================================================
" 个人配置文件目录
let s:linter_config_dir = expand('~/.vim/config/linters')
let s:golangci_config = s:linter_config_dir . '/.golangci.yml'
let s:revive_config = s:linter_config_dir . '/revive.toml'

"==============================================================
" 环境变量设置（用于隔离个人配置和项目配置）
"==============================================================
if !exists('g:golangci_lint_config')
    let g:golangci_lint_config = s:golangci_config
endif

"==============================================================
" 命令定义
"==============================================================
" 检查 golangci-lint 是否已安装
function! s:CheckGolangciLint() abort
    if executable('golangci-lint')
        return 1
    endif
    echohl WarningMsg
    echomsg '[go_linter] golangci-lint 未安装，请运行: go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest'
    echohl None
    return 0
endfunction

" 运行 golangci-lint（智能选择配置文件）
function! s:RunGolangciLintWithPersonalConfig() abort
    if !s:CheckGolangciLint()
        return
    endif

    " 获取当前文件所在的项目根目录（查找 go.mod 或 .git）
    let l:project_root = s:FindProjectRoot()
    if empty(l:project_root)
        echohl WarningMsg
        echomsg '[go_linter] 未找到项目根目录（go.mod 或 .git）'
        echohl None
        return
    endif

    " 检查项目中是否有 .golangci.yml
    let l:project_config = l:project_root . '/.golangci.yml'
    let l:use_project_config = filereadable(l:project_config)

    " 构建命令
    let l:cmd = 'golangci-lint run'

    if l:use_project_config
        echomsg '[go_linter] 使用项目配置: ' . l:project_config
    else
        let l:personal_config = expand(s:golangci_config)
        if !filereadable(l:personal_config)
            echohl ErrorMsg
            echomsg '[go_linter] 个人配置文件不存在: ' . l:personal_config
            echohl None
            return
        endif
        let l:cmd .= ' --config ' . shellescape(l:personal_config)
        echomsg '[go_linter] 使用个人配置: ' . l:personal_config
    endif

    let l:cmd .= ' ' . shellescape(l:project_root)
    execute '!' . l:cmd
endfunction

" 查找项目根目录
function! s:FindProjectRoot() abort
    let l:current_file = expand('%:p:h')
    let l:root = l:current_file

    while l:root != '/'
        if filereadable(l:root . '/go.mod') || isdirectory(l:root . '/.git')
            return l:root
        endif
        let l:parent = fnamemodify(l:root, ':h')
        if l:parent == l:root
            break
        endif
        let l:root = l:parent
    endwhile

    return ''
endfunction

" 检查 govulncheck 是否可用
function! s:CheckGovulncheck() abort
    let l:output = system('govulncheck --version 2>&1')
    if v:shell_error == 0 || l:output =~# 'govulncheck'
        return 1
    endif
    echohl WarningMsg
    echomsg '[go_linter] govulncheck 不可用，请确保 Go 版本 >= 1.18'
    echomsg '[go_linter] 安装命令: go install golang.org/x/vuln/cmd/govulncheck@latest'
    echohl None
    return 0
endfunction

" 运行 govulncheck 漏洞检查
function! s:RunGovulncheck() abort
    if !s:CheckGovulncheck()
        return
    endif

    let l:project_root = s:FindProjectRoot()
    if empty(l:project_root)
        echohl WarningMsg
        echomsg '[go_linter] 未找到项目根目录（go.mod 或 .git）'
        echohl None
        return
    endif

    let l:cmd = 'govulncheck ' . shellescape(l:project_root)
    echomsg '[go_linter] 运行 govulncheck 漏洞检查...'
    execute '!' . l:cmd
endfunction

"==============================================================
" 命令映射
"==============================================================
command! -nargs=0 GolangciLintPersonal call s:RunGolangciLintWithPersonalConfig()
command! -nargs=0 Govulncheck call s:RunGovulncheck()

" 快捷键映射
nnoremap <silent> <leader>gl :GolangciLintPersonal<CR>
nnoremap <silent> <leader>gv :Govulncheck<CR>
