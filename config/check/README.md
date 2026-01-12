# 环境检查配置

本目录包含各种开发环境的检查和安装配置。

## 设计原则

1. **手动触发**：所有检查和安装操作都需要手动触发，不会自动执行，避免影响 Vim 启动性能
2. **命令命名规范**：
   - **检查命令**：以 `Check` 开头，如 `CheckGoLSP`、`CheckGo`、`CheckGopls`
   - **安装命令**：以 `Install` 开头，如 `InstallGoLSP`、`InstallGopls`、`InstallCocGo`

## Go LSP 环境检查

### 检查命令

- `:CheckGo` - 检查 Go 是否已安装
- `:CheckGopls` - 检查 gopls 是否已安装（包括 PATH 和 Go bin 目录）
- `:CheckCocGo` - 检查 coc-go 扩展是否已安装
- `:CheckGoLSP` - 完整检查 Go LSP 环境（包括上述所有检查）

### 安装命令

- `:InstallGopls` - 安装 gopls（如果未安装）
- `:InstallCocGo` - 安装 coc-go 扩展（如果未安装）
- `:InstallGoLSP` - 自动安装完整的 Go LSP 环境

### 快捷键

- `<leader>gc` - 检查 Go LSP 环境（`:CheckGoLSP`）
- `<leader>gi` - 安装 Go LSP 环境（`:InstallGoLSP`）

### 使用示例

```vim
" 检查 Go LSP 环境
:CheckGoLSP

" 如果缺少组件，使用安装命令
:InstallGoLSP

" 或者单独安装
:InstallGopls
:InstallCocGo
```

### 检查内容

- **Go 环境**：检查 Go 是否已安装，显示版本和 GOPATH/GOBIN 信息
- **gopls**：检查 gopls 是否在 PATH 中，或位于 Go bin 目录中
- **coc-go 扩展**：检查 coc.nvim 的 coc-go 扩展是否已安装

### 注意事项

1. 所有检查都是手动触发，不会自动执行
2. 安装 gopls 需要先安装 Go
3. 安装 coc-go 需要先安装 coc.nvim 插件
4. 如果 gopls 不在 PATH 中，安装后会提示 Go bin 目录位置

## FZF 环境检查

### 检查命令

- `:CheckFzf` - 检查 fzf 是否已安装
- `:CheckRipgrep` - 检查 ripgrep (rg) 是否已安装
- `:CheckAg` - 检查 ag (The Silver Searcher) 是否已安装
- `:CheckFzfEnv` - 完整检查 FZF 环境（包括上述所有检查）

### 安装命令

- `:InstallFzf` - 安装 fzf（如果未安装）
- `:InstallRipgrep` - 安装 ripgrep（如果未安装，推荐）
- `:InstallAg` - 安装 ag（如果未安装，备用）
- `:InstallFzfEnv` - 自动安装完整的 FZF 环境

### 使用示例

```vim
" 检查 FZF 环境
:CheckFzfEnv

" 如果缺少组件，使用安装命令
:InstallFzfEnv

" 或者单独安装
:InstallFzf
:InstallRipgrep
```

### 检查内容

- **fzf**：检查 fzf 可执行文件和 fzf.vim 插件是否已安装
- **ripgrep (rg)**：检查 ripgrep 是否已安装（推荐搜索工具）
- **ag**：检查 ag 是否已安装（备用搜索工具）

### 支持的平台和包管理器

#### Windows
- Chocolatey (`choco`)
- Scoop (`scoop`)
- winget (`winget`)

#### Mac
- Homebrew (`brew`)

#### Linux
- apt-get (Debian/Ubuntu)
- yum (CentOS/RHEL)
- pacman (Arch Linux)

### 注意事项

1. 所有检查都是手动触发，不会自动执行
2. FZF 需要至少一个搜索工具（ripgrep 或 ag）才能正常工作
3. 推荐使用 ripgrep（性能更好）
4. 如果系统没有包管理器，会提示手动安装链接
5. 某些安装命令可能需要管理员权限（sudo）
