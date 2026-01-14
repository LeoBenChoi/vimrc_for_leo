# Vim 配置文件目录结构说明

本目录结构严格按照 Vim 官方推荐的标准目录结构创建。

## 目录说明

### `autoload/`
**作用**：存放自动加载脚本  
**说明**：此目录中的脚本只有在被调用时才会加载，可以延迟加载以提高 Vim 启动速度。通常用于存放插件的自动加载函数。

### `colors/`
**作用**：存放颜色方案文件  
**说明**：存放 `.vim` 格式的颜色主题文件。使用 `:colorscheme <name>` 命令可以切换颜色方案。

### `compiler/`
**作用**：存放编译器定义文件  
**说明**：定义不同编译器的错误格式，使 Vim 能够正确解析编译错误信息，便于快速定位错误位置。

### `doc/`
**作用**：存放文档文件  
**说明**：存放插件的帮助文档（`.txt` 格式）。使用 `:help` 命令可以查看这些文档。

### `ftplugin/`
**作用**：存放文件类型特定插件  
**说明**：针对特定文件类型的配置和插件。例如 `python.vim` 只对 Python 文件生效。每个文件类型可以有独立的配置文件。

### `indent/`
**作用**：存放缩进脚本  
**说明**：定义不同文件类型的缩进规则。例如 `python.vim` 定义 Python 文件的缩进方式。

### `keymap/`
**作用**：存放键盘映射文件  
**说明**：定义不同键盘布局的映射关系，支持多语言键盘布局。

### `plugin/`
**作用**：存放插件脚本  
**说明**：存放全局插件脚本，这些脚本在 Vim 启动时自动加载。适合存放通用的插件和配置。

### `syntax/`
**作用**：存放语法高亮文件  
**说明**：定义不同文件类型的语法高亮规则。例如 `python.vim` 定义 Python 代码的语法高亮。

### `after/`
**作用**：存放后加载脚本  
**说明**：此目录结构与主目录结构相同（如 `after/ftplugin/`、`after/syntax/` 等），用于覆盖系统默认设置或插件设置。脚本在此目录中会在系统默认配置之后加载。

### `pack/`
**作用**：存放包管理目录（Vim 8+）  
**说明**：Vim 8.0+ 引入的包管理系统目录。可以按照 `pack/<name>/start/<plugin>` 或 `pack/<name>/opt/<plugin>` 的结构组织插件，支持自动加载和按需加载。

## 配置文件位置说明

### 主配置文件：`vimrc.vim`
**作用**：Vim 的主配置文件，存放所有通用配置  
**说明**：这是 Vim 配置的核心文件，应该包含：
- 基本设置（如 `set number`、`set tabstop=4` 等）
- **字体配置**（GUI 模式下的字体设置）
- 键位映射
- 插件配置
- 其他通用设置

**字体配置示例**：
```vim
" GUI 字体配置（仅 GUI 模式生效）
if has('gui_running')
    " Windows 字体配置
    if has('win32') || has('win64')
        set guifont=Consolas:h12
    " Linux 字体配置
    elseif has('unix')
        set guifont=DejaVu\ Sans\ Mono\ 12
    " macOS 字体配置
    elseif has('mac')
        set guifont=Menlo:h14
    endif
endif
```

**注意**：
- 字体配置使用 `guifont` 选项，仅对 GUI 版本的 Vim（如 gvim）生效
- 终端版本的 Vim 字体由终端模拟器控制，无法通过 Vim 配置
- 字体名称中的空格需要用反斜杠转义或使用下划线
- 使用 `has('gui_running')` 条件判断确保只在 GUI 模式下设置

### 替代方案：`after/plugin/gui_settings.vim`
**作用**：GUI 特定设置的独立配置文件  
**说明**：如果希望将 GUI 相关配置独立管理，可以创建 `after/plugin/gui_settings.vim` 文件，这样可以在所有插件加载后再应用 GUI 设置。

## 插件配置文件

### WakaTime 配置：`.wakatime.cfg`
**作用**：WakaTime 编码时间统计插件的配置文件  
**位置**：`~/.vim/.wakatime.cfg`  
**说明**：
- 首次使用需要从模板文件 `.wakatime.cfg.example` 复制并配置 API Key
- 获取 API Key：https://wakatime.com/settings/api-key
- 配置文件包含隐私保护选项，可以混淆文件名、项目名和路径
- 详细配置说明请参考 `.wakatime.cfg.example` 文件中的注释

**隐私保护选项**：
- `hide_file_names = true` - 混淆文件名（显示为 HIDDEN.ext）
- `hide_project_names = true` - 混淆项目名称（使用随机字符串）
- `hide_project_folder = true` - 隐藏项目文件夹路径（只发送相对路径）

**注意**：`.wakatime.cfg` 文件已加入 `.gitignore`，不会提交到 Git 仓库。

## 使用建议

1. **插件管理**：推荐使用 `pack/` 目录或插件管理器（如 vim-plug、Vundle）来管理插件
2. **文件类型配置**：将特定文件类型的配置放在 `ftplugin/` 目录
3. **覆盖系统设置**：需要覆盖系统默认设置时，使用 `after/` 目录
4. **性能优化**：将可以延迟加载的脚本放在 `autoload/` 目录
5. **字体配置**：**推荐放在主配置文件 `vimrc.vim` 中**，使用 `has('gui_running')` 条件判断
6. **WakaTime 配置**：复制 `.wakatime.cfg.example` 为 `.wakatime.cfg` 并填入 API Key

## 参考

- Vim 官方文档：`:help runtimepath`
- Vim 官方文档：`:help packages`
