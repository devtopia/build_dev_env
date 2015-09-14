export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi

# Tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad
# if background color is black
# export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

# for oracle instant client
export ORACLE_HOME=/usr/local/instantclient_11_2
export DYLD_LIBRARY_PATH=$ORACLE_HOME
export PATH=$ORACLE_HOME:$PATH
export NLS_LANG=Japanese_Japan.AL32UTF8
export NLS_DATE_FORMAT="YYYY/MM/DD HH24:MI:SS"
export TNS_ADMIN=$ORACLE_HOME/network/admin/tnsnames.ora

export EDITOR=vim
export LANG=ja_JP.UTF-8

alias ll='ls -alhF'
alias vi='vim'
alias sudo='sudo -E '
alias sqlplus='rlwrap sqlplus'
