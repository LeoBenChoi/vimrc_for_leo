echo "hello"
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
"	lightline			状态行
"	nerdtree			左边文件树
"	vim-cyberpunk		主题
"	vim-fugitive		git插件
"	vim-go				go语言自动导包和格式化
"	vim-lsp				vim lsp 插件
"	vim-lsp-settings	vim lsp 插件配置


" get OS release

" check flag file exists?
if filereadable(flag_file)
	echo "环境已经初始化..."
	sleep 1
	finish
else
	" create and wirte flag file
	call system('sudo touch ' . flag_file )
	call InstallGit()

	echo "install env ..."
	if (has('win32') || has('win64')) == 1
		execute(":!start git clone https://github.com/morhetz/gruvbox.git " . ' vimfiles\pack\plugins\start\gruvbox\')
		execute(":!start git clone https://github.com/itchyny/lightline.vim.git" . ' vimfiles\pack\plugins\start\lightline.vim\')
		execute(":!start git clone https://github.com/preservim/nerdtree.git " . ' vimfiles\pack\plugins\start\nerdtree\')
		execute(":!start git clone https://github.com/thedenisnikulin/vim-cyberpunk.git " . ' vimfiles\pack\plugins\start\vim-cyberpunk\')
		execute(":!start git clone https://github.com/tpope/vim-fugitive.git " . ' vimfiles\pack\plugins\start\vim-fugitive\')
		execute(":!start git clone https://github.com/fatih/vim-go.git " . ' vimfiles\pack\plugins\start\vim-go\')
		execute(":!start git clone https://github.com/prabirshrestha/vim-lsp.git " . ' vimfiles\pack\plugins\start\vim-lsp\')
		execute(":!start git clone https://github.com/mattn/vim-lsp-settings.git " . ' vimfiles\pack\plugins\start\vim-lsp-settings\')
	elseif has('unix') == 1
		call system("sudo git clone https://github.com/morhetz/gruvbox.git vimfiles/pack/plugins/start/gruvbox/")
		call system("sudo git clone https://github.com/itchyny/lightline.vim.git" . ' vimfiles/pack/plugins/start/lightline.vim/')
		call system("sudo git clone https://github.com/preservim/nerdtree.git " . ' vimfiles/pack/plugins/start/nerdtree/')
		call system("sudo git clone https://github.com/thedenisnikulin/vim-cyberpunk.git " . ' vimfiles/pack/plugins/start/vim-cyberpunk/')
		call system("sudo git clone https://github.com/tpope/vim-fugitive.git " . ' vimfiles/pack/plugins/start/vim-fugitive/')
		call system("sudo git clone https://github.com/fatih/vim-go.git " . ' vimfiles/pack/plugins/start/vim-go/')
		call system("sudo git clone https://github.com/prabirshrestha/vim-lsp.git " . ' vimfiles/pack/plugins/start/vim-lsp/')
		call system("sudo git clone https://github.com/mattn/vim-lsp-settings.git " . ' vimfiles/pack/plugins/start/vim-lsp-settings/')
	endif
endif


" install git
function! InstallGit()
	if empty(system('git --version'))
		echo "install git"
		if (has('win32') || has('win64')) == 1
			execute("winget install --id Git.Git -e --source winget")
		elseif has('unix') == 1
			let getos = call GetLinuxDistro()
			if getos == "kali"
				silent !sudo apt-get install git -y
				redraw!
			endif
		else
			echo "I not konw your OS"
		endif
	else
		echo "Git installed"
	endif
endfunction

" Get Linux release
function! GetLinuxDistro()
	" read file for /etc/os-release
	if filereadable('/etc/os-release')
		let os_release = readfile('/etc/os-release')
		for line in os_release
			if line =~ '^ID='
				" get release ID
				let distro = substitute(line, '^ID=', '', '')
				return distro
			endif
		endfor
	endif

	" if not found file for /etc/os-release, can try execute
	" lsb_release
	if executable('lsb_release')
		let distro = system('lsb_release -si')
		return trim(distro)
	endif

	" drfault, can not use your Linux or Unix
	return 'unknown'
endfunction

finish
