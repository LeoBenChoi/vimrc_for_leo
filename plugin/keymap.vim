" let g:which_key_vertical=1 " 设置为弹出模式

" 弹出方向，似乎不生效
" let g:which_key_position='botright'
" let g:which_key_position='topleft'

" let g:which_key_centered=1 " 1 居中显示 实际只是靠中间了一点 且1是默认值

" let g:which_key_use_floating_win = 0 " 0 切分屏幕 1 弹窗

" 实现类似nvim的右侧弹出，但是无法设置高度
" augroup ForceWhichKeyPosition
"     autocmd!
"     autocmd FileType which_key wincmd L
"     autocmd FileType which_key vertical resize 40
" augroup END

let g:which_key_ignore_outside_mappings = 1 " 隐藏字典以外的值

let g:mapleader = "\<Space>"
let g:maplocalleader = ','

" 注册 leader 键
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

" 注册 Space 激活下方字典
call which_key#register('<Space>', "g:which_key_map")

" 初始化映射字典
let g:which_key_map = {}

" 官方示例，暂留
let g:which_key_map['w'] = {
      \ 'name' : '+windows' ,
      \ 'w' : ['<C-W>w'     , 'other-window']          ,
      \ 'd' : ['<C-W>c'     , 'delete-window']         ,
      \ '-' : ['<C-W>s'     , 'split-window-below']    ,
      \ '|' : ['<C-W>v'     , 'split-window-right']    ,
      \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
      \ 'h' : ['<C-W>h'     , 'window-left']           ,
      \ 'j' : ['<C-W>j'     , 'window-below']          ,
      \ 'l' : ['<C-W>l'     , 'window-right']          ,
      \ 'k' : ['<C-W>k'     , 'window-up']             ,
      \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
      \ 'J' : [':resize +5'  , 'expand-window-below']   ,
      \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
      \ 'K' : [':resize -5'  , 'expand-window-up']      ,
      \ '=' : ['<C-W>='     , 'balance-window']        ,
      \ 's' : ['<C-W>s'     , 'split-window-below']    ,
      \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
      \ '?' : ['Windows'    , 'fzf-window']            ,
      \ }


" <Space>
" <CR>
" <Esc>
" <Tab>
" <BS>
" -
" _
" +
" =
" [
" ]
" {
" }
" ;
" :
" ,
" .
" /
" ?
" \
" |
" !
" @
" #
" $
" %
" ^
" &
" *
" (
" )
" ~
" `
" <
" >

" a
" b
" c
" d
" LSP 诊断、报错位置高亮导航 (Diagnostics)
let g:which_key_map.d = { 'name': ' +[LSP-诊断/报错/Highlight] ' }
nnoremap <silent> <leader>dd <cmd>LspDiag current<CR>
nnoremap <silent> <leader>ds <cmd>LspDiag show<CR>
nnoremap <silent> <leader>dn <cmd>LspDiag nextWrap<CR>
nnoremap <silent> <leader>dp <cmd>LspDiag prevWrap<CR>
nnoremap <silent> <leader>df <cmd>LspDiag first<CR>
nnoremap <silent> <leader>dh <cmd>LspDiag here<CR>

nnoremap <silent> <leader>dhe <cmd>LspDiag highlight enable<CR>
nnoremap <silent> <leader>dhd <cmd>LspDiag highlight disable<CR>
nnoremap <silent> <leader>dlh <cmd>LspHighlight<CR>
nnoremap <silent> <leader>dlc <cmd>LspHighlightClear<CR>

" --- WhichKey 菜单文本 ---
let g:which_key_map.g = { 'name': ' +[LSP-导航/跳转/预览] ' }
let g:which_key_map.d.d = '显示当前行诊断/报错信息'
let g:which_key_map.d.s = '在底栏LocationList列出全部报错'
let g:which_key_map.d.n = '跳到下一个报错(循环回滚)'
let g:which_key_map.d.p = '跳到上一个报错(循环回滚)'
let g:which_key_map.d.f = '直接跳到当前Buffer第一个报错'
let g:which_key_map.d.h = '跳到当前行里的下一个报错'

let g:which_key_map.d.h = { 'name': ' +[编辑器动态高亮控制] ' }
let g:which_key_map.d.h.e = '开启代码诊断错误高亮'
let g:which_key_map.d.h.d = '关闭代码诊断错误高亮'

let g:which_key_map.d.l = { 'name': ' +[当前光标词语高亮] ' }
let g:which_key_map.d.l.h = '高亮当前光标词的所有同名匹配'
let g:which_key_map.d.l.c = '清除高亮同名匹配'

" e
" <Space>e 开关左侧项目文件树 (以 NERDTree 为例)
nnoremap <silent> <leader>e <cmd>NERDTreeToggle<CR>
let g:which_key_map.e = '切换左侧项目文件树(NERDTreeToggle)'

" f

" g 
" LSP 强力跳转与预览 (Goto & Peek)
nnoremap <silent> <leader>gd <cmd>LspGotoDefinition<CR>
nnoremap <silent> <leader>gy <cmd>LspGotoTypeDef<CR>
nnoremap <silent> <leader>gi <cmd>LspGotoImpl<CR>
nnoremap <silent> <leader>gc <cmd>LspGotoDeclaration<CR>
nnoremap <silent> <leader>gh <cmd>LspHover<CR>
nnoremap <silent> <leader>gs <cmd>LspShowSignature<CR>
nnoremap <silent> <leader>go <cmd>LspSwitchSourceHeader<CR>

nnoremap <silent> <leader>gpd <cmd>LspPeekDefinition<CR>
nnoremap <silent> <leader>gpy <cmd>LspPeekTypeDef<CR>
nnoremap <silent> <leader>gpi <cmd>LspPeekImpl<CR>
nnoremap <silent> <leader>gpc <cmd>LspPeekDeclaration<CR>
nnoremap <silent> <leader>gpr <cmd>LspPeekReferences<CR>

" --- WhichKey 菜单文本 ---
let g:which_key_map.g.d = '跳转到定义(Definition)'
let g:which_key_map.g.y = '跳转到类型定义(TypeDef)'
let g:which_key_map.g.i = '跳转到接口实现(Impl)'
let g:which_key_map.g.c = '跳转到声明(Declaration)'
let g:which_key_map.g.h = '悬浮查看文档详情(Hover)'
let g:which_key_map.g.s = '显示函数签名(Signature)'
let g:which_key_map.g.o = '在源文件与头文件间切换'

let g:which_key_map.g.p = { 'name': ' +[预览-不离开当前视窗] ' }
let g:which_key_map.g.p.d = '预览定义'
let g:which_key_map.g.p.y = '预览类型定义'
let g:which_key_map.g.p.i = '预览实现'
let g:which_key_map.g.p.c = '预览声明'
let g:which_key_map.g.p.r = '预览所有引用列表'

" h
" i
" j
" k
" l
" LSP 代码编辑、符号与调用链分析 (Code Action & Calls)
let g:which_key_map.l = { 'name': ' +[LSP-代码编辑/重构] ' }
nnoremap <silent> <leader>la <cmd>LspCodeAction<CR>
nnoremap <silent> <leader>lf <cmd>LspFormat<CR>
vnoremap <silent> <leader>lf <cmd>LspFormat<CR>
nnoremap <silent> <leader>lr <cmd>LspRename<CR>
nnoremap <silent> <leader>lx <cmd>LspFixAll<CR>
nnoremap <silent> <leader>li <cmd>LspOrganizeImports<CR>
nnoremap <silent> <leader>ll <cmd>LspCodeLens<CR>
nnoremap <silent> <leader>lz <cmd>LspFold<CR>

nnoremap <silent> <leader>lss <cmd>LspDocumentSymbol<CR>
nnoremap <silent> <leader>lso <cmd>LspOutline<CR>
nnoremap <silent> <leader>lsq <cmd>LspSymbolSearch<CR>
nnoremap <silent> <leader>lci <cmd>LspIncomingCalls<CR>
nnoremap <silent> <leader>lco <cmd>LspOutgoingCalls<CR>
nnoremap <silent> <leader>lth <cmd>LspSubTypeHierarchy<CR>
nnoremap <silent> <leader>ltH <cmd>LspSuperTypeHierarchy<CR>

" --- WhichKey 菜单文本 ---
let g:which_key_map.l.a = '执行代码修复动作(CodeAction)'
let g:which_key_map.l.f = '格式化当前代码/选中行'
let g:which_key_map.l.i = '自动整理优化Import导入'
let g:which_key_map.l.r = '重命名当前变量(Rename)'
let g:which_key_map.l.x = '一键修复全文件(FixAll)'
let g:which_key_map.l.l = '显示并执行CodeLens命令'
let g:which_key_map.l.z = '基于Lsp对当前文件进行折叠'

let g:which_key_map.l.s = { 'name': ' +[文件符号/大纲] ' }
let g:which_key_map.l.s.s = '弹出式菜单查看当前文件符号'
let g:which_key_map.l.s.o = '侧边栏打开代码大纲(Outline)'
let g:which_key_map.l.s.q = '工作区全局符号搜索'

let g:which_key_map.l.c = { 'name': ' +[调用链分析] ' }
let g:which_key_map.l.c.i = '查看谁调用了此符号(Incoming)'
let g:which_key_map.l.c.o = '查看此符号调用了谁(Outgoing)'

let g:which_key_map.l.t = { 'name': ' +[类型继承树] ' }
let g:which_key_map.l.t.h = '查看子类型层级(Sub Type)'
let g:which_key_map.l.t.H = '查看父类型层级(Super Type)'

" m
" n
" o
" <Space>o 开关右侧 LSP 代码大纲
nnoremap <silent> <leader>o <cmd>LspOutline<CR>
let g:which_key_map.o = '切换右侧代码大纲(LspOutline)'

" p
" q
" r
" s
" LSP 服务端状态、工作区多文件夹管理 (Server & Workspace)
let g:which_key_map.s = { 'name': ' +[LSP-服务器状态/工作区] ' }
nnoremap <silent> <leader>ss <cmd>LspServer<CR>
nnoremap <silent> <leader>sa <cmd>LspShowAllServers<CR>
nnoremap <silent> <leader>sr <cmd>LspShowReferences<CR>

nnoremap <silent> <leader>swa :LspWorkspaceAddFolder<Space>
nnoremap <silent> <leader>swl <cmd>LspWorkspaceListFolders<CR>
nnoremap <silent> <leader>swr :LspWorkspaceRemoveFolder<Space>

" --- WhichKey 菜单文本 ---
let g:which_key_map.s.s = '查看当前LSP服务状态/能力/重启'
let g:which_key_map.s.a = '列出所有已注册激活的LSP服务端'
let g:which_key_map.s.r = '在底层列表中展示当前词的所有引用'

let g:which_key_map.s.w = { 'name': ' +[多项目工作区管理] ' }
let g:which_key_map.s.w.a = '手动添加文件夹到工作区'
let g:which_key_map.s.w.l = '查看当前已信任的工作区文件夹'
let g:which_key_map.s.w.r = '从工作区中移除指定文件夹'

" t
" u
" v
" w
" x
" y
" z

" A
" B
" C
" D
" E
" F
" G
" H
" I
" J
" K
" L
" M
" N
" O
" P
" Q
" r
" S
" T
" U
" V
" W
" X
" Y
" Z
