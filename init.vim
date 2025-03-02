" 初始化环境和插件脚本
" 需要提前安装git环境
" 使用方法
" Windows
" 1. 增加vimrc或者替换vimrc
" 2. 打开此文件，输入:source运行
" 3. 等待窗口全部关闭，插件安装完成
" Linux
" 放到 /etc/vim/ 下
" 打开此文件，输入:source运行


"目前插件：
""	start 自动加载
"	gruvbox				主题
"	lightline			状态行
"	nerdtree			左边文件树
"	vim-cyberpunk		主题
"	vim-fugitive		git插件
"	vim-go				go语言自动导包和格式化
"	vim-lsp				vim lsp 插件
"	vim-lsp-settings	vim lsp 插件配置


" init_complete_flag
let flag_file = expand($VIMHOME . '\init_complete_flag')

" 检查标志文件是否存在
if filereadable(flag_file)
	echo "环境已经初始化"
	finish
else
	" 创建并写入标志文件
	call writefile(['executed'], flag_file)

	echo "准备初始化..."
	sleep 3	" 暂停1s
	" 在这里放置你想要执行的代码
	
	" 判断是否安装git
	let init = 0
	if !empty(system('git --version'))
		echo "Git 已安装"
		let init = 1
	else
		echo "Git 未安装, 准备安装git"
		execute("winget install --id Git.Git -e --source winget")
	endif

	" 执行git安装插件环境
	if (has('win32') || has('win64')) && init == 1
		echo init
		execute(":!start git clone https://github.com/morhetz/gruvbox.git " . ' vimfiles\pack\plugins\start\gruvbox\')
		execute(":!start git clone https://github.com/itchyny/lightline.vim.git" . ' vimfiles\pack\plugins\start\lightline.vim\')
		execute(":!start git clone https://github.com/preservim/nerdtree.git " . ' vimfiles\pack\plugins\start\nerdtree\')
		execute(":!start git clone https://github.com/tpope/vim-fugitive.git " . ' vimfiles\pack\plugins\start\vim-fugitive\')
		execute(":!start git clone https://github.com/fatih/vim-go.git " . ' vimfiles\pack\plugins\start\vim-go\')
		execute(":!start git clone https://github.com/prabirshrestha/vim-lsp.git " . ' vimfiles\pack\plugins\start\vim-lsp\')
		execute(":!start git clone https://github.com/mattn/vim-lsp-settings.git " . ' vimfiles\pack\plugins\start\vim-lsp-settings\')
	endif
endif


finish
