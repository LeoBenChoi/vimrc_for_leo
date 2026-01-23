" =======================================================
" [AsyncTasks & AsyncRun] 异步任务构建系统
" =======================================================
" AsyncRun 是干活的苦力（负责后台执行命令）
" AsyncTasks 是聪明的管家（负责管理 .tasks 配置，统一调度）
"
" 配置文件：~/.vim/tasks.ini
" 该文件定义了所有可用的任务（file-run, file-build, go-test 等）

" --- 1. AsyncRun 基础设置 ---

" 自动打开 Quickfix 窗口 (高度为 6 行)
let g:asyncrun_open = 6

" 任务结束时响铃提醒 (0:关闭, 1:开启)
let g:asyncrun_bell = 1

" 设置项目根目录标记 (遇到这些文件就认为找到了项目根目录)
let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', 'go.mod']

" 默认让 Quickfix 窗口在底部
let g:asyncrun_open_pos = 'bottom'

" --- 2. Airline 集成 ---
" 在状态栏显示任务状态 (例如: 'running')
" 注意：这个功能需要 airline 扩展支持，如果没有可以注释掉
" let g:airline#extensions#asyncrun#enabled = 1

" --- 3. AsyncTasks 快捷键设置 ---

" <F5>: 运行 (单文件运行，类似于 VS Code 的 Run)
noremap <silent> <F5> :AsyncTask file-run<CR>

" <F9>: 构建 (整个项目构建)
noremap <silent> <F9> :AsyncTask file-build<CR>

" <F6>: 任务列表 (配合 FZF 使用，神器！)
" 弹出一个浮动窗口，列出当前可用的所有任务，回车即运行
noremap <silent> <F6> :AsyncTaskMacro<CR>

" --- 4. 任务配置文件路径 ---
" 全局任务配置文件位置（所有项目共享）
" 配置文件：~/.vim/tasks.ini
" 该文件定义了所有可用的任务（file-run, file-build, go-test 等）
let g:asynctasks_config_name = '.tasks.ini'
" 查找顺序：当前目录 -> 向上查找 -> 全局配置
" 使用 expand() 确保 Windows 路径正确解析
let g:asynctasks_rtp_config = expand('~/.vim/tasks.ini')

" 额外配置文件路径（使用相对路径，更通用）
let g:asynctasks_extra_config = [expand('~/.vim/tasks.ini')]

