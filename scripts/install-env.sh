#!/usr/bin/env sh
# PlugInstall 时异步安装依赖（仅安装系统里不存在的）
# 修改下方 TOOLS 即可增删；按 apt / brew / pacman 自动选择

command -v rg      >/dev/null 2>&1 || need_rg=1
command -v ag      >/dev/null 2>&1 || need_ag=1
command -v go      >/dev/null 2>&1 || need_go=1
command -v python >/dev/null 2>&1 || command -v python3 >/dev/null 2>&1 || need_py=1
command -v node   >/dev/null 2>&1 || need_node=1
command -v buf    >/dev/null 2>&1 || need_buf=1
command -v ruff   >/dev/null 2>&1 || need_ruff=1
command -v pipx   >/dev/null 2>&1 || need_pipx=1

install_apt() {
  [ -n "$need_rg" ]  && sudo apt-get install -y ripgrep
  [ -n "$need_ag" ]  && sudo apt-get install -y silversearcher-ag
  [ -n "$need_go" ]  && sudo apt-get install -y golang-go
  [ -n "$need_py" ]  && sudo apt-get install -y python3 python3-pip
  [ -n "$need_node" ] && sudo apt-get install -y nodejs npm
  [ -n "$need_ruff" ] && sudo apt-get install -y ruff
  [ -n "$need_pipx" ] && python3 -m pip install --user pipx && python3 -m pipx ensurepath
  command -v buf >/dev/null 2>&1 || go install github.com/bufbuild/buf/cmd/buf@latest
}

install_brew() {
  [ -n "$need_rg" ]  && brew install ripgrep
  [ -n "$need_ag" ]  && brew install the_silver_searcher
  [ -n "$need_go" ]  && brew install go
  [ -n "$need_py" ]  && brew install python
  [ -n "$need_node" ] && brew install node
  [ -n "$need_buf" ] && brew install buf
  [ -n "$need_ruff" ] && brew install ruff
  [ -n "$need_pipx" ] && brew install pipx && pipx ensurepath
}

install_pacman() {
  [ -n "$need_rg" ]  && sudo pacman -S --noconfirm ripgrep
  [ -n "$need_ag" ]  && sudo pacman -S --noconfirm the_silver_searcher
  [ -n "$need_go" ]  && sudo pacman -S --noconfirm go
  [ -n "$need_py" ]  && sudo pacman -S --noconfirm python python-pip
  [ -n "$need_node" ] && sudo pacman -S --noconfirm nodejs npm
  [ -n "$need_buf" ] && sudo pacman -S --noconfirm buf
  [ -n "$need_ruff" ] && sudo pacman -S --noconfirm ruff
  [ -n "$need_pipx" ] && python -m pip install --user pipx && pipx ensurepath
}

run_install() {
  if command -v apt-get >/dev/null 2>&1; then install_apt
  elif command -v brew >/dev/null 2>&1; then install_brew
  elif command -v pacman >/dev/null 2>&1; then install_pacman
  else echo '[plugins] 未检测到 apt/brew/pacman，请手动安装依赖。'; exit 1
  fi
}

[ -n "$need_rg$need_ag$need_go$need_py$need_node$need_buf$need_ruff$need_pipx" ] || { echo '[plugins] 列表内工具均已存在，跳过安装。'; exit 0; }
run_install
