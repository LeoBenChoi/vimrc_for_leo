" ============================================================================
" 核心映射配置 - 索引文件
" ============================================================================

" 设置leader键
let mapleader = " "
let maplocalleader = "\\"

" ============================================================================
" 功能键映射 (F1-F12)
" ============================================================================
" F1: 保留（通常用于帮助）
" F2: NERDTree 文件树
nnoremap <F2> :NERDTreeToggle<CR>
" F3: Vista 代码大纲
nnoremap <silent> <F3> :Vista!!<CR>
" F4-F12: 预留

" ============================================================================
" 窗口导航（Ctrl + 方向键）
" ============================================================================
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ============================================================================
" 搜索增强
" ============================================================================
nnoremap n nzz                     " 搜索后居中
nnoremap N Nzz

" ============================================================================
" 快捷键索引（按字母顺序）
" ============================================================================
" A - Code Actions
"   <leader>a   - 代码操作（选中）
"   <leader>ac  - 代码操作（光标位置）
"   <leader>as  - 代码操作（整个缓冲区）
"
" C - Coc List
"   <leader>cd  - 显示诊断
"   <leader>ce  - 管理扩展
"   <leader>cc  - 命令列表
"   <leader>co  - 文档符号
"   <leader>cs  - 工作区符号
"   <leader>cj  - 下一个项目
"   <leader>ck  - 上一个项目
"   <leader>cp  - 恢复列表
"   <leader>cl  - Code Lens
"
" E - Explorer
"   <leader>ee  - NERDTree 切换
"
" F - Format
"   <leader>f   - 格式化选中代码
"
" G - Go
"   <leader>gR  - 运行 Go 代码（注意：gr 已被 coc-references 使用）
"   <leader>gb  - 构建项目
"   <leader>gt  - 运行测试
"   <leader>gf  - 格式化代码
"   <leader>go  - 组织导入
"   <leader>gl  - golangci-lint
"   <leader>gv  - govulncheck
"   <leader>gc  - 检查 Go LSP
"   <leader>gi  - 安装 Go LSP
"
" H - Horizontal/Window
"   <leader>h   - 窗口宽度减小
"
" J - Jump/Window
"   <leader>j   - 窗口高度减小
"
" K - Key/Window
"   <leader>k   - 窗口高度增加
"   K           - 显示文档（coc.nvim）
"
" L - Left/Window
"   <leader>l   - 窗口宽度增加
"
" N - Rename
"   <leader>rn  - 重命名符号
"
" P - Plugin
"   <leader>pi  - 安装插件
"   <leader>pu  - 更新插件
"   <leader>pc  - 清理插件
"   <leader>ps  - 插件状态
"
" Q - Quickfix/Quit
"   <leader>q   - 退出
"   <leader>qf  - 快速修复
"
" R - Refactor/Run
"   <leader>r   - 重构（选中）
"   <leader>re  - 重构（光标位置）
"
" S - Search/Source
"   <leader>/   - 清除搜索高亮
"
" T - Tab/TODO/Test/Theme
"   <leader>tn  - 新建标签页
"   <leader>te  - 编辑标签页
"   <leader>tc  - 关闭标签页
"   <leader>th  - 上一个标签页
"   <leader>tl  - 下一个标签页
"   <leader>tmh - 标签页左移
"   <leader>tml - 标签页右移
"   <leader>tt  - 切换主题
"   <leader>td  - 搜索 TODO
"   <leader>tf  - 搜索当前文件 TODO
"
" V - Vista
"   <leader>v   - Vista 切换
"   <leader>vo  - Vista 打开
"   <leader>vc  - Vista 关闭
"   <leader>vf  - Vista 查找
"   <leader>vs  - Vista 侧边栏
"
" W - Write
"   <leader>w   - 保存
"   <leader>wq  - 保存并退出
"
" ============================================================================
" LSP 导航（无 leader 键）
" ============================================================================
" [g  - 上一个诊断
" ]g  - 下一个诊断
" gd  - 跳转到定义
" gy  - 跳转到类型定义
" gi  - 跳转到实现
" gr  - 跳转到引用（注意：与 go run 冲突，已改为 gR）
" K   - 显示文档
