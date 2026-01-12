"==============================================================
" config/check/go_lsp.vim
" Go LSP 环境检查和安装配置
" 注意：所有检查和安装操作都需要手动触发，不会自动执行
"==============================================================

if exists('g:loaded_check_go_lsp')
  finish
endif
let g:loaded_check_go_lsp = 1

"==============================================================
" 辅助函数：检查 Coc 插件是否已加载
"==============================================================
function! s:CocLoaded() abort
  " 方法1: 检查 coc.nvim 的加载标志
  if exists('g:did_coc_loaded') && g:did_coc_loaded == 1
    return 1
  endif
  
  " 方法2: 检查 runtimepath 中是否有 coc.nvim
  let l:coc_path = globpath(&runtimepath, 'coc.nvim')
  if !empty(l:coc_path)
    return 1
  endif
  
  " 方法3: 检查 coc.nvim 的关键函数是否存在
  if exists('*coc#refresh') || exists('*coc#rpc#ready')
    return 1
  endif
  
  " 方法4: 检查是否有 CocAction 函数
  if exists('*CocAction')
    return 1
  endif
  
  return 0
endfunction

"==============================================================
" 环境检查函数
"==============================================================

" 检查 Go 是否已安装
function! s:CheckGo() abort
  if executable('go')
    return 1
  endif
  return 0
endfunction

" 检查 gopls 是否已安装（包括 PATH 和 Go bin 目录）
function! s:CheckGopls() abort
  " 检查 gopls 是否在 PATH 中
  if executable('gopls')
    return 1
  endif
  
  " 检查 Go bin 目录（Windows 下可能不在 PATH 中）
  if s:CheckGo()
    try
      " 获取 Go 环境变量
      let l:go_path = system('go env GOPATH')
      let l:go_bin = system('go env GOBIN')
      
      " 清理输出（去除换行符和空格）
      let l:go_path = substitute(l:go_path, '[\r\n]', '', 'g')
      let l:go_path = substitute(l:go_path, '^\s*\(.\{-}\)\s*$', '\1', 'g')
      let l:go_bin = substitute(l:go_bin, '[\r\n]', '', 'g')
      let l:go_bin = substitute(l:go_bin, '^\s*\(.\{-}\)\s*$', '\1', 'g')
      
      " 检查 GOBIN 目录
      if !empty(l:go_bin)
        let l:gopls_path = l:go_bin . (has('win32') || has('win64') ? '\gopls.exe' : '/gopls')
        if filereadable(l:gopls_path) || executable(l:gopls_path)
          return 1
        endif
      endif
      
      " 检查 GOPATH/bin 目录
      if !empty(l:go_path)
        let l:bin_path = l:go_path . (has('win32') || has('win64') ? '\bin\gopls.exe' : '/bin/gopls')
        if filereadable(l:bin_path) || executable(l:bin_path)
          return 1
        endif
      endif
      
      " Windows 下检查用户目录
      if has('win32') || has('win64')
        let l:user_profile = $USERPROFILE
        if !empty(l:user_profile)
          let l:win_bin = l:user_profile . '\go\bin\gopls.exe'
          if filereadable(l:win_bin)
            return 1
          endif
        endif
      endif
    catch
      " 如果获取环境变量失败，忽略错误
    endtry
  endif
  
  return 0
endfunction

" 检查 coc-go 扩展是否已安装
function! s:CheckCocGo() abort
  if !s:CocLoaded()
    return 0
  endif
  
  " 检查 coc-go 扩展是否存在
  let l:coc_go_path = globpath(&runtimepath, 'coc-go')
  if !empty(l:coc_go_path)
    return 1
  endif
  
  " 检查是否在扩展列表中
  if exists('g:coc_global_extensions')
    for ext in g:coc_global_extensions
      if ext ==# 'coc-go'
        return 1
      endif
    endfor
  endif
  
  return 0
endfunction

"==============================================================
" 安装函数
"==============================================================

" 安装 gopls
function! s:InstallGopls() abort
  if !s:CheckGo()
    echohl ErrorMsg
    echomsg '[Go LSP] Go 未安装，无法安装 gopls'
    echomsg '[Go LSP] 请先手动安装 Go: https://golang.org/dl/'
    echohl None
    return 0
  endif

  echomsg '[Go LSP] 正在安装 gopls...'
  echomsg '[Go LSP] 这可能需要一些时间，请稍候...'
  
  " 执行安装命令
  let l:cmd = 'go install golang.org/x/tools/gopls@latest'
  
  " 执行安装
  let l:output = system(l:cmd)

  if v:shell_error == 0
    echohl SuccessMsg
    echomsg '[Go LSP] gopls 安装成功！'
    echohl None
    
    " 获取 Go bin 目录位置
    try
      let l:go_path = system('go env GOPATH')
      let l:go_path = substitute(l:go_path, '[\r\n]', '', 'g')
      let l:go_path = substitute(l:go_path, '^\s*\(.\{-}\)\s*$', '\1', 'g')
      if !empty(l:go_path)
        let l:bin_dir = l:go_path . (has('win32') || has('win64') ? '\bin' : '/bin')
        echomsg '[Go LSP] Go bin 目录位置: ' . l:bin_dir
        echomsg '[Go LSP] 如果 gopls 不在 PATH 中，请确保此目录已添加到 PATH'
      endif
    catch
    endtry
    
    " 等待一下让系统更新
    sleep 1
    " 再次检查是否可用
    if s:CheckGopls()
      echohl SuccessMsg
      echomsg '[Go LSP] gopls 已可用！'
      echohl None
    else
      echohl WarningMsg
      echomsg '[Go LSP] gopls 已安装，但可能不在 PATH 中'
      echomsg '[Go LSP] 请将 Go bin 目录添加到 PATH，或重启 Vim'
      echohl None
    endif
    return 1
  else
    echohl ErrorMsg
    echomsg '[Go LSP] gopls 安装失败: ' . l:output
    echomsg '[Go LSP] 请手动运行: go install golang.org/x/tools/gopls@latest'
    echohl None
    return 0
  endif
endfunction

" 安装 coc-go 扩展
function! s:InstallCocGo() abort
  if !s:CocLoaded()
    echohl WarningMsg
    echomsg '[Go LSP] coc.nvim 未加载，无法安装 coc-go 扩展'
    echomsg '[Go LSP] 请确保 coc.nvim 插件已正确安装'
    echohl None
    return 0
  endif

  echomsg '[Go LSP] 正在安装 coc-go 扩展...'
  
  try
    execute 'CocInstall coc-go'
    echohl SuccessMsg
    echomsg '[Go LSP] coc-go 扩展安装成功！'
    echohl None
    return 1
  catch
    echohl ErrorMsg
    echomsg '[Go LSP] coc-go 扩展安装失败: ' . v:exception
    echomsg '[Go LSP] 请手动运行: :CocInstall coc-go'
    echohl None
    return 0
  endtry
endfunction

"==============================================================
" 检查命令（Check 开头）
"==============================================================

" 检查 Go 环境
function! CheckGo() abort
  echo '========================================'
  echo 'Go 环境检查'
  echo '========================================'
  
  if s:CheckGo()
    echohl SuccessMsg
    echo '[✓] Go 已安装'
    echohl None
    
    " 显示 Go 版本信息
    try
      let l:version = system('go version')
      let l:version = substitute(l:version, '[\r\n]', '', 'g')
      echo '    版本: ' . l:version
    catch
    endtry
    
    " 显示 Go 环境变量
    try
      let l:go_path = system('go env GOPATH')
      let l:go_bin = system('go env GOBIN')
      let l:go_path = substitute(l:go_path, '[\r\n]', '', 'g')
      let l:go_bin = substitute(l:go_bin, '[\r\n]', '', 'g')
      if !empty(l:go_path)
        echo '    GOPATH: ' . l:go_path
      endif
      if !empty(l:go_bin)
        echo '    GOBIN: ' . l:go_bin
      endif
    catch
    endtry
    
    return 1
  else
    echohl ErrorMsg
    echo '[✗] Go 未安装'
    echohl None
    echo '    请手动安装 Go: https://golang.org/dl/'
    return 0
  endif
endfunction

" 检查 gopls
function! CheckGopls() abort
  echo '========================================'
  echo 'gopls 检查'
  echo '========================================'
  
  if s:CheckGopls()
    echohl SuccessMsg
    echo '[✓] gopls 已安装'
    echohl None
    
    " 显示 gopls 版本
    try
      let l:version = system('gopls version')
      let l:version = substitute(l:version, '[\r\n]', '', 'g')
      echo '    版本: ' . l:version
    catch
    endtry
    
    return 1
  else
    echohl WarningMsg
    echo '[✗] gopls 未安装'
    echohl None
    echo '    安装命令: :InstallGopls'
    echo '    或手动运行: go install golang.org/x/tools/gopls@latest'
    return 0
  endif
endfunction

" 检查 coc-go 扩展
function! CheckCocGo() abort
  echo '========================================'
  echo 'coc-go 扩展检查'
  echo '========================================'
  
  " 详细检查 coc.nvim 加载状态
  let l:coc_loaded = s:CocLoaded()
  let l:diagnostics = []
  
  " 检查各种加载标志
  if exists('g:did_coc_loaded')
    call add(l:diagnostics, 'g:did_coc_loaded = ' . g:did_coc_loaded)
  else
    call add(l:diagnostics, 'g:did_coc_loaded 不存在')
  endif
  
  let l:coc_path = globpath(&runtimepath, 'coc.nvim')
  if !empty(l:coc_path)
    call add(l:diagnostics, 'coc.nvim 路径: ' . l:coc_path)
  else
    call add(l:diagnostics, 'coc.nvim 不在 runtimepath 中')
  endif
  
  if exists('*coc#refresh')
    call add(l:diagnostics, 'coc#refresh 函数存在')
  else
    call add(l:diagnostics, 'coc#refresh 函数不存在')
  endif
  
  if exists('*CocAction')
    call add(l:diagnostics, 'CocAction 函数存在')
  else
    call add(l:diagnostics, 'CocAction 函数不存在')
  endif
  
  if !l:coc_loaded
    echohl WarningMsg
    echo '[✗] coc.nvim 未加载'
    echohl None
    echo '    诊断信息:'
    for diag in l:diagnostics
      echo '    - ' . diag
    endfor
    echo ''
    echo '    可能的原因:'
    echo '    1. coc.nvim 插件未安装（运行 :PlugInstall）'
    echo '    2. coc.nvim 插件未正确加载'
    echo '    3. 需要重启 Vim 使插件生效'
    return 0
  endif
  
  " coc.nvim 已加载，检查 coc-go 扩展
  if s:CheckCocGo()
    echohl SuccessMsg
    echo '[✓] coc-go 扩展已安装'
    echohl None
    return 1
  else
    echohl WarningMsg
    echo '[✗] coc-go 扩展未安装'
    echohl None
    echo '    安装命令: :InstallCocGo'
    echo '    或手动运行: :CocInstall coc-go'
    return 0
  endif
endfunction

" 检查完整的 Go LSP 环境
function! CheckGoLSP() abort
  echo ''
  echo '========================================'
  echo 'Go LSP 环境完整检查'
  echo '========================================'
  echo ''
  
  let l:all_ok = 1
  
  " 检查 Go
  if !CheckGo()
    let l:all_ok = 0
  endif
  echo ''
  
  " 检查 gopls
  if !CheckGopls()
    let l:all_ok = 0
  endif
  echo ''
  
  " 检查 coc-go
  if !CheckCocGo()
    let l:all_ok = 0
  endif
  echo ''
  
  echo '========================================'
  if l:all_ok
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
endfunction

"==============================================================
" 安装命令（Install 开头）
"==============================================================

" 安装 gopls
function! InstallGopls() abort
  if s:CheckGopls()
    echohl WarningMsg
    echomsg '[Go LSP] gopls 已安装，无需重复安装'
    echohl None
    return
  endif
  
  call s:InstallGopls()
endfunction

" 安装 coc-go 扩展
function! InstallCocGo() abort
  if s:CheckCocGo()
    echohl WarningMsg
    echomsg '[Go LSP] coc-go 扩展已安装，无需重复安装'
    echohl None
    return
  endif
  
  call s:InstallCocGo()
endfunction

" 安装完整的 Go LSP 环境
function! InstallGoLSP() abort
  echo ''
  echo '========================================'
  echo 'Go LSP 环境自动安装'
  echo '========================================'
  echo ''
  
  " 检查并安装 coc-go
  if !s:CheckCocGo()
    echo '正在安装 coc-go 扩展...'
    call s:InstallCocGo()
    echo ''
  else
    echo '[✓] coc-go 扩展已安装，跳过'
    echo ''
  endif
  
  " 检查并安装 gopls
  if !s:CheckGopls()
    echo '正在安装 gopls...'
    call s:InstallGopls()
    echo ''
  else
    echo '[✓] gopls 已安装，跳过'
    echo ''
  endif
  
  echo '========================================'
  echo '安装完成！'
  echo '========================================'
  echo ''
  echo '建议运行 :CheckGoLSP 验证安装结果'
  echo ''
endfunction

"==============================================================
" 定义命令
"==============================================================
" 检查命令（Check 开头）
command! -nargs=0 CheckGo call CheckGo()
command! -nargs=0 CheckGopls call CheckGopls()
command! -nargs=0 CheckCocGo call CheckCocGo()
command! -nargs=0 CheckGoLSP call CheckGoLSP()

" 安装命令（Install 开头）
command! -nargs=0 InstallGopls call InstallGopls()
command! -nargs=0 InstallCocGo call InstallCocGo()
command! -nargs=0 InstallGoLSP call InstallGoLSP()
