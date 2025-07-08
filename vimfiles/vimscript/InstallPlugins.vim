" ============================================================================
" 🧩 Vim 插件自动安装脚本（适用于 pack 目录）
" ============================================================================
" ✅ 使用场景：
"   - 初次配置 Vim 环境
"   - 跨平台快速安装常用插件
"   - 使用 Vim 原生插件管理（不依赖插件管理器）
"
" ✅ 支持平台：
"   - Windows: 安装到 $VIM/vimfiles/pack/plugins/start
"   - Linux/macOS: 安装到 ~/.vim/vimfiles/pack/plugins/start
"
" ✅ 使用说明：
"   1. 将本文件命名为 plugin_installer.vim，放入 ~/.vim 或 $VIM 目录中
"   2. 在 Vim 中执行 `:source %` 运行该脚本
"   3. 等待 Git 克隆完成
"   4. 插件将在下次启动 Vim 时自动加载
"
" ✅ 插件列表（支持功能）：
"   - gruvbox / cyberpunk：主题
"   - vim-airline / lightline：状态栏
"   - vim-fugitive / vim-flog：Git 交互与历史
"   - fern.vim / nerdtree：文件树（推荐 fern）
"   - vim-go：Go 开发支持
"   - vim-lsp / vim-lsp-settings：LSP 支持
"   - asyncomplete：自动补全框架
"   - vim-battery：电量显示
"   - vim-signify：Git 差异标记
"   - vim-startuptime：启动时间分析
"
" ============================================================================
" 插件 Git 地址列表
let plugins = [
\ 'https://github.com/morhetz/gruvbox.git',
\ 'https://github.com/tpope/vim-fugitive.git',
\ 'https://github.com/mhinz/vim-signify.git',
\ 'https://github.com/lambdalisue/vim-fern.git',
\ 'https://github.com/lambdalisue/fern-renderer-nerdfont.vim.git',
\ 'https://github.com/lambdalisue/fern-git-status.vim.git',
\ 'https://github.com/lambdalisue/nerdfont.vim.git',
\ 'https://github.com/rbong/vim-flog.git',
\ 'https://github.com/fatih/vim-go.git',
\ 'https://github.com/prabirshrestha/vim-lsp.git',
\ 'https://github.com/mattn/vim-lsp-settings.git',
\ 'https://github.com/vim-airline/vim-airline.git',
\ 'https://github.com/vim-airline/vim-airline-themes.git',
\ 'https://github.com/ryanoasis/vim-devicons.git',
\ 'https://github.com/lambdalisue/vim-battery.git',
\ 'https://github.com/prabirshrestha/asyncomplete.vim.git',
\ 'https://github.com/prabirshrestha/asyncomplete-lsp.vim.git',
\ 'https://github.com/prabirshrestha/asyncomplete-buffer.vim.git',
\ 'https://github.com/prabirshrestha/asyncomplete-file.vim.git',
\ 'https://github.com/dstein64/vim-startuptime.git'
\ ]

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
