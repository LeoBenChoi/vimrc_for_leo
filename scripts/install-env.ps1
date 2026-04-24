# PlugInstall 时异步安装依赖（仅安装系统里不存在的）
# 结构：一级列表套二级列表。每项为 { level1, level2 }，先装 level1 再装其下 level2。优先 choco，否则 winget
# choco/winget 需管理员权限：若未提权则自动请求 UAC 并以管理员重新运行本脚本

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`""
    exit
}

$ErrorActionPreference = 'Stop'

function Test-Command($name) {
    return $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

function Get-InstallCmd($t) {
    if (Test-Command $t.exe) { return $null }
    if ($t.custom) { return $t.custom }
    $useChoco = Test-Command choco
    $useWinget = Test-Command winget
    if ($useChoco -and $t.choco) { return "choco install $($t.choco) -y" }
    if ($useWinget -and $t.winget) { return "winget install $($t.winget) --accept-package-agreements --accept-source-agreements --silent" }
    return $null
}

# 一级套二级：{ level1 = 前置环境, level2 = 该前置下的二级依赖（无则省略 level2） }
$tools = @(
    @{ level1 = @{ exe = 'rg';     choco = 'ripgrep'; winget = 'BurntSushi.ripgrep.MSVC' } },
    @{ level1 = @{ exe = 'ag';     choco = 'ag'; winget = 'JFLarvoire.Ag' } },
    @{
        level1 = @{ exe = 'go';     choco = 'golang'; winget = 'GoLang.Go' }
        level2 = @(
            @{ exe = 'buf'; choco = $null; winget = 'bufbuild.buf' }
        )
    },
    @{
        level1 = @{ exe = 'python'; choco = $null; winget = 'Python.Python.3.12' }
        level2 = @(
            @{ exe = 'ruff'; choco = $null; winget = 'astral-sh.ruff' },
            @{ exe = 'pipx'; custom = 'python -m pip install pipx; if ($?) { python -m pipx ensurepath }' }
        )
    },
    @{ level1 = @{ exe = 'node';   choco = 'nodejs'; winget = 'OpenJS.NodeJS' } }
)

$any = $false
foreach ($group in $tools) {
    $cmd1 = Get-InstallCmd $group.level1
    if ($cmd1) {
        $any = $true
        Invoke-Expression $cmd1
    }
    if ($group.level2) {
        foreach ($t2 in $group.level2) {
            $cmd2 = Get-InstallCmd $t2
            if ($cmd2) {
                $any = $true
                Invoke-Expression $cmd2
            }
        }
    }
}

if (-not $any) {
    Write-Host '[plugins] 列表内工具均已存在，跳过安装。'
}

# 在交互式终端中运行时，结束后不关闭窗口（从 Vim job 调用时跳过）
if ([Environment]::UserInteractive) {
    Read-Host -Prompt '按 Enter 关闭'
}
