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
