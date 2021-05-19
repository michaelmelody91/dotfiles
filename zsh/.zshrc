# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/michaelmelody/.oh-my-zsh"
export TERM="xterm-256color"

# Environment Variables
source ~/Repositories/michaelmelody91/dotfiles/.env_vars

# Powerlevel9k
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE='nerdfont-complete'

plugins=(
 git
 jira
 virtualenv
)

zsh_docker_containers(){
    # containers=$(docker ps -q | wc -l)
    # echo -n '\uE7B0 $containers'
    local containers=$(docker ps -q | wc -l | awk '{$1=$1};1')
    local color='%F{blue}'
    if (( $containers > 0 )); then
      echo -n "%{$color%}\uE7B0 $containers%{%f%}" # \uf230 is 
    fi  
}

POWERLEVEL9K_CUSTOM_DOCKER_CONTAINERS="zsh_docker_containers"
POWERLEVEL9K_CUSTOM_DOCKER_CONTAINERS_BACKGROUND="P9KGT_TERMINAL_BACKGROUND"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs custom_docker_containers virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

# Prompt
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

# Set 'dir' segment colors
# https://github.com/bhilburn/powerlevel9k/blob/next/segments/dir/README.md
POWERLEVEL9K_DIR_HOME_BACKGROUND="clear"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="clear"
POWERLEVEL9K_DIR_ETC_BACKGROUND="clear"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="clear"

POWERLEVEL9K_DIR_HOME_FOREGROUND="dodgerblue1"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="dodgerblue1"
POWERLEVEL9K_DIR_ETC_FOREGROUND="dodgerblue1"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="dodgerblue1"

# IP 
POWERLEVEL9K_PUBLIC_IP_BACKGROUND='P9KGT_TERMINAL_BACKGROUND'
POWERLEVEL9K_PUBLIC_IP_FOREGROUND='lightgreen'

# Virtualenv
POWERLEVEL9K_VIRTUALENV_BACKGROUND="clear"
POWERLEVEL9K_VIRTUALENV_FOREGROUND="green"

# VCS

POWERLEVEL9K_VCS_CLEAN_BACKGROUND='clear'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='green'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='clear'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='clear'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='green'

# 
POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS=''

ENABLE_CORRECTION="true"

source $ZSH/oh-my-zsh.sh

# aliases

## zsh
alias z='. ~/.zshrc'
alias zc="v ~/.zshrc"

## Git
alias gfl='git fetch && git pull'
alias gg='git gui &'
alias gcong='git checkout env/nextgen-dev'

## Docker
alias stopcons='docker stop $(docker ps -aq)'
alias removecons='docker rm $(docker ps -a -q)'
alias killcons='stopcons && removecons'
alias cleandock='docker volume prune && docker system prune'

rmimgs() {
  docker images -a | grep "$1" | awk '{print $3}' | xargs docker rmi
}

excdock(){
  docker exec -it "$1" "$2"
}

alias rmdimg='docker rmi $(docker images -f "dangling=true" -q)'

## Directory
alias repos='cd ~/Repositories'
alias mm91='cd ~/Repositories/michaelmelody91'
alias dlds='cd ~/Downloads'

export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
alias ls='ls -lthaG'

alias show-all='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hide-all='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias yml='yq -C r -'
alias j2y='yq r -P -'
alias y2j='yq r --tojson -P -'

alias form='cd /Users/michaelmelody/Repositories/globalization-partners/gp-form-service'
alias ui='cd /Users/michaelmelody/Repositories/globalization-partners/gp-goglobal-ui'
alias setup='cd /Users/michaelmelody/Repositories/globalization-partners/gp-goglobal-dev-setup'
alias flowp='cd /Users/michaelmelody/Repositories/globalization-partners/gp-flow-definition-processor'
alias classic='cd /Users/michaelmelody/Repositories/globalization-partners/gp-go-global'

## Open apps
alias ij='idea .'
alias subl="sublime ."
alias vc='code .'
alias ghd='github .'

## IP
alias ip='curl ifconfig.io'
alias localip='ipconfig getifaddr en0'

## Python
alias activate='. venv/bin/activate'

## AWS
alias lamb='sam build && sam local invoke SpotifyPlayHistoryListener  --event events/event.json'

## Java
initmvn(){
  mkdir -p src/main/java
  mkdir -p src/main/resources
  mkdir -p src/test/java
  mkdir -p src/test/resources
}

jdk() {
  version=$1
  export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
  java -version
}

## Brew
alias services='brew services list'

## Bash
sh_script(){
  touch "$1"
  chmod 777 "$1"
  echo '#!/bin/sh' > "$1"
}

# Grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Fuzzy file finder
alias v='nvim'
alias f='v `fzf -i`'

# Functions
hist(){
  history | grep -i -w "$1"
}

mkd(){
  mkdir -p "$1"
  cd "$1"
}

sonar(){
  if [ "$(docker ps -a | grep sonarqube)" ]; then
    if [ ! "$(docker ps | grep sonarqube)" ]; then
        echo 'starting already existing sonarqube instance...'
        docker start sonarqube
    else
      echo 'Already running, idiot!'
    fi
  else
    echo 'starting sonarqube...'
    docker run -d --name sonarqube -p 9000:9000 sonarqube
  fi
}

port(){
  lsof -P -iTCP:"$1"
}

# Swagger/OpenAPI

swgedit() {
  if [ "$(docker ps -a | grep swagger-editor)" ]; then
    if [ ! "$(docker ps | grep swagger-editor)" ]; then
        echo 'starting already existing swagger-editor...'
        docker start swagger-editor && open http://localhost
    else
      open http://localhost
    fi
  else
    echo 'starting swagger-editor...'
    docker run -d -p 80:8080 -d --name swagger-editor swaggerapi/swagger-editor && open http://localhost
  fi
}

work() {
  company=$(gh api graphql -f query='query MyQuery {
    user(login: "michaelmelody91") {
      company
    }
  }
  ' | jq '.data.user.company')
  company=${company:2:-2}
  cd ~/Repositories/$company
}

# https://github.com/mathiasbynens/dotfiles/blob/master/.aliases - Inspo
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "${method}"="curl -X "${method}""
done

# Super top secret things I don't want the outside world to see!
source ~/Repositories/michaelmelody91/dotfiles/.secret_stuff

# NVM
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# Jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# trash-cli
alias rm=trash

# node
alias db='export DEBUG=*'
alias dbo='export DEBUG='

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true
