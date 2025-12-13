"==============================================================
" config/bootstrap/env_check.vim
" 环境检测：依赖检查和环境修复
"==============================================================

if exists('g:loaded_env_check')
  finish
endif
let g:loaded_env_check = 1

"==============================================================
" 1. 依赖检测
"==============================================================
" 注意：ripgrep (rg) 检测已移至 config/plugins/fzf.vim
" 因为它是 FZF 插件的依赖，只在加载 FZF 时检测

" 检测 node.js - coc.nvim 需要（需要 Node.js 14+）
" 使用延迟检测机制，在插件加载后检查（只在非基础配置模式下提示）
function! s:check_nodejs() abort
  " 只在插件配置加载后才检测（避免基础配置模式下提示）
  if !exists('g:loaded_plugin_bootstrap')
    return
  endif
  
  if executable('node') == 0
    " Node.js 未安装
    silent! echohl WarningMsg
    silent! echomsg '[环境检测] Node.js 未安装，coc.nvim 将无法正常工作'
    silent! echomsg '[安装方法] Windows: choco install nodejs 或访问: https://nodejs.org/'
    silent! echomsg '[安装方法] Linux: 使用 nvm 安装（推荐）: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash'
    silent! echohl None
  else
    " Node.js 已安装，检测版本
    let l:node_version_output = system('node --version 2>&1')
    let l:node_version_str = substitute(l:node_version_output, '\n$', '', '')
    " 解析版本号：v12.22.9 -> [12, 22, 9] 或 18.20.8 -> [18, 20, 8]
    let l:node_version_str = substitute(l:node_version_str, '^v', '', '')
    let l:node_version_parts = split(l:node_version_str, '\.')
    if len(l:node_version_parts) >= 1
      let l:node_major_version = str2nr(l:node_version_parts[0])
      " coc.nvim 需要 Node.js 14+
      if l:node_major_version < 14
        " 版本过低，检查是否有 nvm 安装的 Node.js 18
        let l:nvm_node = expand('~/.nvm/versions/node/v18.20.8/bin/node')
        let l:nvm_node_alt = expand('~/.nvm/versions/node/v18/bin/node')
        let l:has_nvm_node = filereadable(l:nvm_node) || filereadable(l:nvm_node_alt)
        
        silent! echohl WarningMsg
        silent! echomsg '[环境检测] Node.js 版本过低（当前: ' . l:node_version_str . '），coc.nvim 需要 Node.js 14+'
        if l:has_nvm_node
          silent! echomsg '[解决方案] 已检测到 nvm 安装的 Node.js 18，coc.nvim 配置已自动使用该版本'
        else
          silent! echomsg '[解决方案] 请升级 Node.js 或使用 nvm 安装 Node.js 18+'
          silent! echomsg '[安装方法] nvm: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash'
          silent! echomsg '[安装方法] 然后运行: nvm install 18 && nvm use 18'
        endif
        silent! echohl None
      endif
    endif
  endif
endfunction

" 延迟执行检测（在 VimEnter 事件后，确保插件已加载）
augroup EnvCheckNodeJS
  autocmd!
  autocmd VimEnter * call s:check_nodejs()
augroup END

" 检测 git - 插件管理需要
" 使用延迟检测机制，在插件加载后检查（只在非基础配置模式下提示）
function! s:check_git() abort
  " 只在插件配置加载后才检测（避免基础配置模式下提示）
  if !exists('g:loaded_plugin_bootstrap')
    return
  endif
  
  if executable('git') == 0
    silent! echohl WarningMsg
    silent! echomsg '[环境检测] Git 未安装，插件管理功能将无法使用'
    silent! echomsg '[安装方法] Windows: choco install git 或访问: https://git-scm.com/'
    silent! echohl None
  endif
endfunction

" 延迟执行检测（在 VimEnter 事件后，确保插件已加载）
augroup EnvCheckGit
  autocmd!
  autocmd VimEnter * call s:check_git()
augroup END

"==============================================================
" 3. ESLint 检测和自动安装
"==============================================================
" 检测 ESLint 是否已安装（全局或本地）
function! s:check_eslint() abort
  " 只在插件配置加载后才检测（避免基础配置模式下提示）
  if !exists('g:loaded_plugin_bootstrap')
    return
  endif
  
  " 检查 Node.js 是否可用
  if executable('node') == 0
    return
  endif
  
  " 检查 npm 是否可用
  if executable('npm') == 0
    silent! echohl WarningMsg
    silent! echomsg '[环境检测] npm 未安装，无法自动安装 ESLint'
    silent! echomsg '[安装方法] npm 通常随 Node.js 一起安装，请检查 Node.js 安装'
    silent! echohl None
    return
  endif
  
  " 检测全局 ESLint
  let l:eslint_installed = 0
  let l:eslint_version = ''
  let l:eslint_path = ''
  
  " 方法1: 检查 eslint 命令是否可用
  if executable('eslint')
    let l:eslint_path = system('which eslint 2>/dev/null')
    let l:eslint_path = substitute(l:eslint_path, '\n$', '', '')
    let l:version_output = system('eslint --version 2>&1')
    if l:version_output =~# 'v\?\d\+\.\d\+\.\d\+'
      let l:eslint_installed = 1
      let l:eslint_version = substitute(l:version_output, '\n$', '', '')
      let l:eslint_version = substitute(l:eslint_version, '^v', '', '')
    endif
  endif
  
  " 方法2: 检查 npm 全局包列表
  if !l:eslint_installed
    let l:npm_list_output = system('npm list -g eslint 2>&1')
    if l:npm_list_output =~# 'eslint@'
      let l:eslint_installed = 1
      " 提取版本号
      let l:version_match = matchstr(l:npm_list_output, 'eslint@\zs[0-9.]\+')
      if !empty(l:version_match)
        let l:eslint_version = l:version_match
      endif
    endif
  endif
  
  " 如果未安装，提示并询问是否自动安装
  if !l:eslint_installed
    silent! echohl WarningMsg
    silent! echomsg '[环境检测] ESLint 未安装，coc-eslint 需要 ESLint 才能正常工作'
    silent! echomsg '[提示] 运行 :InstallESLint 可以自动安装 ESLint（全局安装）'
    silent! echohl None
  else
    " 检查版本是否过旧（建议使用 8.0+）
    if !empty(l:eslint_version)
      let l:version_parts = split(l:eslint_version, '\.')
      if len(l:version_parts) >= 1
        let l:major_version = str2nr(l:version_parts[0])
        if l:major_version < 8
          silent! echohl WarningMsg
          silent! echomsg '[环境检测] ESLint 版本较旧（当前: ' . l:eslint_version . '），建议升级到 8.0+'
          silent! echomsg '[提示] 运行 :UpgradeESLint 可以升级 ESLint'
          silent! echohl None
        endif
      endif
    endif
  endif
endfunction

" 自动安装 ESLint（全局安装）
function! s:install_eslint() abort
  if executable('npm') == 0
    echohl ErrorMsg
    echomsg '[错误] npm 未安装，无法安装 ESLint'
    echohl None
    return
  endif
  
  echohl Question
  echo '[ESLint 安装] 正在全局安装 ESLint（最新版本）...'
  echohl None
  
  " 执行安装命令
  let l:install_cmd = 'npm install -g eslint@latest'
  let l:output = system(l:install_cmd)
  let l:exit_code = v:shell_error
  
  if l:exit_code == 0
    echohl MoreMsg
    echomsg '[ESLint 安装] ✓ 安装成功！'
    echohl None
    " 显示版本信息
    let l:version = system('eslint --version 2>&1')
    if !empty(l:version)
      echo '版本: ' . substitute(l:version, '\n$', '', '')
    endif
    echohl Question
    echo '[提示] 请运行 :CocRestart 重启 coc.nvim 以使 ESLint 生效'
    echohl None
  else
    echohl ErrorMsg
    echomsg '[ESLint 安装] ✗ 安装失败，请检查错误信息：'
    echomsg l:output
    echohl None
  endif
endfunction

" 升级 ESLint
function! s:upgrade_eslint() abort
  if executable('npm') == 0
    echohl ErrorMsg
    echomsg '[错误] npm 未安装，无法升级 ESLint'
    echohl None
    return
  endif
  
  echohl Question
  echo '[ESLint 升级] 正在升级 ESLint 到最新版本...'
  echohl None
  
  let l:upgrade_cmd = 'npm install -g eslint@latest'
  let l:output = system(l:upgrade_cmd)
  let l:exit_code = v:shell_error
  
  if l:exit_code == 0
    echohl MoreMsg
    echomsg '[ESLint 升级] ✓ 升级成功！'
    echohl None
    let l:version = system('eslint --version 2>&1')
    if !empty(l:version)
      echo '当前版本: ' . substitute(l:version, '\n$', '', '')
    endif
    echohl Question
    echo '[提示] 请运行 :CocRestart 重启 coc.nvim 以使新版本生效'
    echohl None
  else
    echohl ErrorMsg
    echomsg '[ESLint 升级] ✗ 升级失败，请检查错误信息：'
    echomsg l:output
    echohl None
  endif
endfunction

" 定义命令
command! InstallESLint call s:install_eslint()
command! UpgradeESLint call s:upgrade_eslint()

" 延迟执行检测（在 VimEnter 事件后，确保插件已加载）
augroup EnvCheckESLint
  autocmd!
  autocmd VimEnter * call s:check_eslint()
augroup END
