# -------------------------------------
# コマンド履歴を保存する。
# -------------------------------------

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# -------------------------------------
# zshのオプション
# -------------------------------------

# 補完機能の強化
autoload -Uz compinit; compinit

# 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# ビープを鳴らさない。
setopt no_beep

# 色を使う。
setopt prompt_subst

# ^Dでログアウトしない。
setopt ignore_eof

# ^Q/^Sのフローコントロールを無効にする。
setopt no_flow_control

# バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

# 直前と同じコマンドをヒストリに追加しない。
setopt hist_ignore_dups

# 補完
# タブによるファイルの順番切り替えをする。
setopt auto_menu

# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする。
setopt auto_pushd

# ディレクトリ名を入力するだけでcdできるようにする。
setopt auto_cd

# -------------------------------------
# パス
# -------------------------------------

# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

# -------------------------------------
# プラグイン
# -------------------------------------

autoload -Uz history-search-end
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
autoload -Uz zmv
autoload -Uz promptinit; promptinit
autoload -Uz colors; colors
autoload -Uz vcs_info
autoload -Uz is-at-least

# メニュー選択モード
zstyle ":completion:*:default" menu select=2

# 大文字と小文字を区別しない
zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}"

# cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 200
zstyle ':chpwd:*' recent-dirs-default true

# begin VCS
zstyle ":vcs_info:*" enable git svn hg bzr
zstyle ":vcs_info:*" formats "%F{green}(%s)-[%b]%f"
zstyle ":vcs_info:*" actionformats "%F{red}(%s)-[%b|%a]%f"
zstyle ":vcs_info:(svn|bzr):*" branchformat "%b:r%r"
zstyle ":vcs_info:bzr:*" use-simple true
zstyle ":vcs_info:*" max-exports 6

if is-at-least 4.3.10; then
  zstyle ":vcs_info:git:*" check-for-changes true # commitしていないのをチェック
  zstyle ":vcs_info:git:*" stagedstr "<S>"
  zstyle ":vcs_info:git:*" unstagedstr "<U>"
  zstyle ":vcs_info:git:*" formats "%F{green}(%s)-[%b] %c%u%f"
  zstyle ":vcs_info:git:*" actionformats "%F{red}(%s)-[%b|%a] %c%u%f"
fi

function _update_vcs_info_msg() {
  LANG=en_US.UTF-8 vcs_info
  RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg
# end VCS

# -------------------------------------
# プロンプト
# -------------------------------------

preexec() {
  echo -ne "\ek$1\e\\"
}
precmd() {
  echo -ne "\ek$(basename $SHELL)\e\\"
}
PROMPT="%(?.%{${fg_bold[green]}%}.%{${fg_bold[red]}%})[%n@%m:%~]%{${reset_color}%} %# "

# -------------------------------------
# エイリアス
# -------------------------------------

# -n 行数表示, -I バイナリファイル無視, svn関係のファイルを無視
alias grep="grep --color -n -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"

# ls
alias ls="ls -G" # color for darwin
alias l="ls -la"
alias la="ls -la"
alias l1="ls -1"

# tree
alias tree="tree -NC" # N: 文字化け対策, C:色をつける

# zmv
alias zmv="noglob zmv -W"

# -------------------------------------
# キーバインド
# -------------------------------------

bindkey -v

function cdup() {
  echo
  cd ..
  zle reset-prompt
}
zle -N cdup
bindkey '^k' cdup

# コマンド履歴をインクリメンタル検索する。
bindkey "^r" history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward

# コマンド履歴を検索する。
zle -N history-beginning-search-backward-end history-search-end
bindkey "^o" history-beginning-search-backward-end

# コマンド履歴から実行する。
bindkey '^x^r' anyframe-widget-execute-history

# 全履歴を一覧表示する。
function history-all { history -E 1 }

# 最近移動したディレクトリに移動する。
bindkey '^xb' anyframe-widget-cdr

# -------------------------------------
# その他
# -------------------------------------

# cdしたあとで、自動的に ls する
function chpwd() { ll }

# iTerm2のタブ名を変更する
function title {
  echo -ne "\033]0;"$*"\007"
}

# antigen
[ -f ~/.zsh/antigen/antigen.zsh ] && source ~/.zshrc.antigen
