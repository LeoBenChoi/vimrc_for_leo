# Vim 配置 - 现代化开发环境

> 一个功能完整、模块化的 Vim 配置，专为现代软件开发设计

[![Version](https://img.shields.io/badge/version-4.0.0-blue.svg)](https://github.com/LeoBenChoi/vimrc_for_leo)

## ✨ 特性

### 🎨 界面美化
- **vim-airline**: 强大的状态栏，显示 Git 分支、文件信息、行号等
- **seoul256**: 优雅的配色方案
- **rainbow**: 彩虹括号，提高代码可读性
- **vim-devicons**: 文件类型图标支持

### 🚀 核心功能
- **coc.nvim**: 强大的 LSP 客户端，支持代码补全、诊断、跳转等
- **vim-go**: Go 语言开发工具集
- **FZF**: 极速模糊搜索（文件、内容、历史等）
- **NERDTree**: 文件树导航
- **Vista**: 代码结构大纲

### 🔧 开发工具
- **AsyncRun/AsyncTasks**: 异步任务执行系统，支持编译、测试、运行
- **vim-fugitive**: Git 操作集成
- **vim-signify**: Git 变更标记（增删改）
- **vim-translator**: 代码翻译工具
- **vim-startuptime**: 启动时间分析

### 📦 其他工具
- **vim-startify**: 优雅的启动界面
- **vim-commentary**: 快速注释工具
- **vim-wakatime**: 编码时间统计

## 📋 系统要求

- **Vim**: 8.0+ 或 **Neovim** 0.5+
- **Git**: 用于插件管理
- **Node.js**: 用于 coc.nvim（推荐 16+）
- **Python**: 部分插件需要（可选）

## 🚀 快速开始

### 1. 安装 vim-plug

```bash
# Linux/macOS
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Windows (PowerShell)
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$env:LOCALAPPDATA\nvim-data\site\autoload\plug.vim -Force
```

### 2. 克隆配置

```bash
git clone https://github.com/LeoBenChoi/vimrc_for_leo.git ~/.vim
```

### 3. 安装插件

打开 Vim，运行：

```vim
:PlugInstall
```

### 4. 配置 coc.nvim（可选）

如果需要 LSP 功能，安装语言服务器：

```vim
:CocInstall coc-go
:CocInstall coc-json
:CocInstall coc-yaml
" ... 其他语言服务器
```

## 📁 目录结构

```
~/.vim/
├── .vimrc                 # 主配置文件（加载插件和配置）
├── plugins.vim            # 插件声明文件
├── plugin/                # 插件配置目录
│   ├── 00-init.vim        # 核心设置和全局配置
│   ├── 20-settings.vim    # 插件配置索引
│   ├── 21-fzf.vim         # FZF 配置
│   ├── 22-vim-go.vim      # vim-go 配置
│   ├── 23-asyncrun.vim    # AsyncRun 配置
│   ├── 24-airline.vim     # vim-airline 配置
│   ├── 25-startify.vim    # Startify 配置
│   ├── 26-nerdtree.vim    # NERDTree 配置
│   ├── 27-rainbow.vim     # Rainbow 配置
│   ├── 28-translator.vim  # 翻译插件配置
│   ├── 29-vista.vim       # Vista 配置
│   ├── 30-coc.vim         # coc.nvim 配置
│   ├── 32-git.vim         # Git 工具配置
│   └── 33-asynctasks.vim  # AsyncTasks 配置
├── tasks.ini              # 异步任务定义
├── coc-settings.json       # coc.nvim 配置
├── ftplugin/              # 文件类型特定配置
└── plugged/               # 插件目录（由 vim-plug 管理）
```

## ⌨️ 快捷键

### 文件操作
- `<F2>`: 打开/关闭文件树（NERDTree）
- `<Leader>n`: 打开文件树（备用）
- `<Leader>f`: 在当前文件所在目录打开文件树

### 搜索
- `<Leader>f`: FZF 文件搜索
- `<Leader>g`: FZF Git 文件搜索
- `<Leader>b`: FZF 缓冲区搜索
- `<Leader>r`: FZF 历史搜索
- `:Todo`: 搜索 TODO 注释

### 代码导航
- `<Leader>v`: 打开代码结构大纲（Vista）
- `gd`: 跳转到定义（coc.nvim）
- `gr`: 查找引用（coc.nvim）

### 异步任务
- `<F5>`: 运行当前文件
- `<F6>`: 任务列表（FZF 选择）
- `<F9>`: 构建项目
- `<F10>`: 停止当前任务

### Git 操作
- `:G`: 打开 Git 状态
- `:G blame`: 查看 Git 追溯
- `:G diff`: 查看差异

### 其他
- `gcc`: 注释/取消注释当前行
- `gc`: 注释/取消注释选中区域

## 🛠️ 配置说明

### 模块化设计

所有插件配置按功能分类到独立文件，便于维护和定制：

- **00-init.vim**: 核心 Vim 设置、全局快捷键、自动命令
- **20-settings.vim**: 插件配置索引（说明文档）
- **21-33**: 各插件的具体配置

### 异步任务系统

配置文件：`~/.vim/tasks.ini`

预定义任务：
- `file-run`: 运行当前文件
- `file-build`: 构建项目
- `go-test`: Go 测试
- `go-mod-tidy`: Go 模块整理

### LSP 配置

配置文件：`~/.vim/coc-settings.json`

支持的语言服务器：
- Go (coc-go)
- JSON (coc-json)
- YAML (coc-yaml)
- 更多语言服务器可通过 `:CocInstall` 安装

## 🎯 使用技巧

### 启动时间分析

```vim
:StartupTime
```

### 查看 Git 状态

```vim
:G
```

### 快速搜索

使用 FZF 进行模糊搜索，支持：
- 文件名搜索
- 内容搜索（使用 ripgrep）
- Git 文件搜索
- 缓冲区搜索

### 代码补全

coc.nvim 提供智能补全：
- 自动触发补全
- 使用 `<Tab>` 选择补全项
- 使用 `<Enter>` 确认

## 🔧 自定义配置

### 添加新插件

编辑 `plugins.vim`，添加：

```vim
Plug 'author/plugin-name'
```

然后运行 `:PlugInstall`

### 修改插件配置

找到对应的配置文件（如 `plugin/24-airline.vim`），直接编辑即可。

### 添加自定义任务

编辑 `tasks.ini`，添加新任务定义：

```ini
[task-name]
command=your-command
cwd=<root>
output=quickfix
```

## 📝 更新日志

### Version 4.0.0 (2026-01-24)
- ✨ 重构配置结构，采用模块化设计
- ➕ 添加 `.gitignore` 配置
- 🔧 优化插件配置，提升启动速度
- 📦 更新插件列表和配置

