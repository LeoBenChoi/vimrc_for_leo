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
" 2.5. Ctags 检测
"==============================================================

" 检测 ctags 可执行文件（Windows 兼容）
function! s:find_ctags_executable() abort
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

" 手动检测 Ctags（用户主动触发）
function! s:check_ctags_manual() abort
  let l:ctags_cmd = s:find_ctags_executable()
  
  if empty(l:ctags_cmd)
    echohl WarningMsg
    echomsg '[环境检测] Ctags 未安装，tags 相关功能将无法使用'
    echohl None
    
    " 根据操作系统提供不同的安装建议
    if has('win32') || has('win64') || has('win16')
      echohl Question
      echomsg '[安装方法] Windows:'
      echomsg '  1. 使用 Chocolatey: choco install universal-ctags'
      echomsg '  2. 使用 Scoop: scoop install universal-ctags'
      echomsg '  3. 手动下载: https://github.com/universal-ctags/ctags-win32/releases'
      echomsg '  4. 下载后解压，将 ctags.exe 添加到 PATH 环境变量'
      echohl None
    elseif has('macunix')
      echohl Question
      echomsg '[安装方法] macOS:'
      echomsg '  1. 使用 Homebrew: brew install universal-ctags'
      echomsg '  2. 使用 MacPorts: sudo port install universal-ctags'
      echohl None
    else
      echohl Question
      echomsg '[安装方法] Linux:'
      echomsg '  1. Ubuntu/Debian: sudo apt-get install universal-ctags'
      echomsg '  2. Fedora: sudo dnf install ctags'
      echomsg '  3. Arch: sudo pacman -S universal-ctags'
      echohl None
    endif
    return
  endif
  
  " Ctags 已安装，检查版本和功能
  echohl MoreMsg
  echomsg '[环境检测] Ctags 已安装: ' . l:ctags_cmd
  echohl None
  
  " 检查版本信息
  let l:version_output = system(l:ctags_cmd . ' --version 2>&1')
  if !v:shell_error && !empty(l:version_output)
    let l:version_line = split(l:version_output, '\n')[0]
    let l:version_line = substitute(l:version_line, '\r$', '', '')
    echo '版本信息: ' . l:version_line
    
    " 检查是否为 Universal Ctags（推荐）
    if l:version_output =~# 'Universal Ctags'
      echohl MoreMsg
      echomsg '[提示] 检测到 Universal Ctags（推荐版本）'
      echohl None
    elseif l:version_output =~# 'Exuberant Ctags'
      echohl WarningMsg
      echomsg '[提示] 检测到 Exuberant Ctags（旧版本），建议升级到 Universal Ctags'
      echohl None
    endif
    
    " 检查是否支持 JSON 格式（Vista 插件需要）
    let l:features_output = system(l:ctags_cmd . ' --list-features 2>&1')
    if !v:shell_error && l:features_output =~# 'json'
      echohl MoreMsg
      echomsg '[功能] 支持 JSON 格式输出（Vista 插件兼容）'
      echohl None
    else
      echohl WarningMsg
      echomsg '[提示] 不支持 JSON 格式输出，某些功能可能受限'
      echohl None
    endif
  else
    echohl WarningMsg
    echomsg '[警告] 无法获取版本信息，可能安装不完整'
    echohl None
  endif
endfunction

" 自动安装 Ctags（Windows 推荐使用 Chocolatey）
function! s:install_ctags() abort
  " 先检查是否已安装
  let l:ctags_cmd = s:find_ctags_executable()
  if !empty(l:ctags_cmd)
    echohl WarningMsg
    echomsg '[Ctags 安装] Ctags 已安装: ' . l:ctags_cmd
    echomsg '[提示] 如需重新安装，请先卸载现有版本'
    echohl None
    return
  endif
  
  " 根据操作系统选择安装方式
  if has('win32') || has('win64') || has('win16')
    " Windows 系统：优先使用 Chocolatey，其次 Scoop
    if executable('choco')
      echohl Question
      echo '[Ctags 安装] 检测到 Chocolatey，使用 Chocolatey 安装 Universal Ctags...'
      echohl None
      
      " 检查 Windows sudo 是否可用
      let l:sudo_status = s:check_windows_sudo()
      
      " 构建安装命令
      let l:install_cmd = 'choco install universal-ctags -y'
      
      " 如果 sudo 可用且已启用，使用 sudo
      if l:sudo_status.available && l:sudo_status.enabled
        echohl Question
        echo '[Ctags 安装] 检测到 Windows sudo，使用 sudo 执行安装...'
        echohl None
        let l:install_cmd = 'sudo ' . l:install_cmd
      else
        " 先尝试直接执行（如果 Vim 已经以管理员身份运行，会成功）
        echohl Question
        echo '[Ctags 安装] 正在尝试安装...'
        echohl None
      endif
      
      let l:output = system(l:install_cmd)
      let l:exit_code = v:shell_error
      
      " 如果失败，可能是权限不足
      if l:exit_code != 0
        " 检查是否是权限问题
        let l:is_permission_error = l:output =~? 'access denied\|permission\|denied\|需要管理员\|administrator'
        
        " 如果 sudo 可用但未启用，提示启用
        if l:sudo_status.available && !l:sudo_status.enabled
          echohl WarningMsg
          echomsg '[Ctags 安装] 需要管理员权限，检测到 sudo 但未启用'
          echohl None
          echohl Question
          echomsg '[解决方案] 启用 Windows sudo 功能：'
          echomsg ''
          echomsg '方法 1（推荐）：运行 :EnableSudo 命令自动启用'
          echomsg '方法 2：手动启用（见下方说明）'
          echohl None
          
          " 询问是否自动启用
          call inputsave()
          echohl Question
          let l:enable_choice = input('[提示] 是否现在启用 sudo？(y/N): ')
          echohl None
          call inputrestore()
          redraw
          
          if l:enable_choice =~? '^y'
            if s:enable_windows_sudo()
              " 重新尝试安装
              echohl Question
              echo '[Ctags 安装] 重新尝试使用 sudo 安装...'
              echohl None
              let l:install_cmd = 'sudo choco install universal-ctags -y'
              let l:output = system(l:install_cmd)
              let l:exit_code = v:shell_error
              
              if l:exit_code == 0
                " 安装成功，跳转到成功处理
                let l:is_permission_error = 0
              else
                echohl WarningMsg
                echomsg '[提示] sudo 已启用，但安装仍失败，可能需要重新打开终端'
                echohl None
              endif
            endif
          else
            " 显示手动启用指导
            call s:enable_windows_sudo()
          endif
        endif
        
        if l:is_permission_error || l:exit_code == 1
          echohl WarningMsg
          echomsg '[Ctags 安装] 需要管理员权限'
          echohl None
          echohl Question
          echomsg '[解决方案] 请选择以下方法之一：'
          echomsg ''
          echomsg '方法 1（推荐）：手动在管理员 PowerShell 中执行'
          echomsg '  1. 按 Win+X，选择"Windows PowerShell (管理员)"或"终端 (管理员)"'
          echomsg '  2. 在弹出的 UAC 窗口中点击"是"'
          echomsg '  3. 执行以下命令：'
          echohl MoreMsg
          echomsg '     choco install universal-ctags -y'
          echohl Question
          echomsg ''
          echomsg '方法 2：以管理员身份运行 Vim'
          echomsg '  1. 关闭当前 Vim'
          echomsg '  2. 右键点击 Vim 快捷方式，选择"以管理员身份运行"'
          echomsg '  3. 再次执行 :InstallCtags'
          echohl None
          
          " 尝试使用 PowerShell 启动提升权限的进程（可能不会显示 UAC，但提供尝试）
          echohl Question
          echo ''
          echo '[提示] 正在尝试使用 PowerShell 请求管理员权限...'
          echo '[提示] 如果看到 UAC 提示，请点击"是"'
          echohl None
          
          " 使用 PowerShell 的 Start-Process 来触发 UAC
          let l:pwsh_cmd = 'Start-Process -FilePath "choco" -ArgumentList "install","universal-ctags","-y" -Verb RunAs -Wait'
          
          if executable('pwsh')
            let l:elevated_cmd = 'pwsh -NoProfile -Command "' . l:pwsh_cmd . '"'
          elseif executable('powershell')
            let l:elevated_cmd = 'powershell -NoProfile -Command "' . l:pwsh_cmd . '"'
          else
            let l:elevated_cmd = ''
          endif
          
          if !empty(l:elevated_cmd)
            " 尝试执行提升权限的命令
            " 注意：在 Vim 中执行时，UAC 提示可能不会显示，所以主要依赖手动方法
            echohl Question
            echomsg '[提示] 正在尝试请求权限（UAC 提示可能不会显示）...'
            echohl None
            let l:elevated_output = system(l:elevated_cmd)
            let l:elevated_exit = v:shell_error
            
            if l:elevated_exit == 0
              echohl MoreMsg
              echomsg '[Ctags 安装] ✓ 安装成功！'
              echohl None
              sleep 1
              let l:ctags_cmd = s:find_ctags_executable()
              if !empty(l:ctags_cmd)
                let l:version = system(l:ctags_cmd . ' --version 2>&1')
                if !empty(l:version)
                  let l:version_line = split(l:version, '\n')[0]
                  let l:version_line = substitute(l:version_line, '\r$', '', '')
                  echo '版本: ' . l:version_line
                endif
              endif
            else
              echohl WarningMsg
              echomsg '[提示] 自动安装失败，UAC 提示可能未显示'
              echomsg '[提示] 请使用方法 1 手动执行命令（推荐）'
              echohl None
            endif
          endif
          
          return
        else
          " 其他错误
          echohl ErrorMsg
          echomsg '[Ctags 安装] ✗ 安装失败'
          if !empty(l:output)
            echomsg '错误信息: ' . l:output
          endif
          echohl None
          return
        endif
      endif
      
      " 安装成功
      echohl MoreMsg
      echomsg '[Ctags 安装] ✓ 安装成功！'
      echohl None
      
      " 等待一下，让 PATH 环境变量更新
      sleep 1
      
      " 验证安装
      let l:ctags_cmd = s:find_ctags_executable()
      if !empty(l:ctags_cmd)
        let l:version = system(l:ctags_cmd . ' --version 2>&1')
        if !empty(l:version)
          let l:version_line = split(l:version, '\n')[0]
          let l:version_line = substitute(l:version_line, '\r$', '', '')
          echo '版本: ' . l:version_line
        endif
        echohl Question
        echo '[提示] 如果命令仍不可用，请重新打开终端或重启 Vim'
        echohl None
      else
        echohl WarningMsg
        echomsg '[提示] 安装完成，但命令尚未在 PATH 中生效'
        echomsg '[提示] 请重新打开终端或重启 Vim，然后运行 :CheckCtags 验证'
        echohl None
      endif
    elseif executable('scoop')
      echohl Question
      echo '[Ctags 安装] 检测到 Scoop，使用 Scoop 安装 Universal Ctags...'
      echohl None
      
      let l:install_cmd = 'scoop install universal-ctags'
      let l:output = system(l:install_cmd)
      let l:exit_code = v:shell_error
      
      if l:exit_code == 0
        echohl MoreMsg
        echomsg '[Ctags 安装] ✓ 安装成功！'
        echohl None
        
        " 验证安装
        let l:ctags_cmd = s:find_ctags_executable()
        if !empty(l:ctags_cmd)
          let l:version = system(l:ctags_cmd . ' --version 2>&1')
          if !empty(l:version)
            let l:version_line = split(l:version, '\n')[0]
            let l:version_line = substitute(l:version_line, '\r$', '', '')
            echo '版本: ' . l:version_line
          endif
          echohl Question
          echo '[提示] 如果命令仍不可用，请重新打开终端或重启 Vim'
          echohl None
        endif
      else
        echohl ErrorMsg
        echomsg '[Ctags 安装] ✗ 安装失败，请检查错误信息：'
        echomsg l:output
        echohl None
      endif
    else
      " 没有包管理器，提供手动安装指导
      echohl WarningMsg
      echomsg '[Ctags 安装] 未检测到包管理器（Chocolatey 或 Scoop）'
      echohl None
      echohl Question
      echomsg '[推荐安装方式] Windows 推荐使用 Chocolatey：'
      echomsg '  1. 安装 Chocolatey（如果未安装）：'
      echomsg '     以管理员身份运行 PowerShell，执行：'
      echomsg '     Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString(''https://community.chocolatey.org/install.ps1''))'
      echomsg '  2. 安装 Universal Ctags：'
      echomsg '     以管理员身份运行: choco install universal-ctags -y'
      echomsg ''
      echomsg '[备选方案] 使用 Scoop：'
      echomsg '  1. 安装 Scoop（如果未安装）：'
      echomsg '     在 PowerShell 中执行：'
      echomsg '     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser'
      echomsg '     irm get.scoop.sh | iex'
      echomsg '  2. 安装 Universal Ctags：'
      echomsg '     scoop install universal-ctags'
      echomsg ''
      echomsg '[手动安装] 如果不想使用包管理器：'
      echomsg '  1. 访问: https://github.com/universal-ctags/ctags-win32/releases'
      echomsg '  2. 下载最新版本的 ctags-win32.zip'
      echomsg '  3. 解压到任意目录（如 C:\tools\ctags）'
      echomsg '  4. 将 ctags.exe 所在目录添加到 PATH 环境变量'
      echomsg '  5. 重新打开终端或重启 Vim'
      echohl None
    endif
  elseif has('macunix')
    " macOS 系统：使用 Homebrew
    if executable('brew')
      echohl Question
      echo '[Ctags 安装] 使用 Homebrew 安装 Universal Ctags...'
      echohl None
      
      let l:install_cmd = 'brew install universal-ctags'
      let l:output = system(l:install_cmd)
      let l:exit_code = v:shell_error
      
      if l:exit_code == 0
        echohl MoreMsg
        echomsg '[Ctags 安装] ✓ 安装成功！'
        echohl None
        let l:version = system('ctags --version 2>&1')
        if !empty(l:version)
          let l:version_line = split(l:version, '\n')[0]
          echo '版本: ' . l:version_line
        endif
      else
        echohl ErrorMsg
        echomsg '[Ctags 安装] ✗ 安装失败，请检查错误信息：'
        echomsg l:output
        echohl None
      endif
    else
      echohl ErrorMsg
      echomsg '[错误] Homebrew 未安装，无法自动安装 Ctags'
      echomsg '[安装方法] 请先安装 Homebrew: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
      echohl None
    endif
  else
    " Linux 系统：根据发行版选择包管理器
    if executable('apt-get')
      echohl Question
      echo '[Ctags 安装] 使用 apt-get 安装 Universal Ctags（需要 sudo 权限）...'
      echohl None
      echohl WarningMsg
      echomsg '[提示] 请在终端中手动执行: sudo apt-get update && sudo apt-get install -y universal-ctags'
      echohl None
    elseif executable('dnf')
      echohl Question
      echo '[Ctags 安装] 使用 dnf 安装 Ctags（需要 sudo 权限）...'
      echohl None
      echohl WarningMsg
      echomsg '[提示] 请在终端中手动执行: sudo dnf install -y ctags'
      echohl None
    elseif executable('pacman')
      echohl Question
      echo '[Ctags 安装] 使用 pacman 安装 Universal Ctags（需要 sudo 权限）...'
      echohl None
      echohl WarningMsg
      echomsg '[提示] 请在终端中手动执行: sudo pacman -S --noconfirm universal-ctags'
      echohl None
    else
      echohl ErrorMsg
      echomsg '[错误] 未检测到支持的包管理器'
      echomsg '[安装方法] 请根据您的 Linux 发行版手动安装 Universal Ctags'
      echohl None
    endif
  endif
endfunction

" 检测 Windows sudo 是否可用和已启用
function! s:check_windows_sudo() abort
  if !has('win32') && !has('win64') && !has('win16')
    return {'available': 0, 'enabled': 0, 'reason': '非 Windows 系统'}
  endif
  
  " 检查 sudo 命令是否存在
  if !executable('sudo')
    return {'available': 0, 'enabled': 0, 'reason': 'sudo 命令不可用'}
  endif
  
  " 尝试执行 sudo --version 来检测是否启用
  let l:sudo_version = system('sudo --version 2>&1')
  if v:shell_error != 0
    " 如果执行失败，可能是未启用
    if l:sudo_version =~? 'not found\|not recognized\|不是内部或外部命令'
      return {'available': 1, 'enabled': 0, 'reason': 'sudo 未启用'}
    endif
    return {'available': 1, 'enabled': 0, 'reason': 'sudo 可能未启用'}
  endif
  
  " 检查注册表确认是否启用（Windows 11 22H2+）
  let l:reg_check = system('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableSudo 2>&1')
  if l:reg_check =~? 'EnableSudo'
    if l:reg_check =~? '0x1\|REG_DWORD.*0x1'
      return {'available': 1, 'enabled': 1, 'reason': ''}
    else
      return {'available': 1, 'enabled': 0, 'reason': '注册表中 sudo 已禁用'}
    endif
  endif
  
  " 如果注册表检查失败，但 sudo 命令可用，假设已启用
  if !v:shell_error && !empty(l:sudo_version)
    return {'available': 1, 'enabled': 1, 'reason': ''}
  endif
  
  return {'available': 1, 'enabled': 0, 'reason': '无法确定状态'}
endfunction

" 启用 Windows sudo 功能
function! s:enable_windows_sudo() abort
  if !has('win32') && !has('win64') && !has('win16')
    echohl ErrorMsg
    echomsg '[错误] 此功能仅适用于 Windows 系统'
    echohl None
    return 0
  endif
  
  echohl Question
  echomsg '[启用 sudo] 正在尝试启用 Windows sudo 功能...'
  echohl None
  
  " 方法 1：通过注册表启用（需要管理员权限）
  echohl Question
  echomsg '[方法 1] 通过注册表启用（需要管理员权限）...'
  echohl None
  
  let l:reg_cmd = 'reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableSudo /t REG_DWORD /d 1 /f'
  let l:reg_output = system(l:reg_cmd)
  let l:reg_exit = v:shell_error
  
  if l:reg_exit == 0
    echohl MoreMsg
    echomsg '[启用 sudo] ✓ 已通过注册表启用 sudo'
    echohl None
    echohl Question
    echomsg '[提示] 请重新打开终端或重启 Vim 以使更改生效'
    echohl None
    return 1
  endif
  
  " 如果注册表方法失败，提供手动启用指导
  echohl WarningMsg
  echomsg '[启用 sudo] 自动启用失败（需要管理员权限）'
  echohl None
  echohl Question
  echomsg '[手动启用方法] 请选择以下方法之一：'
  echomsg ''
  echomsg '方法 1：通过设置应用启用（推荐）'
  echomsg '  1. 按 Win+I 打开设置'
  echomsg '  2. 进入"系统" > "开发者选项"（或"隐私和安全性" > "开发者选项"）'
  echomsg '  3. 找到"启用 sudo"选项并开启'
  echomsg '  4. 重新打开终端'
  echomsg ''
  echomsg '方法 2：通过注册表启用（需要管理员权限）'
  echomsg '  1. 以管理员身份运行 PowerShell'
  echomsg '  2. 执行以下命令：'
  echohl MoreMsg
  echomsg '     reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableSudo /t REG_DWORD /d 1 /f'
  echohl Question
  echomsg ''
  echomsg '方法 3：使用组策略编辑器（Windows Pro/Enterprise）'
  echomsg '  1. 按 Win+R，输入 gpedit.msc'
  echomsg '  2. 导航到：计算机配置 > 管理模板 > Windows 组件 > Windows 终端'
  echomsg '  3. 找到"启用 sudo"策略并启用'
  echohl None
  
  return 0
endfunction

" 不自动检测，用户需要时手动运行 :CheckCtags

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

"==============================================================
" 4. 综合环境检测命令
"==============================================================

" 综合环境检测（检测所有依赖）
function! s:check_all_environment() abort
  echohl Title
  echomsg '========================================'
  echomsg '  环境依赖检测'
  echomsg '========================================'
  echohl None
  echo ''
  
  " 检测 Node.js
  echohl Question
  echomsg '[1/4] 检测 Node.js...'
  echohl None
  call s:check_nodejs_manual()
  echo ''
  
  " 检测 Git
  echohl Question
  echomsg '[2/4] 检测 Git...'
  echohl None
  call s:check_git_manual()
  echo ''
  
  " 检测 Ctags
  echohl Question
  echomsg '[3/4] 检测 Ctags...'
  echohl None
  call s:check_ctags_manual()
  echo ''
  
  " 检测 ESLint
  echohl Question
  echomsg '[4/4] 检测 ESLint...'
  echohl None
  call s:check_eslint_manual()
  echo ''
  
  echohl Title
  echomsg '========================================'
  echomsg '  环境检测完成'
  echomsg '========================================'
  echohl None
endfunction

" 检查 Windows sudo 状态（用户命令）
function! s:check_sudo_status() abort
  if !has('win32') && !has('win64') && !has('win16')
    echohl WarningMsg
    echomsg '[sudo 检测] 此功能仅适用于 Windows 系统'
    echohl None
    return
  endif
  
  let l:sudo_status = s:check_windows_sudo()
  
  echohl Title
  echomsg '========================================'
  echomsg '  Windows sudo 状态检测'
  echomsg '========================================'
  echohl None
  echo ''
  
  if !l:sudo_status.available
    echohl WarningMsg
    echomsg '[sudo 检测] sudo 命令不可用'
    if !empty(l:sudo_status.reason)
      echomsg '[原因] ' . l:sudo_status.reason
    endif
    echohl None
    echohl Question
    echomsg '[说明] Windows sudo 功能需要 Windows 11 22H2 或更高版本'
    echomsg '[提示] 如果您的系统不支持，请使用其他方法获取管理员权限'
    echohl None
    return
  endif
  
  if l:sudo_status.enabled
    echohl MoreMsg
    echomsg '[sudo 检测] ✓ sudo 已启用'
    echohl None
    
    " 测试 sudo 是否正常工作
    echohl Question
    echo '[测试] 正在测试 sudo 功能...'
    echohl None
    
    let l:test_output = system('sudo echo test 2>&1')
    if v:shell_error == 0 || l:test_output =~? 'test'
      echohl MoreMsg
      echomsg '[测试] ✓ sudo 功能正常'
      echohl None
    else
      echohl WarningMsg
      echomsg '[测试] ⚠ sudo 可能未正常工作'
      echomsg '[提示] 请重新打开终端或重启 Vim'
      echohl None
    endif
  else
    echohl WarningMsg
    echomsg '[sudo 检测] ⚠ sudo 未启用'
    if !empty(l:sudo_status.reason)
      echomsg '[原因] ' . l:sudo_status.reason
    endif
    echohl None
    echohl Question
    echomsg '[解决方案] 运行 :EnableSudo 命令启用 sudo 功能'
    echohl None
  endif
endfunction

" 定义命令
command! InstallESLint call s:install_eslint()
command! UpgradeESLint call s:upgrade_eslint()
command! InstallCtags call s:install_ctags()
command! CheckESLint call s:check_eslint_manual()
command! CheckNodeJS call s:check_nodejs_manual()
command! CheckGit call s:check_git_manual()
command! CheckCtags call s:check_ctags_manual()
command! CheckSudo call s:check_sudo_status()
command! EnableSudo call s:enable_windows_sudo()
command! CheckEnv call s:check_all_environment()

" 不自动检测，用户需要时手动运行 :CheckEnv 或单独检测 :CheckNodeJS :CheckGit :CheckCtags :CheckESLint
