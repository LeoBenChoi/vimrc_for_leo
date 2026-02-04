# Vim 配置 - 现代化开发环境

> 模块化 Vim 配置，以 coc.nvim 为核心，适合日常编码与多语言开发。

## ✨ 特性概览

### 🎨 界面与主题
- **seoul256**（终端）：经典深色配色
- **retrobox**（GVim）：图形界面主题
- **rainbow_parentheses**：彩虹括号，提升括号配对可读性
- **vim-devicons**：侧边栏与文件类型图标
- **原生状态栏**：集成 Git 分支、GitGutter 统计、coc 诊断与状态

### 🚀 核心能力
- **coc.nvim**：LSP 客户端，补全、诊断、跳转、重命名、格式化、代码操作
- **vim-fugitive**：Git 集成（`:G` 等）
- **vim-gitgutter**：行侧 Git 变更标记（+ ~ -）
- **NERDTree**：侧边栏文件树，按需加载

### 🔧 体验与工具
- **vim-sensible**：通用合理默认
- **vim-commentary**：快速注释（`gcc` / `gc` + 选区）
- **vimcdoc**：中文帮助
- **vim-startuptime**：启动时间分析
- **vim-wakatime**：编码时间统计

### 📁 文件类型
- **ftplugin/go.vim**：Go 按缩进折叠，保存/恢复折叠视图

## 📋 系统要求

- **Vim** 8.0+ 或 **Neovim** 0.5+
- **Git**：克隆与插件管理
- **Node.js**：coc.nvim（建议 16+）

## 🚀 快速开始

### 1. 安装 vim-plug

```bash
# Linux/macOS
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Windows (PowerShell)
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $env:USERPROFILE\.vim\autoload\plug.vim -Force
```

### 2. 使用本配置

```bash
git clone <你的仓库地址> ~/.vim
```

### 3. 安装插件

启动 Vim 后执行：

```vim
:PlugInstall
```

### 4. coc.nvim 扩展（可选）

LSP 与补全依赖 coc 扩展，可按需安装：

```vim
:CocInstall coc-go
:CocInstall coc-json
:CocInstall coc-yaml
:CocInstall coc-vimlsp
:CocInstall coc-snippets
:CocInstall coc-marketplace
```

配置中已通过 `g:coc_global_extensions` 声明常用扩展，首次启动 coc 时会自动安装。

## 📁 目录结构

```
~/.vim/
├── .vimrc                 " 入口：设置 runtimepath 并加载 plugins.vim
├── plugins.vim            " 插件列表（vim-plug）
├── coc-settings.json      " coc.nvim 配置（格式、Go 等）
├── .gitignore             " 忽略 plugged/、备份、交换文件等
├── autoload/
│   └── plug.vim           " vim-plug 脚本
├── plugin/                " 模块化配置（按功能拆分）
│   ├── basic.vim          " 备份/交换/撤销/视图、行号、wildmenu、恢复光标
│   ├── coc.vim             " coc.nvim 键位与行为
│   ├── performance.vim    " 内存、updatetime、DirectX（Windows GVim）
│   ├── rainbow.vim        " 彩虹括号
│   ├── sidebar.vim        " NERDTree 与自动化
│   ├── statusline.vim     " 状态栏（Git、诊断、编码等）
│   └── ui.vim             " 主题、GUI 选项与字体
├── ftplugin/
│   └── go.vim             " Go 缩进折叠与视图保存
└── plugged/               " 插件目录（vim-plug 管理，已在 .gitignore）
```

## ⌨️ 快捷键与命令

### 侧边栏（NERDTree）
| 按键 | 说明 |
|------|------|
| `<F2>` | 打开/关闭文件树 |
| `<Leader>e` | 在文件树中定位当前文件 |

### coc.nvim 补全与导航
| 按键 | 说明 |
|------|------|
| `<Tab>` / `<S-Tab>` | 补全列表中下一项/上一项 |
| `<Enter>` | 确认补全或触发 coc 格式化 |
| `<C-Space>`（或 Vim 下 `<C-@>`） | 手动触发补全 |
| `gd` | 跳转到定义 |
| `gy` | 跳转到类型定义 |
| `gi` | 跳转到实现 |
| `gr` | 查找引用 |
| `K` | 悬浮文档（Hover） |
| `[g` / `]g` | 上一个/下一个诊断 |

### coc 代码操作与列表
| 按键 | 说明 |
|------|------|
| `<Leader>rn` | 重命名符号 |
| `<Leader>f` | 格式化选中/当前（n/x 模式） |
| `<Leader>a` | 对选中应用代码操作 |
| `<Leader>ac` | 光标处代码操作 |
| `<Leader>qf` | 快速修复当前行诊断 |
| `<Leader>cl` | 执行当前行 Code Lens |
| `<Space>a` | CocList 诊断 |
| `<Space>e` | CocList 扩展 |
| `<Space>c` | CocList 命令 |
| `<Space>o` | CocList 当前文档符号大纲 |
| `<Space>s` | CocList 工作区符号 |

### 注释（vim-commentary）
| 按键 | 说明 |
|------|------|
| `gcc` | 注释/取消注释当前行 |
| `gc` + 选区 | 注释/取消注释选中区域 |

### Git（vim-fugitive）
| 命令 | 说明 |
|------|------|
| `:G` | 打开 Git 状态 |
| `:G blame` | 追溯当前文件 |
| `:G diff` | 查看差异 |

### 其他
| 命令 | 说明 |
|------|------|
| `:Format` | 格式化当前缓冲区 |
| `:OR` | 整理导入（如 Go organize imports） |
| `:StartupTime` | 查看启动时间分析 |

## 🛠️ 配置说明

### 模块化设计

- **basic.vim**：备份目录、交换目录、撤销与视图目录、行号、wildmenu、恢复上次光标等。
- **coc.vim**：补全键位、诊断导航、跳转、重命名、格式化、代码操作、CoCList、coc 扩展列表（含 coc-go、coc-json、coc-yaml、coc-vimlsp、coc-snippets 等）。
- **performance.vim**：`maxmem`/`maxmemtot`、`updatetime`、Windows GVim 下 DirectX 渲染、`ttyfast`/`lazyredraw`。
- **statusline.vim**：Git 分支（Fugitive）、GitGutter 统计、coc 诊断数量、coc 状态、文件类型与编码。

### coc 配置（coc-settings.json）

- 保存时自动格式化（`coc.preferences.formatOnSave`）
- 补全不自动选中第一项（`suggest.noselect`）
- Go：保存时整理 import；gopls 补全未导入符号

### 主题策略（ui.vim）

- 终端：`seoul256`（`g:seoul256_background = 234`）
- GVim：尝试 `retrobox`，失败则 `default`
- Windows GVim：可选用 Maple Mono 等字体（见 `guifont`）

## 🔧 自定义

### 添加插件

在 `plugins.vim` 的 `plug#begin` 与 `plug#end` 之间添加：

```vim
Plug 'author/plugin-name'
```

然后执行 `:PlugInstall`。

### 修改插件行为

在 `plugin/` 下对应模块中修改（如 NERDTree 在 `sidebar.vim`，coc 在 `coc.vim`）。

### 添加 coc 扩展

在 `coc.vim` 的 `g:coc_global_extensions` 中追加，或临时执行：

```vim
:CocInstall coc-xxx
```

## 📝 更新说明

- 当前结构为模块化配置：`.vimrc` → `plugins.vim` + `plugin/*.vim` + `ftplugin/*.vim`。
- 核心为 coc.nvim + 原生状态栏 + NERDTree + Git（Fugitive/GitGutter）+ 主题与基础体验优化。
- 备份、交换、撤销、视图等目录集中在 `~/.vim/.backup/`、`.swapfile/`、`.undofile/`、`.view/`，已通过 `.gitignore` 排除。
