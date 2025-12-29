"==============================================================
" config/plugins/go_linter.vim
" Go 语言 Linter 配置：个人配置隔离
"==============================================================

if exists('g:loaded_go_linter_config')
    finish
endif
let g:loaded_go_linter_config = 1

"==============================================================
" 1. 配置文件路径
"==============================================================
" 个人配置文件目录
let s:linter_config_dir = expand('~/.vim/config/linters')
let s:golangci_config = s:linter_config_dir . '/.golangci.yml'
let s:revive_config = s:linter_config_dir . '/revive.toml'

"==============================================================
" 2. 环境变量设置（用于隔离个人配置和项目配置）
"==============================================================
" 设置 golangci-lint 使用个人配置文件
" 注意：golangci-lint 会按以下顺序查找配置文件：
"   1. 项目根目录的 .golangci.yml（优先级最高）
"   2. 通过 --config 参数指定的配置文件
"   3. 用户主目录的 .golangci.yml
"   4. 默认配置
"
" 为了隔离个人配置和项目配置，我们使用环境变量和命令别名
if !exists('g:golangci_lint_config')
    let g:golangci_lint_config = s:golangci_config
endif

"==============================================================
" 3. 命令定义
"==============================================================
" 定义使用个人配置的 golangci-lint 命令
" 注意：这些命令仅在 Vim 中使用，不会影响系统环境

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
" 优先级：项目配置 > 个人配置
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
        " 项目中有配置文件，使用项目配置（不指定 --config 参数）
        echomsg '[go_linter] 使用项目配置: ' . l:project_config
    else
        " 项目中没有配置文件，使用个人配置
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

    " 添加项目根目录作为运行路径
    let l:cmd .= ' ' . shellescape(l:project_root)

    " 执行命令
    execute '!' . l:cmd
endfunction

" 查找项目根目录
function! s:FindProjectRoot() abort
    let l:current_file = expand('%:p:h')
    let l:root = l:current_file

    " 向上查找包含 go.mod 或 .git 的目录
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

"==============================================================
" 4. 命令映射
"==============================================================
" 定义 Vim 命令
command! -nargs=0 GolangciLintPersonal call s:RunGolangciLintWithPersonalConfig()

" 快捷键映射（可选）
" 使用 <leader>gl 运行个人配置的 golangci-lint
nnoremap <silent> <leader>gl :GolangciLintPersonal<CR>

"==============================================================
" 5. 自动检查配置（可选）
"==============================================================
" 在打开 Go 文件时，可以显示配置状态
augroup GoLinterConfig
    autocmd!
    " 可选：在打开 Go 文件时检查配置
    " autocmd FileType go call s:CheckGolangciLint()

    " 可选：保存文件时自动运行 golangci-lint
    " 取消下面的注释以启用自动检查
    " 注意：这可能会在保存时产生延迟，特别是大型项目
    "   autocmd BufWritePost *.go call s:RunGolangciLintWithPersonalConfig()
augroup END

"==============================================================
" 6. 说明信息
"==============================================================
" 配置文件位置：
"   - golangci-lint: ~/.vim/config/linters/.golangci.yml
"   - revive: ~/.vim/config/linters/revive.toml
"
" 使用方法：
"   1. 安装 golangci-lint: go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
"   2. 在 Go 文件中使用 :GolangciLintPersonal 或 <leader>gl 运行检查
"
" 配置优先级：
"   - 如果项目中有 .golangci.yml，使用项目配置（优先级最高）
"   - 如果项目中没有 .golangci.yml，使用个人配置（~/.vim/config/linters/.golangci.yml）
"
" 注意：
"   - staticcheck 已通过 gopls 在编辑器中实时显示
"   - revive 通过 golangci-lint 使用，需要手动运行命令
"   - 自动检测项目配置，无需手动切换

