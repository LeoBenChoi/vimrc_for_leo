"==============================================================
" config/ui/outline.vim
" 代码大纲配置：Vista 插件设置
"==============================================================

if exists('g:loaded_outline_config')
  finish
endif
let g:loaded_outline_config = 1

"==============================================================
" 1. Vista 基础配置
"==============================================================
" 默认使用 coc 作为后端
let g:vista_default_executive = 'coc'

" 设置 vista.vim 在使用 coc 作为执行器时等待的毫秒数
" 建议值：100-300 毫秒，您可以根据实际情况调整
let g:vista_coc_executive_delay = 200

"==============================================================
" 2. Windows 终端特殊字符处理
"==============================================================
" 在 Windows 终端下，完全禁用图标，使用纯文本模式，避免乱码
if has('win32') || has('win64') || has('win16')
  " 完全禁用图标渲染器，使用纯文本类型显示
  let g:vista#renderer#enable_icon = 0
  let g:vista#renderer#enable_kind = 1  " 启用文本类型显示（如 Function, Variable 等）
  
  " 清空所有图标字典，确保不使用任何 Unicode 图标
  let g:vista#renderer#icons = {}
  
  " 使用最简单的 ASCII 字符作为树形结构图标
  " 完全使用空格，避免任何特殊字符
  let g:vista_icon_indent = ['  ', '  ']
  
  " 完全禁用折叠图标，使用纯文本
  let g:vista_fold_toggle_icons = ['', '']
endif