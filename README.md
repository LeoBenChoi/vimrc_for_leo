# Vimrc_for_leo

我的个人vimrc，一个模块化、跨平台的 Vim/gVim 配置，支持 Windows 和 Linux，专注于开发效率与可扩展性。

## ✨ 特性

- 🎯 **模块化设计**：配置按功能拆分，易于维护和扩展
- 🌍 **跨平台支持**：Windows 和 Linux 双平台兼容
- 🎨 **双主题系统**：支持日间/夜间主题自动切换
- 🔌 **插件管理**：基于 vim-plug，易于迁移到其他插件管理器
- 🚀 **LSP 集成**：基于 coc.nvim，支持多种编程语言
- 🔍 **模糊搜索**：集成 fzf，快速文件与内容搜索
- 📁 **文件管理**：NERDTree 文件浏览器
- 📊 **代码大纲**：Vista.vim 提供代码结构视图
- 💾 **自动备份**：集中管理备份、交换、撤销文件
- ⌨️ **快捷键体系**：逻辑清晰，易于记忆

## 📁 目录结构

```text
~/.vim/
├── .vimrc                 # 主配置文件（需复制到 ~/.vimrc）
├── .gitignore             # Git 忽略规则
├── README.md              # 本文件
├── coc-settings.json      # coc.nvim 配置
├── autoload/
│   └── plug.vim           # vim-plug 插件管理器
├── config/
│   ├── bootstrap/         # 环境检测与修复
│   │   └── env_check.vim  # 环境检查脚本
│   ├── init/              # 基础设置（不依赖插件）
│   │   ├── basic.vim      # 基础配置（编码、行号、缩进等）
│   │   └── performance.vim # 性能优化配置
│   ├── plugins/           # 插件管理
│   │   ├── plugins.vim    # 插件列表与 vim-plug 配置
│   │   ├── lsp_coc.vim    # coc.nvim LSP 配置
│   │   ├── fzf.vim        # FZF 搜索配置
│   │   └── git.vim        # Git 插件配置
│   ├── ui/                # 用户界面
│   │   ├── theme.vim      # 主题配置（日/夜切换）
│   │   ├── font.vim       # 字体配置（gVim）
│   │   ├── statusline.vim # 状态栏配置（vim-airline）
│   │   ├── sidebar.vim    # 侧边栏配置（NERDTree）
│   │   ├── startify.vim   # 启动页配置（vim-startify）
│   │   └── outline.vim    # 代码大纲配置（Vista）
│   └── mappings/          # 快捷键映射（按字母分类）
│       ├── core.vim       # 核心快捷键定义
│       ├── a.vim          # LSP 代码操作快捷键
│       ├── c.vim          # 注释功能快捷键
│       ├── e.vim          # 文件浏览器快捷键
│       ├── f.vim          # FZF 搜索快捷键
│       ├── g.vim          # Git 操作快捷键
│       ├── o.vim          # 代码大纲快捷键
│       └── t.vim          # 主题切换快捷自动键
├── plugged/               # 插件安装目录（自动生成）
├── .backup/               # 备份文件目录（自动生成）
├── .swap/                 # 交换文件目录（自动生成）
├── .undo/                 # 撤销历史目录（自动生成）
└── .view/                 # 视图文件目录（自动生成）
```

## 🚀 快速开始

### 1. 安装

```bash
# 克隆或复制配置到 ~/.vim
git clone <your-repo> ~/.vim
# 或直接复制整个 .vim 目录到 ~/.vim

# 将 .vimrc 复制到用户主目录
cp ~/.vim/.vimrc ~/.vimrc

# Windows 用户
copy C:\Users\YourName\.vim\.vimrc C:\Users\YourName\.vimrc
```

### 2. 安装插件

启动 Vim，执行：

```vim
:PlugInstall
```

等待插件安装完成。

### 3. 安装 LSP 扩展（可选）

如果需要 LSP 支持，安装对应的 coc 扩展：

```vim
" Python
:CocInstall coc-pyright

" JavaScript/TypeScript
:CocInstall coc-tsserver

" Go
:CocInstall coc-go

" 查看所有可用扩展
:CocList extensions
```

### 4. 配置本地设置（可选）

创建 `~/.vim/local.vim` 添加个人配置：

```vim
" 个人定制配置
let g:my_custom_setting = 1
```

## 📦 插件列表

### 核心插件

- **[vim-plug](https://github.com/junegunn/vim-plug)** - 插件管理器
- **[coc.nvim](https://github.com/neoclide/coc.nvim)** - LSP 客户端
- **[fzf.vim](https://github.com/junegunn/fzf.vim)** - 模糊搜索
- **[vim-airline](https://github.com/vim-airline/vim-airline)** - 状态栏
- **[vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)** - 状态栏主题

### 文件管理

- **[NERDTree](https://github.com/preservim/nerdtree)** - 文件浏览器
- **[nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin)** - Git 状态显示
- **[vim-devicons](https://github.com/ryanoasis/vim-devicons)** - 文件图标

### 代码工具

- **[Vista.vim](https://github.com/liuchengxu/vista.vim)** - 代码大纲视图
- **[vim-fugitive](https://github.com/tpope/vim-fugitive)** - Git 集成
- **[vim-gitgutter](https://github.com/airblade/vim-gitgutter)** - Git 差异显示
- **[vim-commentary](https://github.com/tpope/vim-commentary)** - 注释工具

### 主题

- **[gruvbox](https://github.com/morhetz/gruvbox)** - 配色方案（日/夜模式）

## ⌨️ 快捷键

### 快捷键前缀

所有自定义快捷键使用 `<Space>`（空格键）作为 `<leader>`。

### 快捷键列表

#### 文件搜索（FZF）

| 快捷键 | 功能 |
|--------|------|
| `<Space>ff` | 搜索文件（Files） |
| `<Space>fg` | 搜索 Git 文件（GFiles） |
| `<Space>fr` | 搜索内容（Rg，需要 ripgrep） |
| `<Space>fb` | 搜索 Buffer |

#### 侧边栏（Explorer）

| 快捷键 | 功能 |
|--------|------|
| `<Space>ee` | 打开/关闭 NERDTree |
| `<Space>ef` | 在当前文件位置打开 NERDTree |
| `<Space>er` | 刷新 NERDTree 根目录 |

#### 代码大纲（Outline）

| 快捷键 | 功能 |
|--------|------|
| `<Space>oo` | 打开/关闭代码大纲（Vista） |
| `<Space>of` | Vista 符号查找器 |
| `<Space>oc` | 切换到 coc 后端 |
| `<Space>ot` | 切换到 ctags 后端 |

#### 主题切换

| 快捷键 | 功能 |
|--------|------|
| `<Space>tt` | 切换日间/夜间主题 |

#### 折叠（Fold）

| 快捷键 | 功能 |
|--------|------|
| `<Space>zf` | 切换当前折叠（`za`） |

### 原生 Vim 折叠快捷键

| 快捷键 | 功能 |
|--------|------|
| `zc` | 关闭折叠 |
| `zo` | 打开折叠 |
| `za` | 切换折叠 |
| `zR` | 打开所有折叠 |
| `zM` | 关闭所有折叠 |
| `zf` | 创建折叠（visual 模式） |
| `zd` | 删除折叠 |

## 🎨 主题配置

### 日间/夜间主题

配置文件：`config/ui/theme.vim`

默认主题：
- **日间**：`PaperColor`（如果不存在则使用 `retrobox`）
- **夜间**：`gruvbox`（如果不存在则使用 `retrobox`）

### 修改主题

编辑 `config/ui/theme.vim`：

```vim
let g:theme_day = 'your-day-theme'
let g:theme_night = 'your-night-theme'
```

### 自动切换

主题会根据系统时间自动切换（可在 `config/ui/theme.vim` 中配置时间范围）。

## 🔧 配置说明

### 基础设置

- **编码**：UTF-8
- **行号**：绝对行号 + 相对行号
- **缩进**：4 空格（Tab 转换为空格）
- **搜索**：智能大小写匹配
- **鼠标**：全模式启用

### 自动备份

所有备份文件集中管理在 `~/.vim/` 目录下：
- `.backup/` - 备份文件（`.bak`）
- `.swap/` - 交换文件（`.swp`）
- `.undo/` - 撤销历史
- `.view/` - 视图文件

### LSP 配置

配置文件：`coc-settings.json`

支持的语言：
- **Python**（coc-pyright）- 完整的类型检查和代码补全
- **JavaScript/TypeScript**（coc-tsserver）- 已优化配置，支持大型项目
  - 内存上限提升至 4GB
  - 输入时自动格式化
  - 智能导入和自动更新
  - 优化的文件监听性能
- **Vue.js**（coc-vetur）- 完整的 Vue 2 和 Vue 3 支持
  - 语法高亮和自动补全
  - 模板、脚本和样式验证
  - 自动导入和代码片段
  - Prettier 格式化支持
- **Go**（coc-go）- 完整的 Go 语言支持
- **其他语言**（安装对应扩展）

### 自动格式化

保存时自动格式化（在 `coc-settings.json` 中配置）：
- **Python**：支持 black、autopep8、yapf
- **JavaScript/TypeScript**：
  - 保存时自动格式化（Prettier）
  - 输入时自动格式化（formatOnType）
  - 支持 `.prettierrc` 配置文件
- **Vue.js**：
  - 保存时自动格式化（Prettier）
  - 支持 HTML、CSS、JavaScript/TypeScript 格式化
  - 支持 `.prettierrc` 配置文件
- **Go**：使用 goimports

## 🛠️ 自定义配置

### 添加新插件

编辑 `config/plugins/plugins.vim`：

```vim
call plug#begin('~/.vim/plugged')
" ... 现有插件 ...
Plug 'your-plugin/repo'  " 添加新插件
call plug#end()
```

然后执行 `:PlugInstall`。

### 添加快捷键

编辑 `config/mappings/core.vim`，按照现有格式添加：

```vim
" 你的快捷键说明
nnoremap <leader>xx :YourCommand<CR>
```

### 修改主题

编辑 `config/ui/theme.vim`，修改 `g:theme_day` 和 `g:theme_night`。

### 本地配置

创建 `~/.vim/local.vim` 添加个人配置，此文件不会被 Git 跟踪。

## 📝 开发语言支持

### Python

- **LSP**：coc-pyright
- **格式化**：black、autopep8、yapf
- **安装**：`:CocInstall coc-pyright`

### JavaScript/TypeScript

- **LSP**：coc-tsserver（已优化配置）
- **格式化**：Prettier + TypeScript 内置格式化
- **安装**：`:CocInstall coc-tsserver`

**已配置的优化选项**：
- ✅ 启用 TypeScript 语言服务（tsserver）
- ✅ 提升内存上限至 4GB（适用于大型项目）
- ✅ 输入时自动格式化（formatOnType）
- ✅ 优化文件监听性能（使用 FSEvents）
- ✅ 自动更新导入（文件移动/重命名时）
- ✅ 智能导入模块路径（自动/非相对路径）
- ✅ 自动导入 package.json 中的依赖

### Vue.js

- **LSP**：coc-vetur（支持 Vue 2 和 Vue 3）
- **格式化**：Prettier（HTML、CSS、JavaScript/TypeScript）
- **安装**：`:CocInstall coc-vetur`

**已配置的功能**：
- ✅ 语法高亮和自动补全
- ✅ 模板、脚本和样式验证
- ✅ 自动导入模块
- ✅ 代码片段支持
- ✅ 保存时自动格式化
- ✅ 使用工作区依赖项

### Go

- **LSP**：coc-go
- **格式化**：goimports
- **安装**：`:CocInstall coc-go`

### 其他语言

查看可用扩展：`:CocList extensions`

## ❓ 常见问题

### 1. 快捷键不生效

- 确保插件已安装：`:PlugInstall`
- 检查插件是否加载：`:scriptnames`
- 查看错误信息：`:messages`

### 2. Vista 提示需要 ctags

- Vista 默认使用 coc 后端，不需要 ctags
- 只有 Vim 脚本文件类型会使用 ctags
- 如果其他文件类型提示，检查是否安装了对应的 coc 扩展

### 3. LSP 不工作

- 确保安装了对应的 coc 扩展：`:CocList extensions`
- 检查 LSP 服务器状态：`:CocInfo`
- 查看错误信息：`:CocDiagnostics`

### 4. 主题不显示

- 确保主题插件已安装：`:PlugInstall`
- 检查主题名称是否正确：`:colorscheme <Tab>`
- 如果主题不存在，会自动回退到 `retrobox` 或 `default`

### 5. 备份文件太多

备份文件自动保存在 `~/.vim/.backup/`，可以定期清理。

### 6. Windows 路径问题

配置已处理 Windows 路径兼容性，如果遇到问题，检查：
- `shellslash` 设置
- 路径分隔符（`/` vs `\`）

## 🔄 更新配置

```bash
cd ~/.vim
git pull
# 然后重新加载 Vim 配置或重启 Vim
```

更新插件：

```vim
:PlugUpdate
```

更新 coc 扩展：

```vim
:CocUpdate
```

## 📚 相关资源

- [Vim 官方文档](https://www.vim.org/docs.php)
- [vim-plug 文档](https://github.com/junegunn/vim-plug)
- [coc.nvim 文档](https://github.com/neoclide/coc.nvim)
- [fzf.vim 文档](https://github.com/junegunn/fzf.vim)



