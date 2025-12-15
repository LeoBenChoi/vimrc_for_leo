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

" 处理 node --version 异步执行结果
function! s:handle_node_version_result(temp_file, job, status) abort
  if !filereadable(a:temp_file)
    return
  endif
  
  let l:version_output = readfile(a:temp_file, 'b')
  if empty(l:version_output)
    call delete(a:temp_file)
    return
  endif
  
  let l:output = join(l:version_output, "\n")
  call delete(a:temp_file)
  
  let l:node_version_str = substitute(l:output, '\n$', '', '')
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
endfunction


" 手动检测 Node.js（用户主动触发）
function! s:check_nodejs_manual() abort
  if executable('node') == 0
    echohl WarningMsg
    echomsg '[环境检测] Node.js 未安装，coc.nvim 将无法正常工作'
    echomsg '[安装方法] Windows: choco install nodejs 或访问: https://nodejs.org/'
    echomsg '[安装方法] Linux: 使用 nvm 安装（推荐）: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash'
    echohl None
    return
  endif
  
  " Node.js 已安装，检查版本
  if has('job') && has('channel')
    let l:temp_file = tempname()
    let l:job = job_start(['node', '--version'], {
          \ 'out_io': 'file',
          \ 'out_name': l:temp_file,
          \ 'err_io': 'file',
          \ 'err_name': l:temp_file,
          \ 'exit_cb': function('s:handle_node_version_result', [l:temp_file])
          \ })
    if job_status(l:job) !=# 'run'
      " 异步启动失败，使用同步方式
      let l:node_version_output = system('node --version 2>&1')
      call s:process_node_version_result(l:node_version_output)
    endif
  else
    let l:node_version_output = system('node --version 2>&1')
    call s:process_node_version_result(l:node_version_output)
  endif
endfunction

" 处理 Node.js 版本结果（同步方式）
function! s:process_node_version_result(output) abort
  let l:node_version_str = substitute(a:output, '\n$', '', '')
  let l:node_version_str = substitute(l:node_version_str, '^v', '', '')
  let l:node_version_parts = split(l:node_version_str, '\.')
  if len(l:node_version_parts) >= 1
    let l:node_major_version = str2nr(l:node_version_parts[0])
    if l:node_major_version < 14
      let l:nvm_node = expand('~/.nvm/versions/node/v18.20.8/bin/node')
      let l:nvm_node_alt = expand('~/.nvm/versions/node/v18/bin/node')
      let l:has_nvm_node = filereadable(l:nvm_node) || filereadable(l:nvm_node_alt)
      
      echohl WarningMsg
      echomsg '[环境检测] Node.js 版本过低（当前: ' . l:node_version_str . '），coc.nvim 需要 Node.js 14+'
      if l:has_nvm_node
        echomsg '[解决方案] 已检测到 nvm 安装的 Node.js 18，coc.nvim 配置已自动使用该版本'
      else
        echomsg '[解决方案] 请升级 Node.js 或使用 nvm 安装 Node.js 18+'
        echomsg '[安装方法] nvm: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash'
        echomsg '[安装方法] 然后运行: nvm install 18 && nvm use 18'
      endif
      echohl None
    else
      echohl MoreMsg
      echomsg '[环境检测] Node.js 版本正常（当前: ' . l:node_version_str . '）'
      echohl None
    endif
  endif
endfunction

" 不自动检测，用户需要时手动运行 :CheckNodeJS

" 手动检测 Git（用户主动触发）
function! s:check_git_manual() abort
  if executable('git') == 0
    echohl WarningMsg
    echomsg '[环境检测] Git 未安装，插件管理功能将无法使用'
    echomsg '[安装方法] Windows: choco install git 或访问: https://git-scm.com/'
    echohl None
  else
    let l:git_version = system('git --version 2>&1')
    echohl MoreMsg
    echomsg '[环境检测] Git 已安装: ' . substitute(l:git_version, '\n$', '', '')
    echohl None
  endif
endfunction

" 不自动检测，用户需要时手动运行 :CheckGit

"==============================================================
" 3. ESLint 检测和自动安装
"==============================================================

" 手动检查 ESLint（包括 npm list，用户主动触发）
function! s:check_eslint_manual() abort
  if executable('node') == 0
    echohl ErrorMsg
    echomsg '[错误] Node.js 未安装'
    echohl None
    return
  endif
  
  if executable('npm') == 0
    echohl ErrorMsg
    echomsg '[错误] npm 未安装'
    echohl None
    return
  endif
  
  " 先检查 eslint 命令
  if executable('eslint')
    echohl MoreMsg
    echomsg '[ESLint 检测] eslint 命令可用'
    echohl None
    " 检查版本
    let l:version_output = system('eslint --version 2>&1')
    if l:version_output =~# 'v\?\d\+\.\d\+\.\d\+'
      let l:eslint_version = substitute(l:version_output, '\n$', '', '')
      let l:eslint_version = substitute(l:eslint_version, '^v', '', '')
      echo '版本: ' . l:eslint_version
    endif
    return
  endif
  
  " eslint 命令不可用，检查 npm 全局包列表
  echohl Question
  echo '[ESLint 检测] 正在检查 npm 全局包列表...'
  echohl None
  
  if has('job') && has('channel')
    let l:temp_file = tempname()
    let l:job = job_start(['npm', 'list', '-g', 'eslint'], {
          \ 'out_io': 'file',
          \ 'out_name': l:temp_file,
          \ 'err_io': 'file',
          \ 'err_name': l:temp_file,
          \ 'exit_cb': function('s:handle_npm_list_result_manual', [l:temp_file])
          \ })
    if job_status(l:job) !=# 'run'
      " 异步启动失败，使用同步方式
      let l:npm_list_output = system('npm list -g eslint 2>&1')
      call s:process_npm_list_result(l:npm_list_output)
    endif
  else
    " 不支持异步，使用同步方式
    let l:npm_list_output = system('npm list -g eslint 2>&1')
    call s:process_npm_list_result(l:npm_list_output)
  endif
endfunction

" 处理手动检查的 npm list 结果
function! s:handle_npm_list_result_manual(temp_file, job, status) abort
  if !filereadable(a:temp_file)
    return
  endif
  
  let l:npm_list_output = readfile(a:temp_file, 'b')
  call delete(a:temp_file)
  
  if !empty(l:npm_list_output)
    let l:output = join(l:npm_list_output, "\n")
    call s:process_npm_list_result(l:output)
  endif
endfunction

" 处理 npm list 输出结果
function! s:process_npm_list_result(output) abort
  if a:output =~# 'eslint@'
    let l:version_match = matchstr(a:output, 'eslint@\zs[0-9.]\+')
    if !empty(l:version_match)
      echohl MoreMsg
      echomsg '[ESLint 检测] ESLint 已安装（版本: ' . l:version_match . '）'
      echohl None
    else
      echohl MoreMsg
      echomsg '[ESLint 检测] ESLint 已安装'
      echohl None
    endif
  else
    echohl WarningMsg
    echomsg '[ESLint 检测] ESLint 未安装'
    echomsg '[提示] 运行 :InstallESLint 可以自动安装 ESLint（全局安装）'
    echohl None
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
command! CheckESLint call s:check_eslint_manual()
command! CheckNodeJS call s:check_nodejs_manual()
command! CheckGit call s:check_git_manual()

" 不自动检测，用户需要时手动运行 :CheckESLint
