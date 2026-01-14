# Vim 配置

一个功能完整、高度可定制的 Vim 配置文件，适用于 Windows、Linux 和 macOS 系统。本配置遵循 Vim 官方推荐的标准目录结构，提供现代化的开发体验。

## ✨ 功能特性

### 🎨 界面美化
- **现代化主题**：支持多种颜色方案（GUI 和终端模式自适应）
- **状态栏**：vim-airline 提供美观的状态栏，显示文件信息、Git 状态等
- **彩虹括号**：自动为匹配的括号着色，提高代码可读性
- **光标高亮**：自动高亮当前光标下的单词
- **图标支持**：NERDTree 和状态栏支持文件类型图标

### 💻 开发工具
- **LSP 支持**：基于 coc.nvim 的完整语言服务器协议支持
  - 智能代码补全
  - 实时错误检查
  - 代码跳转和引用查找
  - 代码格式化
- **多语言支持**：通过 vim-polyglot 支持 120+ 种编程语言
- **代码片段**：coc-snippets 提供代码片段功能
- **代码大纲**：Vista.vim 提供代码结构树形视图

### 🔍 导航与搜索
- **模糊搜索**：FZF 提供强大的文件、内容、历史记录搜索
- **文件树**：NERDTree 提供侧边栏文件浏览器
- **快速跳转**：支持符号跳转、定义查找等功能

### 🔧 Git 集成
- **Git 三剑客**：
  - `vim-fugitive`：完整的 Git 命令集成
  - `vim-gitgutter`：实时显示 Git 变更标记
  - `gv.vim`：可视化的 Git 提交历史
- **快捷键支持**：一键查看状态、差异、提交历史等

### ⏱️ 编码统计
- **WakaTime 集成**：自动跟踪编码时间，生成详细的编码活动报告
- **隐私保护**：支持混淆文件名、项目名等隐私选项

### 🎯 其他特性
- **快速注释**：vim-commentary 提供便捷的注释切换
- **代码对齐**：vim-easy-align 提供强大的对齐功能
- **启动界面**：vim-startify 提供美观的启动界面和会话管理
- **跨平台支持**：Windows、Linux、macOS 统一配置

## 📋 系统要求

- **Vim 版本**：8.0 或更高版本（推荐 8.2+）
- **Node.js**：14.0 或更高版本（coc.nvim 需要）
- **Git**：用于插件管理和 Git 功能
- **Python 3**：部分 LSP 服务器需要（可选）

## 🚀 快速开始

```bash
# 克隆配置到 ~/.vim
git clone https://github.com/LeoBenChoi/vimrc_for_leo.git ~/.vim

# 复制 .vimrc 到上一级目录
cd ~/.vim
cp .vimrc ../

# 启动 Vim，安装插件
vim
:PlugInstall
```

安装完成后重启 Vim 即可正常使用。coc.nvim 扩展会自动安装（配置在 `after/plugin/coc.vim` 中）。

### 可选配置

**WakaTime 编码统计**（可选）：

WakaTime 插件在 `:PlugInstall` 安装后会自动生成配置文件 `~/.vim/.wakatime.cfg`。首次使用需要：

1. 编辑 `~/.vim/.wakatime.cfg`，填入你的 API Key（获取地址：https://wakatime.com/settings/api-key）
2. 如需设置隐私级别，可参考 `~/.vim/.wakatime.cfg.example` 文件最下方的配置建议，复制相应的隐私选项到配置文件中

## ⚙️ 配置说明

### 目录结构

```
~/.vim/
├── .vimrc                 # 入口文件（符号链接）
├── vimrc.vim              # 主配置文件
├── .gitignore             # Git 忽略文件
├── coc-settings.json      # coc.nvim 配置
├── .wakatime.cfg.example  # WakaTime 配置模板
│
├── plugin/                # 全局插件配置（启动时自动加载）
│   ├── options.vim        # 基础选项配置
│   ├── keymaps.vim        # 键位映射
│   └── ui.vim             # UI、主题和字体配置
│
├── after/plugin/          # 后加载插件配置（插件加载后执行）
│   ├── coc.vim            # coc.nvim 配置
│   ├── git.vim            # Git 插件配置
│   ├── nerdtree.vim       # NERDTree 配置
│   ├── airline.vim        # Airline 配置
│   └── ...
│
├── ftplugin/              # 文件类型特定配置
│   ├── go.vim             # Go 语言配置
│   ├── python.vim         # Python 配置
│   ├── javascript.vim     # JavaScript 配置
│   └── ...
│
├── autoload/              # 自动加载脚本
│   └── plug.vim           # vim-plug 插件管理器
│
└── plugged/               # 插件安装目录（自动生成）
```

### 主要配置文件

- **`vimrc.vim`**：主配置文件，包含插件列表和基础设置
- **`plugin/options.vim`**：基础选项（行号、缩进、搜索等）
- **`plugin/keymaps.vim`**：自定义快捷键映射
- **`plugin/ui.vim`**：主题、字体和界面设置
- **`after/plugin/coc.vim`**：LSP 和代码补全配置
- **`after/plugin/git.vim`**：Git 相关插件配置

### 自定义配置

所有配置文件都支持自定义修改：

1. **修改主题**：编辑 `plugin/ui.vim`，修改颜色方案列表
2. **修改字体**：编辑 `plugin/ui.vim`，修改 `guifont` 设置
3. **添加插件**：编辑 `vimrc.vim`，在 `plug#begin()` 和 `plug#end()` 之间添加 `Plug` 命令
4. **修改快捷键**：编辑 `plugin/keymaps.vim`
5. **添加文件类型配置**：在 `ftplugin/` 目录下创建对应的 `.vim` 文件

## ⌨️ 快捷键说明

### Leader 键

默认 Leader 键为 `<Space>`（空格键）

### 基础操作

| 快捷键 | 功能 |
|--------|------|
| `<Leader><Leader>` | 取消搜索高亮 |
| `<Leader>w` | 保存文件 |
| `<Leader>W` | 强制保存 |
| `<Leader>q` | 退出 |
| `<Leader>Q` | 强制退出 |
| `<Leader>x` | 保存并退出 |
| `jk` | 退出插入模式（插入模式） |

### 窗口导航

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+h/j/k/l` | 在窗口间导航 |
| `<Leader>+/-` | 增加/减少窗口高度 |
| `<Leader>>/<` | 增加/减少窗口宽度 |

### 缓冲区操作

| 快捷键 | 功能 |
|--------|------|
| `<Leader>bp` | 上一个缓冲区 |
| `<Leader>bn` | 下一个缓冲区 |
| `<Leader>bd` | 删除当前缓冲区 |

### 文件导航

| 快捷键 | 功能 |
|--------|------|
| `<Leader>f` | FZF 文件搜索 |
| `<Leader>b` | FZF 缓冲区搜索 |
| `<Leader>rg` | FZF 内容搜索（ripgrep） |
| `<Leader>t` | NERDTree 切换 |

### Git 操作

| 快捷键 | 功能 |
|--------|------|
| `<Leader>gs` | Git 状态 |
| `<Leader>gb` | Git Blame |
| `<Leader>gd` | Git Diff |
| `<Leader>gl` | Git 提交历史 |
| `<Leader>gf` | 当前文件提交历史 |
| `]c` / `[c` | 下一个/上一个变更 |
| `<Leader>hp` | 预览变更 |
| `<Leader>hu` | 撤销变更 |
| `<Leader>hs` | 暂存变更 |

### 代码编辑

| 快捷键 | 功能 |
|--------|------|
| `gcc` | 注释/取消注释当前行 |
| `gc` | 注释/取消注释选中区域 |
| `ga` | 对齐文本（vim-easy-align） |
| `F3` | 切换粘贴模式 |

### LSP 操作（coc.nvim）

| 快捷键 | 功能 |
|--------|------|
| `gd` | 跳转到定义 |
| `gy` | 跳转到类型定义 |
| `gi` | 跳转到实现 |
| `gr` | 查找引用 |
| `K` | 显示文档 |
| `<Leader>rn` | 重命名符号 |
| `<Leader>f` | 格式化代码 |
| `[g` / `]g` | 上一个/下一个诊断错误 |

### 配置编辑

| 快捷键 | 功能 |
|--------|------|
| `<Leader>ev` | 打开 vimrc.vim |
| `<Leader>sv` | 重新加载配置 |

## 📦 插件列表

### 基础与配置
- **vim-sensible**：合理的默认配置
- **vim-commentary**：快速注释工具

### 界面美化
- **seoul256.vim**：颜色主题
- **vim-airline**：状态栏
- **vim-airline-themes**：状态栏主题
- **rainbow**：彩虹括号
- **vim-cursorword**：光标单词高亮
- **vim-devicons**：文件图标支持

### 开发工具
- **vim-polyglot**：多语言语法高亮和缩进支持
- **coc.nvim**：LSP 客户端，提供智能补全和代码分析
- **vim-easy-align**：代码对齐工具

### 导航与搜索
- **fzf** / **fzf.vim**：模糊搜索工具
- **vista.vim**：代码结构大纲
- **nerdtree**：文件树浏览器

### Git 集成
- **vim-fugitive**：Git 命令集成
- **vim-gitgutter**：Git 变更标记
- **gv.vim**：Git 提交历史可视化

### 其他
- **vim-startify**：启动界面和会话管理
- **vim-wakatime**：编码时间统计

## 🔧 常见问题

### Q: 如何更新插件？

```vim
:PlugUpdate
```

### Q: 如何删除插件？

1. 从 `vimrc.vim` 中删除对应的 `Plug` 行
2. 执行 `:PlugClean` 清理未使用的插件

### Q: coc.nvim 无法正常工作？

1. 确保已安装 Node.js（版本 14+）
2. 执行 `:checkhealth` 检查健康状态
3. 查看 `:CocInfo` 获取详细信息
4. 确保已安装对应的 LSP 扩展

### Q: 如何切换颜色主题？

编辑 `plugin/ui.vim`，修改颜色方案列表，或直接在 Vim 中执行：

```vim
:colorscheme <theme-name>
```

### Q: Windows 下字体显示异常？

1. 确保已安装对应字体（如 Maple Mono NL NF Mono CN）
2. 编辑 `plugin/ui.vim`，修改 `guifont` 设置
3. 字体名称中的空格需要用下划线或反斜杠转义

### Q: 如何禁用某个插件？

在 `vimrc.vim` 中注释掉对应的 `Plug` 行，然后执行：

```vim
:PlugClean
```

### Q: 启动速度慢？

1. 使用 `:PlugUpdate` 更新所有插件
2. 检查是否有插件冲突
3. 使用 `:profile start profile.log` 和 `:profile func *` 分析启动时间

## 📝 文件类型配置

项目支持多种文件类型的特定配置，位于 `ftplugin/` 目录：

- **Go**：`ftplugin/go.vim`
- **Python**：`ftplugin/python.vim`
- **JavaScript/TypeScript**：`ftplugin/javascript.vim`、`ftplugin/typescript.vim`
- **HTML/CSS**：`ftplugin/html.vim`、`ftplugin/css.vim`
- **JSON/YAML**：`ftplugin/json.vim`、`ftplugin/yaml.vim`

每个文件类型可以有自己的缩进、格式化和其他特定设置。

## 🎨 主题和字体

### 颜色主题

配置支持多种颜色主题，会根据运行模式（GUI/终端）自动选择：

- **GUI 模式**：retrobox, desert, solarized, molokai, gruvbox, onedark, dracula, tokyonight
- **终端模式**：seoul256, retrobox, desert

### 字体配置

**推荐字体**：**Maple Mono NL NF Mono CN**，支持中英文混排。

**建议**：自行编译半角宽度的带图标字体，以获得更好的图标显示效果（如 NERDTree 和状态栏图标）。

可以根据需要修改 `plugin/ui.vim` 中的字体设置。

## 🔒 隐私和安全

- **WakaTime 配置**：`.wakatime.cfg` 文件包含 API Key，已加入 `.gitignore`，不会提交到仓库
- **本地配置**：所有个人配置和数据文件都在 `~/.vim` 目录下，便于统一管理
- **备份文件**：默认禁用备份和交换文件，减少文件系统混乱

## 📚 参考资源

- [Vim 官方文档](https://www.vim.org/docs.php)
- [vim-plug 文档](https://github.com/junegunn/vim-plug)
- [coc.nvim 文档](https://github.com/neoclide/coc.nvim)
- [Vim 运行时路径](http://vimdoc.sourceforge.net/htmldoc/options.html#'runtimepath')

---


