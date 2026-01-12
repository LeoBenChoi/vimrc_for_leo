# Vim 配置文件

这是一个模块化的 Vim 配置文件，采用目录结构组织不同的配置模块。

## 目录结构

```
.vim/
├── .vimrc                   # 简单入口文件（只需复制一次到home目录）
├── config/
│   ├── vimrc.vim            # 真正的入口文件（包含所有配置加载逻辑）
│   ├── init/               # 初始化配置
│   ├── init/               # 初始化配置
│   │   ├── basic.vim       # 基础配置
│   │   ├── filetype.vim    # 文件类型配置
│   │   ├── indent.vim      # 缩进配置
│   │   ├── fold.vim        # 折叠配置
│   │   └── performance.vim # 性能优化
│   ├── mappings/           # 快捷键映射
│   │   ├── core.vim        # 核心映射
│   │   └── tab.vim         # 标签页映射
│   ├── plugins/            # 插件配置
│   │   ├── plugins.vim     # 插件管理（vim-plug）
│   │   ├── fzf.vim         # FZF 模糊搜索配置
│   │   ├── fzf_todo.vim    # FZF TODO 搜索配置
│   │   ├── lsp_coc.vim     # Coc.nvim LSP 配置
│   │   ├── vista.vim       # Vista 代码大纲配置
│   │   ├── todo.vim        # TODO 高亮配置（Vim 原生 match）
│   │   └── go_linter.vim   # Go 语言 Linter 配置
│   └── ui/                 # 界面配置
└── README.md
```

## 使用方法

1. 将整个 `.vim` 目录复制到你的用户目录
2. 将 `.vimrc` 复制到 home 目录（只需要复制一次）

### Linux/Mac
```bash
cp ~/.vim/.vimrc ~/.vimrc
```

### Windows
```cmd
copy %USERPROFILE%\.vim\.vimrc %USERPROFILE%\_vimrc
```

**重要提示**：
- `.vimrc` 文件只需要复制一次到 home 目录
- 之后所有配置修改都在 `~/.vim/` 目录下进行
- 修改配置时无需再次复制 `.vimrc` 文件

## 主要特性

- **模块化设计**：配置按功能分类，易于维护
- **插件管理**：使用 vim-plug 管理插件，支持自动安装
- **基础配置**：包含常用的编辑、显示、搜索等设置
- **文件类型支持**：自动识别多种文件类型并应用相应设置
- **快捷键映射**：使用空格键作为leader键，提供便捷的快捷键
- **性能优化**：针对大文件和性能进行了优化
- **代码补全**：使用 coc.nvim 提供 LSP 支持
- **代码大纲**：使用 Vista 显示代码结构（支持 coc 后端）
- **TODO 高亮**：使用 Vim 原生 match 机制高亮显示 TODO 注释
- **TODO 搜索**：使用 FZF 快速搜索代码中的 TODO 注释（需要 ripgrep 或 ag）

## 自定义

你可以根据需要修改各个配置文件：
- `config/vimrc.vim` - 修改配置加载逻辑（添加/移除配置文件）
- `config/init/basic.vim` - 修改基础设置
- `config/mappings/core.vim` - 添加或修改快捷键
- `config/init/filetype.vim` - 添加新的文件类型支持

**注意**：所有配置修改都在 `~/.vim/` 目录下进行，无需修改 home 目录下的 `.vimrc` 文件。

## 快捷键说明

### Leader 键
默认使用空格键 `<Space>` 作为 leader 键

### 常用快捷键
- `<leader>w` - 保存文件
- `<leader>q` - 退出
- `<leader>wq` - 保存并退出
- `<leader>ev` - 编辑vimrc
- `<leader>sv` - 重新加载vimrc
- `<leader>/` - 清除搜索高亮
- `jk` 或 `kj` - 退出插入模式

### 窗口操作
- `Ctrl+h/j/k/l` - 在窗口间移动
- `<leader>h/l` - 调整窗口宽度
- `<leader>j/k` - 调整窗口高度

### 标签页操作
- `<leader>tn` - 新建标签页
- `<leader>tc` - 关闭标签页
- `<leader>th/l` - 切换标签页

### 插件管理（vim-plug）
- `<leader>pi` - 安装插件（PlugInstall）
- `<leader>pu` - 更新插件（PlugUpdate）
- `<leader>pc` - 清理未使用的插件（PlugClean）
- `<leader>ps` - 查看插件状态（PlugStatus）

### Vista 代码大纲
- `<F3>` - 切换 Vista 侧边栏（推荐）
- `<leader>v` - 切换 Vista 侧边栏
- `<leader>vo` - 打开 Vista 侧边栏
- `<leader>vc` - 关闭 Vista 侧边栏
- `<leader>vf` - 查找当前符号
- `<leader>vs` - 显示当前文件的符号

### TODO 高亮和搜索
- **自动高亮**：代码中的 `TODO:` 会自动高亮显示（红色背景）
- `<leader>td` - 搜索所有文件中的 TODO 注释（使用 FZF）
- `<leader>tf` - 搜索当前文件中的 TODO 注释（使用 FZF）
- `:TODO` - 搜索所有文件中的 TODO 注释
- `:TODOFile` - 搜索当前文件中的 TODO 注释

## 插件管理

本配置使用 **vim-plug** 作为插件管理器。

### 添加插件

编辑 `config/plugins/plugins.vim` 文件，在 `call plug#begin()` 和 `call plug#end()` 之间添加插件：

```vim
call plug#begin('~/.vim/plugged')

" 添加插件
Plug '插件作者/插件名'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  " 带安装脚本的插件

call plug#end()
```

### 安装插件

1. 在配置文件中添加插件后，重新加载配置：`:source ~/.vimrc`
2. 运行 `:PlugInstall` 或使用快捷键 `<leader>pi`
3. vim-plug 会自动下载并安装插件

### 更新插件

运行 `:PlugUpdate` 或使用快捷键 `<leader>pu` 更新所有插件。

### 删除插件

1. 从 `config/plugins/plugins.vim` 中删除插件行
2. 运行 `:PlugClean` 或使用快捷键 `<leader>pc` 清理未使用的插件
