"==============================================================
" config/plugins/git.vim
" Git 集成配置：vim-fugitive 和 vim-gitgutter
"==============================================================

if exists('g:loaded_git_config')
  finish
endif
let g:loaded_git_config = 1

" 调试：确认文件已加载
if get(g:, 'vim_debug', 0)
  echomsg '[git.vim] 配置文件已加载'
endif

"==============================================================
" 1. vim-fugitive 配置
"==============================================================
" vim-fugitive 提供 Git 命令集成
" 启用遗留命令（:Gstatus, :Gcommit 等），方便使用
let g:fugitive_legacy_commands = 1

" 常用命令：
"   :Git status 或 :Gstatus  - 打开 Git 状态窗口
"   :Git commit 或 :Gcommit  - 提交更改
"   :Git write 或 :Gwrite    - 暂存当前文件
"   :Git diff 或 :Gdiff      - 查看文件差异
"   :Git blame 或 :Gblame    - 查看文件注释历史
"   :Git log 或 :Glog        - 查看提交历史
"   :Git read 或 :Gread      - 检出文件（撤销更改）
"   :Git move 或 :Gmove      - 移动/重命名文件
"   :Git delete 或 :Gdelete - 删除文件

"==============================================================
" 2. vim-gitgutter 配置
"==============================================================
" 在侧边栏显示 Git 变更标记
let g:gitgutter_enabled = 1
let g:gitgutter_map_keys = 0
let g:gitgutter_signs = 1
let g:gitgutter_highlight_lines = 0
let g:gitgutter_highlight_linenrs = 0

" 更新延迟（毫秒）
let g:gitgutter_updatetime = 100

" 符号设置（如果字体不支持，可以改为 ASCII）
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_removed_above_and_below = '='
let g:gitgutter_sign_modified_removed = ':'

" 高亮组自定义（可选）
" highlight GitGutterAdd    guifg=#98c379 ctermfg=114
" highlight GitGutterChange guifg=#61afef ctermfg=75
" highlight GitGutterDelete guifg=#e06c75 ctermfg=168

"==============================================================
" 3. Git 快捷键（vim-fugitive）
"==============================================================
" 注意：所有 Git 相关快捷键已迁移到 mappings/g.vim
" vim-fugitive 的快捷键（gs, gc, gw, gd, gb, gl, gr, gP, gL）
" 需要在插件加载后动态设置，这部分逻辑保留在 git.vim 中
" 但实际映射定义在 mappings/g.vim 中

" 设置 Git 快捷键的函数（供 mappings/g.vim 调用）
function! SetupGitFugitiveMappings() abort
  " 检查插件是否已加载（检查 :Git 或 :Gstatus 命令）
  if exists(':Git') != 2 && exists(':Gstatus') != 2
    if get(g:, 'vim_debug', 0)
      echomsg '[git.vim] vim-fugitive 未加载，跳过快捷键设置'
    endif
    return
  endif

  " 防止重复映射
  if exists('g:git_fugitive_mappings_setup')
    return
  endif
  let g:git_fugitive_mappings_setup = 1

  " Git 状态（打开 Git 状态窗口）
  " 优先使用 :Gstatus（如果存在），否则使用 :Git status
  if exists(':Gstatus') == 2
    nnoremap <silent> <leader>gs :Gstatus<CR>
  else
    nnoremap <silent> <leader>gs :Git status<CR>
  endif

  " Git 提交
  if exists(':Gcommit') == 2
    nnoremap <silent> <leader>gc :Gcommit<CR>
  else
    nnoremap <silent> <leader>gc :Git commit<CR>
  endif

  " Git 暂存当前文件
  if exists(':Gwrite') == 2
    nnoremap <silent> <leader>gw :Gwrite<CR>
  else
    nnoremap <silent> <leader>gw :Git write<CR>
  endif

  " Git 查看差异
  if exists(':Gdiff') == 2
    nnoremap <silent> <leader>gd :Gdiff<CR>
  else
    nnoremap <silent> <leader>gd :Git diff<CR>
  endif

  " Git 查看注释历史
  if exists(':Gblame') == 2
    nnoremap <silent> <leader>gb :Gblame<CR>
  else
    nnoremap <silent> <leader>gb :Git blame<CR>
  endif

  " Git 查看提交历史
  if exists(':Glog') == 2
    nnoremap <silent> <leader>gl :Glog<CR>
  else
    nnoremap <silent> <leader>gl :Git log<CR>
  endif

  " Git 撤销更改（检出文件）
  if exists(':Gread') == 2
    nnoremap <silent> <leader>gr :Gread<CR>
  else
    nnoremap <silent> <leader>gr :Git read<CR>
  endif

  " Git 推送
  nnoremap <silent> <leader>gP :Git push<CR>

  " Git 拉取
  nnoremap <silent> <leader>gL :Git pull<CR>

  if get(g:, 'vim_debug', 0)
    echomsg '[git.vim] Git 快捷键已设置'
  endif
endfunction

" 在 VimEnter 时设置快捷键（确保插件已完全加载）
augroup GitMappings
  autocmd! VimEnter * call SetupGitFugitiveMappings()
  " 延迟设置，确保所有插件都已加载
  if has('timers')
    autocmd! VimEnter * call timer_start(500, {-> SetupGitFugitiveMappings()})
  endif
augroup END

" 如果插件已经加载，立即设置快捷键
if exists(':Git') == 2 || exists(':Gstatus') == 2
  call SetupGitFugitiveMappings()
endif

" 尝试从 runtimepath 加载插件（如果还没加载）
if exists(':Git') != 2 && exists(':Gstatus') != 2
  " 检查插件是否在 runtimepath 中
  let fugitive_dir = expand('~/.vim/plugged/vim-fugitive')
  let rtp_list = split(&runtimepath, ',')
  let in_rtp = 0
  for rtp in rtp_list
    if rtp ==# fugitive_dir || stridx(rtp, fugitive_dir) == 0
      let in_rtp = 1
      break
    endif
  endfor
  
  " 如果在 runtimepath 中但未加载，尝试加载
  if in_rtp && !exists('g:loaded_fugitive')
    try
      runtime! plugin/fugitive.vim
      if exists(':Git') == 2 || exists(':Gstatus') == 2
        call SetupGitFugitiveMappings()
      endif
    catch /.*/
      " 静默失败，等待 VimEnter 时再试
    endtry
  endif
endif

"==============================================================
" 4. vim-gitgutter 快捷键
"==============================================================
" 注意：所有 vim-gitgutter 快捷键已迁移到 mappings/g.vim
" 这里只保留配置说明

"==============================================================
" 5. 诊断和修复命令
"==============================================================
" 检查 Git 配置和插件状态
function! GitConfigStatus() abort
  echomsg '=== Git 配置状态 ==='
  echomsg '配置文件已加载: ' . (exists('g:loaded_git_config') ? '是' : '否')
  echomsg 'vim-fugitive :Git 命令存在: ' . (exists(':Git') == 2 ? '是' : '否')
  echomsg 'vim-fugitive :Gstatus 命令存在: ' . (exists(':Gstatus') == 2 ? '是' : '否')
  echomsg 'vim-gitgutter 已加载: ' . (exists('g:loaded_gitgutter') ? '是' : '否')
  echomsg 'Git 快捷键已设置: ' . (exists('g:git_mappings_setup') ? '是' : '否')
  echomsg 'vim-fugitive 插件路径: ' . (isdirectory(expand('~/.vim/plugged/vim-fugitive')) ? '存在' : '不存在')
  echomsg 'vim-gitgutter 插件路径: ' . (isdirectory(expand('~/.vim/plugged/vim-gitgutter')) ? '存在' : '不存在')
  echomsg '=================='
endfunction
command! GitConfigStatus call GitConfigStatus()

" 手动加载 vim-fugitive 插件
function! LoadFugitive() abort
  " 检查 :Git 或 :Gstatus 命令是否存在
  if exists(':Git') == 2 || exists(':Gstatus') == 2
    echomsg 'vim-fugitive 已加载'
    return
  endif
  
  let fugitive_dir = expand('~/.vim/plugged/vim-fugitive')
  if !isdirectory(fugitive_dir)
    echohl ErrorMsg
    echomsg 'vim-fugitive 插件目录不存在: ' . fugitive_dir
    echohl None
    return
  endif
  
  " 检查 runtimepath
  let rtp_list = split(&runtimepath, ',')
  let in_rtp = 0
  for rtp in rtp_list
    if rtp ==# fugitive_dir || stridx(rtp, fugitive_dir) == 0
      let in_rtp = 1
      break
    endif
  endfor
  
  echomsg 'runtimepath 检查: ' . (in_rtp ? '在 runtimepath 中' : '不在 runtimepath 中')
  
  if !in_rtp
    " 添加到 runtimepath
    let &runtimepath = fugitive_dir . ',' . &runtimepath
    echomsg '已将 vim-fugitive 添加到 runtimepath'
  endif
  
  " 检查是否已经标记为已加载
  if exists('g:loaded_fugitive')
    echomsg '检测到 g:loaded_fugitive 已存在，尝试重置'
    unlet g:loaded_fugitive
  endif
  
  " 加载插件
  let plugin_file = fugitive_dir . '/plugin/fugitive.vim'
  if !filereadable(plugin_file)
    echohl ErrorMsg
    echomsg '插件文件不存在: ' . plugin_file
    echohl None
    return
  endif
  
  try
    echomsg '正在加载: ' . plugin_file
    execute 'source' fnameescape(plugin_file)
    echomsg '文件已 source，检查命令是否存在...'
    
    " 立即检查（检查 :Git 或 :Gstatus）
    if exists(':Git') == 2 || exists(':Gstatus') == 2
      echomsg 'vim-fugitive 已手动加载成功！'
      call s:SetupGitMappings()
    else
      echohl WarningMsg
      echomsg '文件已加载，但 :Git 或 :Gstatus 命令仍不存在'
      echomsg '可能原因: 1) 插件需要 autoload 文件  2) 需要等待初始化  3) fugitive#Command 函数未定义'
      echohl None
      
      " 尝试加载 autoload
      let autoload_file = fugitive_dir . '/autoload/fugitive.vim'
      if filereadable(autoload_file)
        execute 'source' fnameescape(autoload_file)
        echomsg '已加载 autoload 文件'
      endif
      
      " 延迟检查
      if has('timers')
        call timer_start(500, {-> s:CheckAndSetupMappings()})
      else
        call s:CheckAndSetupMappings()
      endif
    endif
  catch /.*/
    echohl ErrorMsg
    echomsg 'vim-fugitive 加载失败: ' . v:exception
    echomsg '错误位置: ' . v:throwpoint
    echohl None
  endtry
endfunction

" 检查并设置快捷键
function! s:CheckAndSetupMappings() abort
  if exists(':Git') == 2 || exists(':Gstatus') == 2
    echomsg 'vim-fugitive 已手动加载成功'
    call s:SetupGitMappings()
  else
    echohl ErrorMsg
    echomsg 'vim-fugitive 加载后命令仍不存在'
    echomsg '请尝试: 1) 运行 :PlugInstall  2) 重启 Vim  3) 检查 :runtimepath'
    echomsg '或者直接使用 :Git 命令（如果存在）'
    echohl None
  endif
endfunction

command! LoadFugitive call LoadFugitive()

" 公开函数：设置 Git 快捷键
function! SetupGitMappings() abort
  call s:SetupGitMappings()
  if exists('g:git_mappings_setup')
    echomsg 'Git 快捷键已设置'
  else
    echomsg 'Git 快捷键设置失败（vim-fugitive 未加载）'
  endif
endfunction
command! SetupGitMappings call SetupGitMappings()
