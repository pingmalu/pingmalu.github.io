#!/bin/bash
# bash <(curl -fsSL https://raw.githubusercontent.com/pingmalu/pingmalu.github.io/master/public_bash/add_base_aliases.sh)
# bash <(curl -fsSL https://gh-proxy.com/https://raw.githubusercontent.com/pingmalu/pingmalu.github.io/master/public_bash/add_base_aliases.sh)
export LC_ALL=C.UTF-8
# 定义基础别名块的全局版本号
BASE_ALIAS_VERSION="v20251023"

# 定义用户主目录下的 .bash_aliases 文件路径
ALIAS_FILE="$HOME/.bash_aliases"

# 使用 heredoc 定义要添加的别名块，头部带版本号
read -r -d '' ALIAS_HEADER <<EOF

### base $BASE_ALIAS_VERSION ###
EOF

read -r -d '' ALIAS_BODY <<'EOF'
if [ "$(uname)" = "Linux" ]; then
    alias n='netstat -lntp'
    alias ig='ifconfig'
else
    alias n='netstat -na -p TCP|grep 0.0.0.0|grep -v " 1"'
    alias ig='ipconfig'
fi
tm() {
  if [ "$1" = "ls" ]; then
    tmux ls
  else
    tmux attach -t "$1" || tmux new -s "$1"
  fi
}
alias sc='screen -h 100000 -d -U -R'
alias g='git'
alias gr='git remote -v'
alias gp='git pull'
alias s='git status --short'
alias d='git diff'
alias mp='git commit -am "Some processing optimization" && git push'
alias dk='docker'
alias dke='docker exec -it $(docker ps -q | head -n1) sh -c '\''if command -v bash >/dev/null 2>&1; then bash; else sh; fi'\'
alias dk2='docker exec -it $(docker ps -q | head -n2|tail -n1) bash'
alias dk3='docker exec -it $(docker ps -q | head -n3|tail -n1) bash'
alias p='pwd'
alias pi='ping'
alias h="printf '\\e]0;%s\\e\\\\' `hostname` && hostname"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls -hFG'
alias l='ls -lFah'
alias ll='ls -alF'
alias lt='ls -ltrF'
alias lls='ls -alSrF'
alias llt='ls -altrF'
alias tarc='tar cvf'
alias tarcz='tar czvf'
alias tarx='tar xvf'
alias tarxz='tar xvzf'
alias less='less -R'
alias os='lsb_release -a'
alias vi='vim'
alias ls="ls -ph --color=auto"
alias grep="grep --color=auto"
### base_end ###
EOF

# 拼接段
ALIAS_BLOCK="${ALIAS_HEADER}
${ALIAS_BODY}"

# 检查 .bash_aliases 文件是否不存在
if [ ! -f "$ALIAS_FILE" ]; then
    echo "文件 $ALIAS_FILE 未找到，正在创建..."
    echo "$ALIAS_BLOCK" > "$ALIAS_FILE"
    echo "别名已添加到新文件中。"
else
    # 检查是否存在 base 块及其版本号
    EXISTING_VERSION=$(grep -oE '### base .* ###' "$ALIAS_FILE" | head -n1 | grep -oP '(?<=### base ).*(?= ###)')
    if [ -z "$EXISTING_VERSION" ]; then
        echo "未检测到基础别名块，正在追加..."
        echo "" >> "$ALIAS_FILE"
        echo "$ALIAS_BLOCK" >> "$ALIAS_FILE"
        echo "别名已追加完毕。"
    elif [ "$EXISTING_VERSION" != "$BASE_ALIAS_VERSION" ]; then
        echo "检测到版本不一致，正在替换旧的基础别名块..."
        # 用 sed 删除旧的 base 块（含头尾）
        sed -i.bak "/### base .* ###/,/### base_end ###/d" "$ALIAS_FILE"
        echo "" >> "$ALIAS_FILE"
        echo "$ALIAS_BLOCK" >> "$ALIAS_FILE"
        echo "基础别名块已更新为新版本。"
    else
        echo "基础别名块版本一致，无需更新。"
    fi
fi

echo "脚本执行完毕。请运行 'source ~/.bash_aliases' 或新开一个终端来应用更改。"