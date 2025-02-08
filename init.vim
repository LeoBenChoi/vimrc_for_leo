" 初始化环境和插件脚本
" 需要提前安装git环境
" 使用方法
" Windows
	" 1. 增加vimrc或者替换vimrc
	" 2. 打开此文件，输入:source运行
	" 3. 等待窗口全部关闭，插件安装完成
" Linux
	" 放到~/.vim/下
	" 打开此文件，输入:source运行

"目前插件：
""	start 自动加载
"	gruvbox				主题
"	nerdtree			左边文件树
"	lightline			状态行
"	vim-go				go语言自动导包和格式化
"	vim-lsp				vim lsp 插件
"	vim-lsp-settings	vim lsp 插件配置

if has('win32') || has('win64')
	execute(":!start git clone https://github.com/morhetz/gruvbox.git " . ' vimfiles\pack\plugins\start\gruvbox\')
	execute(":!start git clone https://github.com/preservim/nerdtree.git " . ' vimfiles\pack\plugins\start\nerdtree\')
	execute(":!start git clone https://github.com/itchyny/lightline.vim.git" . ' vimfiles\pack\plugins\start\lightline.vim\')
	execute(":!start git clone https://github.com/fatih/vim-go.git " . ' vimfiles\pack\plugins\start\vim-go\')
	execute(":!start git clone https://github.com/prabirshrestha/vim-lsp.git " . ' vimfiles\pack\plugins\start\vim-lsp\')
	execute(":!start git clone https://github.com/mattn/vim-lsp-settings.git " . ' vimfiles\pack\plugins\start\vim-lsp-settings\')
elseif has('unix')
	execute(":!start git clone https://github.com/morhetz/gruvbox.git " . ' vim\pack\plugins\start\gruvbox\')
	execute(":!start git clone https://github.com/preservim/nerdtree.git " . ' vim\pack\plugins\start\nerdtree\')
	execute(":!start git clone https://github.com/itchyny/lightline.vim.git" . ' vim\pack\plugins\start\lightline.vim\')
	execute(":!start git clone https://github.com/fatih/vim-go.git " . ' vim\pack\plugins\start\vim-go\')
	execute(":!start git clone https://github.com/prabirshrestha/vim-lsp.git " . ' vim\pack\plugins\start\vim-lsp\')
endif

finish
