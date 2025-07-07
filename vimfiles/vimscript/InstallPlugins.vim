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
"	lightline			状态行 轻量
"	nerdtree			左边文件树
"	vim-cyberpunk		主题
"	vim-fugitive		git插件
"	vim-go				go语言自动导包和格式化
"	vim-lsp				vim lsp 插件
"	vim-lsp-settings	vim lsp 插件配置
"	vim-airline         状态行
"	tagbar              

let plugins = [
\ 'https://github.com/morhetz/gruvbox.git',
\ 'https://github.com/itchyny/lightline.vim.git',
\ 'https://github.com/preservim/nerdtree.git',
\ 'https://github.com/rainbow-me/rainbow.git',
\ 'https://github.com/tpope/vim-fugitive.git',
\ 'https://github.com/fatih/vim-go.git',
\ 'https://github.com/prabirshrestha/vim-lsp.git',
\ 'https://github.com/mattn/vim-lsp-settings.git',
\ 'https://github.com/wakatime/vim-wakatime.git',
\ 'https://github.com/vim-airline/vim-airline.git',
\ 'https://github.com/preservim/tagbar.git',
\ 'https://github.com/mhinz/vim-signify.git',
\ 'https://github.com/airblade/vim-gitgutter.git',
\ 'https://github.com/lambdalisue/vim-battery.git',
\ 'https://github.com/ryanoasis/vim-devicons.git',
\ 'https://github.com/vim-airline/vim-airline-themes.git',
\
\ 'https://github.com/prabirshrestha/asyncomplete.vim.git',
\ 'https://github.com/prabirshrestha/asyncomplete-lsp.vim.git',
\ 'https://github.com/prabirshrestha/asyncomplete-buffer.vim.git',
\ 'https://github.com/prabirshrestha/asyncomplete-file.vim.git',
\ 
\ 'https://github.com/prabirshrestha/vim-lsp.git',
\ 'https://github.com/mattn/vim-lsp-settings.git'
\]



"if has('win32') || has('win64')
"    let target_path = expand($VIM . '\\vimfiles\\pack\\plugins\\start')
"else
"    let target_path = expand('~/.vim/vimfiles/pack/plugins/start')
"endif

let target_path = expand('~/.vim/vimfiles/pack/plugins/start/')

" 克隆每个 Git 项目到指定路径
for plugin in plugins
    let repo_name = substitute(plugin, '^.*/\(.*\)\.git$', '\1', '')
	if has('win32') || has('win64')
		let clone_dir = target_path . '\\' . repo_name
	else
		let clone_dir = target_path . '/' . repo_name
	endif
    if !isdirectory(clone_dir)
        echo "Cloning " . plugin . " into " . clone_dir
        " Make sure to quote the paths to handle spaces properly
        call system('git clone "' . plugin . '" "' . clone_dir . '"')
    else
        echo repo_name . " already exists, skipping..."
    endif
endfor


if (has('win32') || has('win64')) == 1
    let filepath = expand('$USERPROFILE') . '/.vim/vimfiles/flag/flag_install'
    call mkdir(fnamemodify(filepath, ':h'), 'p')  " 创建目录
    call writefile(['内容写入成功'], filepath)
elseif has('unix') == 1
    let filepath = expand('~/') . '/.vim/vimfiles/flag/flag_install'
    call mkdir(fnamemodify(filepath, ':h'), 'p')  " 创建目录
    call writefile(['内容写入成功'], filepath)
    call system('touch ~/.vim/vimfiles/flag/flag_install')
endif

echo "插件安装完成。"

finish
