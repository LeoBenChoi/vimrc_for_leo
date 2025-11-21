"==============================================================
" config/mappings/core.vim
" 核心快捷键与索引（可继续拆分为子模块）
"==============================================================

if exists('g:loaded_core_mappings')
  finish
endif
let g:loaded_core_mappings = 1

"==============================================================
" 0. Leader 约定
"==============================================================
" 默认 Leader 为反斜杠，如果需要兼容其他机器可在 local.vim 中覆盖
" 按最佳实践：Space 作为高频工作流触发键；\ 作为保底兼容键。
" 这里只设置 Space，方便后续统一管理。
"==============================================================
"let mapleader = "\\"     " 备用：沿用 Vim 默认 Leader
let mapleader = "\<Space>" " 推荐：Space 便于连击

"==============================================================
" 1. 快捷键索引（a-z / A-Z）
"==============================================================
"   a / A : 追加到行尾的原生动作，暂不覆盖，保留编辑肌肉记忆
"   b / B : Buffer 管理（本文件实现 <leader>fb）
"   c / C : Comment / Code Action（预留）
"   d / D : 调试/诊断（预留）
"   e / E : Explorer/编辑器增强（预留）
"   f / F : FZF 模糊搜索（本文件实现一组高频命令）
"   g / G : Git / 跳转（预留，避免与原生 g 前缀冲突）
"   h / H : 帮助/窗口切换（预留）
"   i / I : Insert 模式相关（预留）
"   j / J : Cursor/Jump（预留）
"   k / K : 文档/帮助（原生 K，暂不改）
"   l / L : Location/Quickfix（预留）
"   m / M : Mark/Session（预留）
"   n / N : 搜索下一项（沿用原生 n/N）
"   o / O : Outline/折叠（预留）
"   p / P : Paste/寄存器（保留）
"   q / Q : Quit/宏（保留 Vim 原生行为）
"   r / R : Rename/Replace（预留给 LSP）
"   s / S : Session/保存（预留）
"   t / T : Theme/Terminal（主题切换已实现）
"   u / U : Undo/Redo（保留）
"   v / V : Visual/多光标（预留）
"   w / W : Window/写入（预留）
"   x / X : 关闭/剪切（保留）
"   y / Y : Yank（保留）
"   z / Z : 折叠/临时视图（保留）
"
"==============================================================
" z / Z - Fold 工具速查（保持原生行为）
"==============================================================
"   zc / zo  : 关闭 / 打开当前折叠
"   zC / zO  : 递归关闭 / 打开（包含所有嵌套）
"   za / zA  : 切换当前折叠 / 递归切换
"   zm / zr  : 调整折叠级别（折叠更多 / 更少）
"   zM / zR  : 关闭全部折叠 / 展开全部折叠
"   [z / ]z  : 跳到上一个 / 下一个折叠起点
"   zj / zk  : 在折叠块间快速跳转
"   zf{motion}: 按 motion 创建折叠（如 zfap, zf%）
"   zd / zD  : 删除当前折叠 / 递归删除
"   zi       : 启用或禁用折叠功能
"
"==============================================================
" 2. 功能键索引（F1 - F12）
"==============================================================
"   F1  : 帮助（遵循默认行为）
"   F2  : 预留
"   F3  : 预留
"   F4  : 预留
"   F5  : 预留
"   F6  : 预留
"   F7  : 预留
"   F8  : 预留
"   F9  : 预留
"   F10 : 预留
"   F11 : 预留
"   F12 : 预留
"==============================================================

"==============================================================
" b / B - Buffer 管理
"==============================================================
" 规范：小写 b 负责常规 buffer 浏览，保留大写 B 供批量操作使用
nnoremap <leader>fb :Buffers<CR> " 列出所有 buffer，支持模糊选择

"==============================================================
" f / F - FZF 模糊搜索套件
"==============================================================
" 规范：所有 FZF 相关快捷键统一归档在 f 段，保持肌肉记忆一致
nnoremap <leader>ff :Files<CR>   " f -> Files：当前工作区文件模糊搜索
nnoremap <leader>fg :GFiles<CR>  " g -> GitFiles：仅匹配 Git 跟踪文件
nnoremap <leader>fr :Rg<CR>      " r -> Ripgrep：内容级搜索（rg 必需）

"==============================================================
" e / E - Explorer / 侧边栏
"==============================================================
" 规范：小写 e 用于文件浏览器，预留大写 E 给其他编辑器增强功能

" NERDTree 快捷键
" 使用函数包装，避免语法错误
function! s:NERDTreeToggle()
  if exists(':NERDTreeToggle')
    NERDTreeToggle
  else
    echomsg 'NERDTree 未安装，请运行 :PlugInstall'
  endif
endfunction

function! s:NERDTreeFind()
  if exists(':NERDTreeFind')
    NERDTreeFind
  else
    echomsg 'NERDTree 未安装'
  endif
endfunction

function! s:NERDTreeRefreshRoot()
  if exists(':NERDTreeRefreshRoot')
    NERDTreeRefreshRoot
  else
    echomsg 'NERDTree 未安装'
  endif
endfunction

nnoremap <silent> <leader>ee :call <SID>NERDTreeToggle()<CR>
nnoremap <silent> <leader>ef :call <SID>NERDTreeFind()<CR>
nnoremap <silent> <leader>er :call <SID>NERDTreeRefreshRoot()<CR>

"==============================================================
" o / O - Outline / 代码大纲
"==============================================================
" 规范：小写 o 用于代码大纲，预留大写 O 给其他大纲相关功能

" Vista 代码大纲快捷键（切换打开/关闭）
" 使用函数包装，避免语法错误
function! s:VistaToggle()
  if exists(':Vista')
    Vista!!
  else
    echomsg 'Vista 未安装，请运行 :PlugInstall'
  endif
endfunction

nnoremap <silent> <leader>oo :call <SID>VistaToggle()<CR>

"==============================================================
" t / T - Theme / Terminal 相关
"==============================================================
" 规范：小写 t 用于视觉样式切换，预留大写 T 给终端/任务面板
if exists('*ToggleThemeMode')
  nnoremap <leader>tt :call ToggleThemeMode()<CR> " t -> theme toggle
endif
