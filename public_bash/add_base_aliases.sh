#!/bin/bash

# 定义用户主目录下的 .bash_aliases 文件路径
ALIAS_FILE="$HOME/.bash_aliases"

# 使用 heredoc 定义要添加的别名块
read -r -d '' ALIAS_BLOCK <<'EOF'

### base ###
alias sc='screen -h 100000 -d -U -R'
alias g='git'
alias gr='git remote -v'
alias gp='git pull'
alias s='git status --short'
alias d='git diff'
alias mp='git commit -am "Some processing optimization" && git push'
alias dk='docker'
alias dke='docker exec -it $(docker ps -q | head -n1) bash'
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

# 检查 .bash_aliases 文件是否不存在
if [ ! -f "$ALIAS_FILE" ]; then
    echo "文件 $ALIAS_FILE 未找到，正在创建..."
    echo "$ALIAS_BLOCK" > "$ALIAS_FILE"
    echo "别名已添加到新文件中。"
# 如果文件存在，则检查基础别名是否已在其中
elif ! grep -q "### base ###" "$ALIAS_FILE"; then
    echo "文件 $ALIAS_FILE 已存在，但未找到基础别名。正在追加..."
    # 在别名块之前追加一个空行，使文件更整洁
    echo "" >> "$ALIAS_FILE"
    echo "$ALIAS_BLOCK" >> "$ALIAS_FILE"
    echo "别名已追加完毕。"
else
    echo "基础别名已存在于 $ALIAS_FILE 中。未执行任何操作。"
fi

echo "脚本执行完毕。请运行 'source ~/.bash_aliases' 或新开一个终端来应用更改。"