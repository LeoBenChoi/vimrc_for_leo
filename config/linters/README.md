# Go Linter 配置文件

此目录包含 Go 语言的 linter 配置文件，用于个人开发环境。

## 配置文件

- `.golangci.yml` - golangci-lint 配置文件
- `revive.toml` - revive linter 配置文件

## 安装工具

### 1. golangci-lint

```bash
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

### 2. govulncheck

```bash
go install golang.org/x/vuln/cmd/govulncheck@latest
```

### 3. gopls (Go 语言服务器)

gopls 会通过 coc-go 扩展自动安装，或手动安装：

```bash
go install golang.org/x/tools/gopls@latest
```

## 使用方法

### 快捷键

- `<leader>gl` - 运行 golangci-lint 检查
- `<leader>gv` - 运行 govulncheck 漏洞检查
- `<leader>gr` - 运行当前 Go 文件
- `<leader>gb` - 构建当前项目
- `<leader>gt` - 运行测试
- `<leader>gf` - 格式化代码
- `<leader>go` - 组织导入

### 命令

- `:GolangciLintPersonal` - 运行 golangci-lint
- `:Govulncheck` - 运行 govulncheck
- `:Format` - 格式化代码
- `:OR` - 组织导入

## 配置优先级

1. 项目配置（`.golangci.yml` 在项目根目录）- 优先级最高
2. 个人配置（`~/.vim/config/linters/.golangci.yml`）- 当项目中没有配置时使用

## LSP 支持

通过 coc.nvim 和 coc-go 扩展提供：
- 代码补全
- 跳转到定义
- 查找引用
- 代码格式化
- 实时诊断
