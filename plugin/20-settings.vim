" =======================================================
" [插件配置索引] 各种插件的开关和设置
" =======================================================
"
" 本文件作为插件配置的索引，具体配置已按插件分类到以下文件：
"
" 21-fzf.vim          - FZF 模糊搜索配置
" 22-vim-go.vim       - vim-go Go 语言开发工具配置
" 23-asyncrun.vim     - AsyncRun 异步任务执行器配置（基础配置）
" 33-asynctasks.vim   - AsyncTasks & AsyncRun 集成配置（任务管理系统）
" 24-airline.vim      - vim-airline 状态栏美化配置
" 25-startify.vim     - Startify 启动页配置
" 26-nerdtree.vim     - NERDTree 文件树配置
" 27-rainbow.vim      - Rainbow 彩虹括号配置
" 28-translator.vim   - vim-translator 翻译插件配置
" 29-vista.vim        - Vista 代码结构大纲配置
" 30-coc.vim          - coc.nvim 智能补全与 LSP 配置
" 32-git.vim          - Git 黄金组合配置（vim-fugitive & vim-signify）
"
" 注意：所有插件配置按数字顺序自动加载

" =======================================================
" [Go Fold Strategy] 定义折叠策略
" =======================================================
" 让 vim-go 插件知道我们想折叠哪些内容
" block: 函数体 (可选，如果不喜欢函数被折叠可以去掉)
" import: 导入块 (强力推荐)
" varconst: 长变量/常量块
" package_comment: 包注释
let g:go_fold_enable = ['block', 'import', 'varconst', 'package_comment']

" 严禁保存 options，否则会因为保存了错误的缩进设置导致混乱
set viewoptions=cursor,folds,slash,unix

" 4. 自动化命令：静默保存和加载
augroup AutoSaveView
    autocmd!
    " 离开或保存时：如果文件名不为空，则保存视图
    autocmd BufWinLeave,BufWritePost * if expand('%') != '' | silent! mkview | endif
    
    " 打开文件时：如果文件名不为空，则恢复视图
    autocmd BufWinEnter * if expand('%') != '' | silent! loadview | endif
augroup END