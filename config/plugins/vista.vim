"==============================================================
" config/plugins/vista.vim
" Vista 代码大纲视图配置：使用 coc 作为后端
"==============================================================

if exists('g:loaded_vista_config')
  finish
endif
let g:loaded_vista_config = 1

"==============================================================
" Vista 基础配置
"==============================================================

" 使用 coc 作为后端
let g:vista_default_executive = 'coc'

" 其他可用的后端：
" - 'ctags' - 使用 ctags
" - 'lcn' - 使用 LanguageClient-neovim
" - 'vim_lsp' - 使用 vim-lsp
" - 'nvim_lsp' - 使用 Neovim LSP (仅 Neovim)

"==============================================================
" Vista 显示配置
"==============================================================

" 在侧边栏显示图标（需要支持图标的字体）
let g:vista_icon_indent = ["╰─ ", "├─ "]

" 高亮当前符号
let g:vista_echo_cursor = 1

" 显示函数/类的详细信息
let g:vista_echo_cursor_strategy = 'floating_win'

" 自动更新（当光标移动时）
let g:vista_update_on_text_changed = 1
let g:vista_update_on_text_changed_delay = 1000

" 侧边栏位置：left 或 right
let g:vista_sidebar_position = 'vertical botright'

" 侧边栏宽度
let g:vista_sidebar_width = 40

" 在浮动窗口中显示光标位置的符号信息
let g:vista_floating_delay = 200

" 显示所有符号（包括私有符号）
let g:vista_ignore_kinds = []

" 只显示特定类型的符号（可选）
" let g:vista_kinds = ['function', 'method', 'class', 'struct', 'interface']

"==============================================================
" Vista 过滤配置
"==============================================================

" 忽略某些文件类型
let g:vista_ignore_kinds = []

" 忽略某些符号类型（可选）
" let g:vista_ignore_kinds = ['variable', 'constant']

"==============================================================
" Vista 快捷键映射
"==============================================================

" Vista 快捷键映射
" 注意：所有快捷键已移动到 mappings/ 目录
"   - F3 和 <leader>v* 映射在 mappings/core.vim 和 mappings/v.vim

"==============================================================
" Vista 自动命令
"==============================================================

" 在 Vista 窗口中禁用某些功能
augroup VistaCustom
  autocmd!
  " 在 Vista 窗口中禁用行号
  autocmd FileType vista setlocal nonumber norelativenumber
  " 在 Vista 窗口中设置折叠
  autocmd FileType vista setlocal foldmethod=expr foldexpr=vista#fold#level()
augroup END

"==============================================================
" Vista 与 Coc 集成
"==============================================================

" 确保 Vista 使用 coc 后端时，coc 已加载
function! s:CheckCocForVista() abort
  if !exists('g:did_coc_loaded') || g:did_coc_loaded != 1
    echohl WarningMsg
    echomsg '[Vista] coc.nvim 未加载，Vista 可能无法正常工作'
    echomsg '[Vista] 请确保 coc.nvim 插件已正确安装'
    echohl None
    return 0
  endif
  return 1
endfunction

" 在打开 Vista 时检查 coc
augroup VistaCocCheck
  autocmd!
  autocmd User VistaProjectOpened call s:CheckCocForVista()
augroup END
