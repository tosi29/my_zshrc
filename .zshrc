#! /bin/zsh

limit core 0
	   
autoload -U compinit
compinit -u


PROMPT="%{[96;4m%}%m[%!]%%%{[0m%} "
#PROMPT="%m[%!]%% "
PROMPT2="%_%% "

SPROMPT="CORRECT %r (y|n|a|e)? "
#RPROMPT="%/  %T"
RPROMPT="%{[96m%}%/  %T%{[0m%}"
#RPROMPT="%{[96m%}%/ %D{%m/%d} %T%{[0m%}"

# Interpret "<hoge" as "cat <hoge"
NULLCMD="cat"
READNULLCMD="cat"

bindkey -e
bindkey "^[[3~" delete-char  # To work Fn+Del
#bindkey "^Q" push-line

bindkey "^X^R" redo
bindkey "^Xr" redo

#------------------------------History------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_all_dups  # Ignore duplicated history
setopt hist_ignore_dups      # Ignore history if it is same as previous
setopt share_history         # share command history among zsh
setopt HIST_IGNORE_SPACE     # Don't save if start with space
setopt hist_reduce_blanks    # Remove unnecessary spaces
setopt hist_save_no_dups     # Don't save duplicated history

autoload history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# C-p C-nなどに慣れようとしてみるため一旦変更
#bindkey "\e[A" history-beginning-search-backward-end # 使いづらければ^Pに
#bindkey "\e[B" history-beginning-search-forward-end  # 使いづらければ^Nに
bindkey "\e[A" history-beginning-search-backward-end
bindkey "\e[B" history-beginning-search-forward-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
#----------------------------------------------------------------------

setopt correct
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent          # pushd popd でスタック表示しない
setopt no_beep
setopt nolistbeep
setopt ignore_eof            # C-dでログアウトしない
setopt extended_glob
#setopt auto_cd              # dir名で移動
#setopt no_unset             # 未定義変数使用禁止
setopt shwordsplit           # 変数を引数にしたとき、スペースで区切られる
setopt globsubst             # 変数中のワイルドカードとか、展開
setopt brace_ccl             # {a-z}とか展開してくれる
setopt printeightbit         # 8ビット目表示
#setopt printexitvalue       # 終了コード表示
setopt list_packed
#unsetopt promptcr            #末尾に改行コードがなくても表示をやめる 

setopt no_flow_control       # C-q, C-s 無効化
setopt mark_dirs                # ファイル名の展開でディレクトリ名にマッチした場合, 末尾に/をつける
setopt numeric_glob_sort        # 辞書順ではなく数値順でソート
#setopt magic_equal_subst        # =以降でも補完できるようにする( --prefix=/usrのような )

#補完
compctl -g '*.pdf' + -/ acroread
compctl -g '*.zip' unzip
compctl -g '*.lzh' lha

zstyle ':completion:*:default' menu select=1 # 補完侯補をEmacsのキーバインドで動き回る

#env
export GREP_OPTIONS="--color=auto"
export LESS="-iMQ"; # lessに標準でつけたいオプション
#export LESSOPEN="| lesspipe %s"
export PAGER='less -R'

alias   e='emacs -nw'
alias   r='emacs -nw --read-only'

alias   cdp='cd -P .'
alias   ..='cd ..'
alias   cd..='cd ..'  # 空気を読んでくれるように
alias   lcd='cd'      # 空気を読んでくれるように
alias   kess='less'   # 空気を読んでくれるように
alias   les='less'    # 空気を読んでくれるように
alias   ess='less'    # 空気を読んでくれるように
alias   cp='cp -i'
#alias   defdiff="`which diff`"
#alias   diff='colordiff'
alias   cdiff='colordiff'
alias   h='history 1'
alias   ls='ls -CFG -x'
alias   ks='ls'         # 空気を読んでくれるように
alias   ll='ls -la'
alias   kk='ll'         # 空気を読んでくれるように
alias   l='ls -l'
alias   k='l'         # 空気を読んでくれるように
alias   rm='rm -i'
alias   ,,='popd'
alias   mv='mv -i'
alias   grep='grep --color=auto'
alias   z='exec zsh'
alias   clean='rm *~'
alias   q='exit'
#alias   c='clear'
alias   b='bell'
alias   p='ps -aux'
alias   awksum='awk '"'"'BEGIN{sum=0}{sum+=$1}END{print sum}'"'"

#alias -g L='| less -r' # 表示が怪しい時があってやや危険？
alias -g L='| less'
#alias -g EUC='| nkf -e'
#alias -g SJIS='| nkf -s'
#alias -g JIS='| nkf -j'
alias -g G='| grep --color=always'
alias -g W='| wc'
alias -g D='| colordiff'
alias -g T='| tac'

#------------------------Abbreviation------------------------------
typeset -A abbreviations
abbreviations=(
#  "Iag"   "| agrep"
#  "Igr"   "| groff -s -p -t -e -Tlatin1 -mandoc"
#  "Ik"    "| keep"
#  "Iv"    "| ${VISUAL:-${EDITOR}}"
#  "Ix"    "| xargs"
   ",,"    "\`dirs -p | line 2\`"
   "awk"   "awk '{print \$1}'"
   "grep"  "grep --color=auto"
   "today" '`date "+%Y%m%d"`'
   "perlsed" 'perl -e '\''{ while($x = <STDIN>) { $x =~ s///g; print $x; }}'\'

)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[a-zA-Z0-9,]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
#    zle self-insert
}

#no-magic-abbrev-expand() {  
#  LBUFFER+=' '
#}

zle -N magic-abbrev-expand
#zle -N no-magic-abbrev-expand
bindkey "^x\t" magic-abbrev-expand
#bindkey " " magic-abbrev-expand
#bindkey "^x " no-magic-abbrev-expand

#------------------------Abbreviation------------------------------

#stty erase "^H"
#stty erase "^?"

