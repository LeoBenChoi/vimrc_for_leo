"==============================================================
" config/check/fzf.vim
" FZF 环境检查和安装配置
" 注意：所有检查和安装操作都需要手动触发，不会自动执行
"==============================================================

if exists('g:loaded_check_fzf')
  finish
endif
let g:loaded_check_fzf = 1

"==============================================================
" 平台检测函数
"==============================================================

" 检测是否为 Windows
function! s:IsWindows() abort
  return has('win32') || has('win64') || has('win16')
endfunction

" 检测是否为 Mac
function! s:IsMac() abort
  return has('mac') || has('macunix') || (has('unix') && system('uname') =~? 'darwin')
endfunction

" 检测是否为 Linux
function! s:IsLinux() abort
  return has('unix') && !s:IsMac()
endfunction

"==============================================================
" 辅助函数：安全获取版本信息（处理编码问题）
"==============================================================

" 安全获取命令版本信息（处理 Windows 编码问题）
function! s:SafeGetVersion(cmd) abort
  try
    let l:output = system(a:cmd)
    if v:shell_error != 0
      return ''
    endif
    
    " 清理换行符和回车符
    let l:output = substitute(l:output, '[\r\n]', '', 'g')
    
    " Windows 下处理编码问题
    if s:IsWindows()
      " 方法1：尝试使用 iconv 转换编码（如果可用）
      if exists('*iconv')
        try
          " 尝试从 GBK/GB2312 转换为 UTF-8
          let l:output = iconv(l:output, 'gbk', 'utf-8')
        catch
          " 如果转换失败，尝试其他编码
          try
            let l:output = iconv(l:output, 'gb2312', 'utf-8')
          catch
            " 如果都失败，继续使用原输出
          endtry
        endtry
      endif
      
      " 方法2：尝试提取版本号（优先方法，避免编码问题）
      " 版本号格式通常是：x.y.z 或 x.y 或 x.y.z-xxx
      let l:version_match = matchstr(l:output, '\d\+\.\d\+\(\.\d\+\)\?\(-[a-zA-Z0-9]\+\)\?')
      if !empty(l:version_match)
        return l:version_match
      endif
      
      " 方法3：如果无法提取版本号，尝试过滤不可打印字符
      " 只保留可打印的 ASCII 字符（0x20-0x7E）
      let l:clean_output = ''
      for l:char in split(l:output, '\zs')
        let l:char_code = char2nr(l:char)
        if l:char_code >= 32 && l:char_code <= 126
          let l:clean_output .= l:char
        endif
      endfor
      
      " 如果清理后的输出太短或为空，返回空字符串
      if len(l:clean_output) < 3
        return ''
      endif
      
      " 限制输出长度，避免显示过多信息
      if len(l:clean_output) > 50
        let l:clean_output = l:clean_output[:49]
      endif
      
      return l:clean_output
    else
      " 非 Windows 平台：只取第一行并限制长度
      let l:lines = split(l:output, '\n')
      if !empty(l:lines)
        let l:output = l:lines[0]
        " 限制长度
        if len(l:output) > 50
          let l:output = l:output[:49]
        endif
        return l:output
      endif
    endif
    
    return ''
  catch
    return ''
  endtry
endfunction

"==============================================================
" 辅助函数：检查管理员权限（Windows）
"==============================================================

" 检查当前是否有管理员权限（仅 Windows）
function! s:CheckAdmin() abort
  if !s:IsWindows()
    " 非 Windows 平台默认返回 true（Linux/Mac 使用 sudo）
    return 1
  endif
  
  " Windows 平台：使用 net session 命令检查管理员权限
  " 如果命令成功执行（返回码为 0），说明有管理员权限
  let l:output = system('net session >nul 2>&1')
  return v:shell_error == 0
endfunction

"==============================================================
" 环境检查函数
"==============================================================

" 检查 fzf 是否已安装
function! s:CheckFzf() abort
  " 检查 fzf 可执行文件
  if executable('fzf')
    return 1
  endif
  
  " 检查 fzf.vim 插件是否已加载
  if exists('g:loaded_fzf_config')
    return 1
  endif
  
  " 检查 runtimepath 中是否有 fzf.vim
  let l:fzf_path = globpath(&runtimepath, 'fzf.vim')
  if !empty(l:fzf_path)
    return 1
  endif
  
  return 0
endfunction

" 检查 ripgrep (rg) 是否已安装
function! s:CheckRipgrep() abort
  return executable('rg')
endfunction

" 检查 ag (The Silver Searcher) 是否已安装
function! s:CheckAg() abort
  return executable('ag')
endfunction

"==============================================================
" 安装函数
"==============================================================

" 安装 fzf
function! s:InstallFzf() abort
  if s:IsWindows()
    " Windows 平台：使用 choco、scoop 或 winget
    if executable('choco')
      echomsg '[FZF] 正在使用 Chocolatey 安装 fzf...'
      let l:output = system('choco install fzf -y')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] fzf 安装成功！'
        echohl None
        return 1
      endif
    elseif executable('scoop')
      echomsg '[FZF] 正在使用 Scoop 安装 fzf...'
      let l:output = system('scoop install fzf')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] fzf 安装成功！'
        echohl None
        return 1
      endif
    elseif executable('winget')
      echomsg '[FZF] 正在使用 winget 安装 fzf...'
      let l:output = system('winget install --id junegunn.fzf -e')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] fzf 安装成功！'
        echohl None
        return 1
      endif
    else
      echohl ErrorMsg
      echomsg '[FZF] Windows 平台需要安装包管理器（choco/scoop/winget）'
      echomsg '[FZF] 或者手动下载安装: https://github.com/junegunn/fzf/releases'
      echohl None
      return 0
    endif
  elseif s:IsMac()
    " Mac 平台：使用 Homebrew
    if executable('brew')
      echomsg '[FZF] 正在使用 Homebrew 安装 fzf...'
      let l:output = system('brew install fzf')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] fzf 安装成功！'
        echohl None
        return 1
      else
        echohl ErrorMsg
        echomsg '[FZF] fzf 安装失败: ' . l:output
        echohl None
        return 0
      endif
    else
      echohl ErrorMsg
      echomsg '[FZF] Mac 平台需要安装 Homebrew'
      echomsg '[FZF] 或者手动下载安装: https://github.com/junegunn/fzf/releases'
      echohl None
      return 0
    endif
  elseif s:IsLinux()
    " Linux 平台：根据发行版使用不同的包管理器
    if executable('apt-get')
      echomsg '[FZF] 正在使用 apt-get 安装 fzf...'
      let l:output = system('sudo apt-get update && sudo apt-get install -y fzf')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] fzf 安装成功！'
        echohl None
        return 1
      endif
    elseif executable('yum')
      echomsg '[FZF] 正在使用 yum 安装 fzf...'
      let l:output = system('sudo yum install -y fzf')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] fzf 安装成功！'
        echohl None
        return 1
      endif
    elseif executable('pacman')
      echomsg '[FZF] 正在使用 pacman 安装 fzf...'
      let l:output = system('sudo pacman -S --noconfirm fzf')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] fzf 安装成功！'
        echohl None
        return 1
      endif
    else
      echohl ErrorMsg
      echomsg '[FZF] Linux 平台需要安装包管理器（apt-get/yum/pacman）'
      echomsg '[FZF] 或者手动下载安装: https://github.com/junegunn/fzf/releases'
      echohl None
      return 0
    endif
  endif
  
  return 0
endfunction

" 安装 ripgrep (rg)
function! s:InstallRipgrep() abort
  if s:IsWindows()
    " Windows 平台
    if executable('choco')
      echomsg '[FZF] 正在使用 Chocolatey 安装 ripgrep...'
      let l:output = system('choco install ripgrep -y')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ripgrep 安装成功！'
        echohl None
        return 1
      endif
    elseif executable('scoop')
      echomsg '[FZF] 正在使用 Scoop 安装 ripgrep...'
      let l:output = system('scoop install ripgrep')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ripgrep 安装成功！'
        echohl None
        return 1
      endif
    elseif executable('winget')
      echomsg '[FZF] 正在使用 winget 安装 ripgrep...'
      let l:output = system('winget install --id BurntSushi.ripgrep.MSVC -e')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ripgrep 安装成功！'
        echohl None
        return 1
      endif
    else
      echohl ErrorMsg
      echomsg '[FZF] Windows 平台需要安装包管理器（choco/scoop/winget）'
      echomsg '[FZF] 或者手动下载安装: https://github.com/BurntSushi/ripgrep/releases'
      echohl None
      return 0
    endif
  elseif s:IsMac()
    " Mac 平台
    if executable('brew')
      echomsg '[FZF] 正在使用 Homebrew 安装 ripgrep...'
      let l:output = system('brew install ripgrep')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ripgrep 安装成功！'
        echohl None
        return 1
      else
        echohl ErrorMsg
        echomsg '[FZF] ripgrep 安装失败: ' . l:output
        echohl None
        return 0
      endif
    else
      echohl ErrorMsg
      echomsg '[FZF] Mac 平台需要安装 Homebrew'
      echomsg '[FZF] 或者手动下载安装: https://github.com/BurntSushi/ripgrep/releases'
      echohl None
      return 0
    endif
  elseif s:IsLinux()
    " Linux 平台
    if executable('apt-get')
      echomsg '[FZF] 正在使用 apt-get 安装 ripgrep...'
      let l:output = system('sudo apt-get update && sudo apt-get install -y ripgrep')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ripgrep 安装成功！'
        echohl None
        return 1
      endif
    elseif executable('yum')
      echomsg '[FZF] 正在使用 yum 安装 ripgrep...'
      let l:output = system('sudo yum install -y ripgrep')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ripgrep 安装成功！'
        echohl None
        return 1
      endif
    elseif executable('pacman')
      echomsg '[FZF] 正在使用 pacman 安装 ripgrep...'
      let l:output = system('sudo pacman -S --noconfirm ripgrep')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ripgrep 安装成功！'
        echohl None
        return 1
      endif
    else
      echohl ErrorMsg
      echomsg '[FZF] Linux 平台需要安装包管理器（apt-get/yum/pacman）'
      echomsg '[FZF] 或者手动下载安装: https://github.com/BurntSushi/ripgrep/releases'
      echohl None
      return 0
    endif
  endif
  
  return 0
endfunction

" 安装 ag (The Silver Searcher)
function! s:InstallAg() abort
  if s:IsWindows()
    " Windows 平台
    if executable('choco')
      echomsg '[FZF] 正在使用 Chocolatey 安装 ag...'
      let l:output = system('choco install ag -y')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ag 安装成功！'
        echohl None
        return 1
      endif
    elseif executable('scoop')
      echomsg '[FZF] 正在使用 Scoop 安装 ag...'
      let l:output = system('scoop install ag')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ag 安装成功！'
        echohl None
        return 1
      endif
    else
      echohl ErrorMsg
      echomsg '[FZF] Windows 平台需要安装包管理器（choco/scoop）'
      echomsg '[FZF] 或者手动下载安装: https://github.com/ggreer/the_silver_searcher/releases'
      echohl None
      return 0
    endif
  elseif s:IsMac()
    " Mac 平台
    if executable('brew')
      echomsg '[FZF] 正在使用 Homebrew 安装 ag...'
      let l:output = system('brew install ag')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ag 安装成功！'
        echohl None
        return 1
      else
        echohl ErrorMsg
        echomsg '[FZF] ag 安装失败: ' . l:output
        echohl None
        return 0
      endif
    else
      echohl ErrorMsg
      echomsg '[FZF] Mac 平台需要安装 Homebrew'
      echomsg '[FZF] 或者手动下载安装: https://github.com/ggreer/the_silver_searcher/releases'
      echohl None
      return 0
    endif
  elseif s:IsLinux()
    " Linux 平台
    if executable('apt-get')
      echomsg '[FZF] 正在使用 apt-get 安装 ag...'
      let l:output = system('sudo apt-get update && sudo apt-get install -y silversearcher-ag')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ag 安装成功！'
        echohl None
        return 1
      endif
    elseif executable('yum')
      echomsg '[FZF] 正在使用 yum 安装 ag...'
      let l:output = system('sudo yum install -y the_silver_searcher')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ag 安装成功！'
        echohl None
        return 1
      endif
    elseif executable('pacman')
      echomsg '[FZF] 正在使用 pacman 安装 ag...'
      let l:output = system('sudo pacman -S --noconfirm the_silver_searcher')
      if v:shell_error == 0
        echohl SuccessMsg
        echomsg '[FZF] ag 安装成功！'
        echohl None
        return 1
      endif
    else
      echohl ErrorMsg
      echomsg '[FZF] Linux 平台需要安装包管理器（apt-get/yum/pacman）'
      echomsg '[FZF] 或者手动下载安装: https://github.com/ggreer/the_silver_searcher/releases'
      echohl None
      return 0
    endif
  endif
  
  return 0
endfunction

"==============================================================
" 检查命令（Check 开头）
"==============================================================

" 检查 fzf
function! CheckFzf() abort
  echo '========================================'
  echo 'FZF 检查'
  echo '========================================'
  
  if s:CheckFzf()
    echohl SuccessMsg
    echo '[✓] fzf 已安装'
    echohl None
    
    " 显示 fzf 版本（使用安全函数处理编码）
    let l:version = s:SafeGetVersion('fzf --version')
    if !empty(l:version)
      echo '    版本: ' . l:version
    endif
    
    " 检查 fzf.vim 插件
    if exists('g:loaded_fzf_config')
      echo '    fzf.vim 插件: 已加载'
    else
      let l:fzf_path = globpath(&runtimepath, 'fzf.vim')
      if !empty(l:fzf_path)
        echo '    fzf.vim 插件: 已安装（未加载）'
      else
        echo '    fzf.vim 插件: 未安装'
      endif
    endif
    
    return 1
  else
    echohl WarningMsg
    echo '[✗] fzf 未安装'
    echohl None
    echo '    安装命令: :InstallFzf'
    echo '    或手动安装: https://github.com/junegunn/fzf#installation'
    return 0
  endif
endfunction

" 检查 ripgrep
function! CheckRipgrep() abort
  echo '========================================'
  echo 'Ripgrep (rg) 检查'
  echo '========================================'
  
  if s:CheckRipgrep()
    echohl SuccessMsg
    echo '[✓] ripgrep 已安装'
    echohl None
    
    " 显示 ripgrep 版本（使用安全函数处理编码）
    let l:version = s:SafeGetVersion('rg --version')
    if !empty(l:version)
      echo '    版本: ' . l:version
    endif
    
    return 1
  else
    echohl WarningMsg
    echo '[✗] ripgrep 未安装'
    echohl None
    echo '    安装命令: :InstallRipgrep'
    echo '    或手动安装: https://github.com/BurntSushi/ripgrep#installation'
    return 0
  endif
endfunction

" 检查 ag
function! CheckAg() abort
  echo '========================================'
  echo 'Ag (The Silver Searcher) 检查'
  echo '========================================'
  
  if s:CheckAg()
    echohl SuccessMsg
    echo '[✓] ag 已安装'
    echohl None
    
    " 显示 ag 版本（使用安全函数处理编码）
    let l:version = s:SafeGetVersion('ag --version')
    if !empty(l:version)
      echo '    版本: ' . l:version
    endif
    
    return 1
  else
    echohl WarningMsg
    echo '[✗] ag 未安装'
    echohl None
    echo '    安装命令: :InstallAg'
    echo '    或手动安装: https://github.com/ggreer/the_silver_searcher#installation'
    return 0
  endif
endfunction

" 检查完整的 FZF 环境
function! CheckFzfEnv() abort
  echo ''
  echo '========================================'
  echo 'FZF 环境完整检查'
  echo '========================================'
  echo ''
  
  let l:all_ok = 1
  
  " 检查 fzf
  if !CheckFzf()
    let l:all_ok = 0
  endif
  echo ''
  
  " 检查 ripgrep 或 ag（至少需要一个）
  let l:has_search_tool = 0
  if CheckRipgrep()
    let l:has_search_tool = 1
  endif
  echo ''
  
  if !l:has_search_tool
    if !CheckAg()
      let l:all_ok = 0
    else
      let l:has_search_tool = 1
    endif
  endif
  echo ''
  
  echo '========================================'
  if l:all_ok && l:has_search_tool
    echohl SuccessMsg
    echo '所有组件检查通过！'
    echohl None
  else
    echohl WarningMsg
    echo '部分组件缺失，请使用 Install 命令安装'
    echohl None
  endif
  echo '========================================'
  echo ''
  echo '提示：FZF 需要 ripgrep 或 ag 作为搜索工具'
  echo '     推荐使用 ripgrep（性能更好）'
  echo ''
endfunction

"==============================================================
" 安装命令（Install 开头）
"==============================================================

" 安装 fzf
function! InstallFzf() abort
  if s:CheckFzf()
    echohl WarningMsg
    echomsg '[FZF] fzf 已安装，无需重复安装'
    echohl None
    return
  endif
  
  call s:InstallFzf()
endfunction

" 安装 ripgrep
function! InstallRipgrep() abort
  if s:CheckRipgrep()
    echohl WarningMsg
    echomsg '[FZF] ripgrep 已安装，无需重复安装'
    echohl None
    return
  endif
  
  call s:InstallRipgrep()
endfunction

" 安装 ag
function! InstallAg() abort
  if s:CheckAg()
    echohl WarningMsg
    echomsg '[FZF] ag 已安装，无需重复安装'
    echohl None
    return
  endif
  
  call s:InstallAg()
endfunction

" 安装完整的 FZF 环境
function! InstallFzfEnv() abort
  " Windows 平台：检查管理员权限
  if s:IsWindows() && !s:CheckAdmin()
    echohl ErrorMsg
    echo ''
    echo '========================================'
    echo '权限检查失败'
    echo '========================================'
    echo ''
    echo '[✗] 当前 Vim 没有管理员权限'
    echo ''
    echo 'FZF 环境安装需要管理员权限，请按以下步骤操作：'
    echo ''
    echo '1. 关闭当前 Vim'
    echo '2. 右键点击 Vim 快捷方式或可执行文件'
    echo '3. 选择"以管理员身份运行"'
    echo '4. 重新运行 :InstallFzfEnv 命令'
    echo ''
    echo '或者手动在管理员权限的终端中运行安装命令：'
    if executable('choco')
      echo '   choco install fzf -y'
      echo '   choco install ripgrep -y'
    elseif executable('winget')
      echo '   winget install --id junegunn.fzf -e'
      echo '   winget install --id BurntSushi.ripgrep.MSVC -e'
    endif
    echo ''
    echo '========================================'
    echohl None
    return
  endif
  
  echo ''
  echo '========================================'
  echo 'FZF 环境自动安装'
  echo '========================================'
  echo ''
  
  " 检查并安装 fzf
  if !s:CheckFzf()
    echo '正在安装 fzf...'
    call s:InstallFzf()
    echo ''
  else
    echo '[✓] fzf 已安装，跳过'
    echo ''
  endif
  
  " 检查并安装 ripgrep（优先）
  if !s:CheckRipgrep()
    echo '正在安装 ripgrep（推荐）...'
    call s:InstallRipgrep()
    echo ''
  else
    echo '[✓] ripgrep 已安装，跳过'
    echo ''
  endif
  
  " 如果 ripgrep 未安装成功，尝试安装 ag
  if !s:CheckRipgrep() && !s:CheckAg()
    echo 'ripgrep 安装失败，尝试安装 ag...'
    call s:InstallAg()
    echo ''
  elseif s:CheckAg()
    echo '[✓] ag 已安装（备用）'
    echo ''
  endif
  
  echo '========================================'
  echo '安装完成！'
  echo '========================================'
  echo ''
  echo '建议运行 :CheckFzfEnv 验证安装结果'
  echo ''
endfunction

"==============================================================
" 定义命令
"==============================================================
" 检查命令（Check 开头）
command! -nargs=0 CheckFzf call CheckFzf()
command! -nargs=0 CheckRipgrep call CheckRipgrep()
command! -nargs=0 CheckAg call CheckAg()
command! -nargs=0 CheckFzfEnv call CheckFzfEnv()

" 安装命令（Install 开头）
command! -nargs=0 InstallFzf call InstallFzf()
command! -nargs=0 InstallRipgrep call InstallRipgrep()
command! -nargs=0 InstallAg call InstallAg()
command! -nargs=0 InstallFzfEnv call InstallFzfEnv()
