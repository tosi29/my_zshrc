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

bindkey "\e[A" history-beginning-search-backward-end
bindkey "\e[B" history-beginning-search-forward-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
#----------------------------------------------------------------------

setopt correct
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent          # Don't show stack by 'pushd','popd'
setopt no_beep
setopt nolistbeep
setopt ignore_eof            # Don't logout by C-d
setopt extended_glob
#setopt auto_cd              # 'cd' by directory name
#setopt no_unset             # Don't use undeclared variable
setopt shwordsplit           # Split variable by space shell in shell arguments
setopt globsubst             # Expand wildcard in variable
setopt brace_ccl             # Expand {a-z} expression
setopt printeightbit         # Print 8th bit
#setopt printexitvalue       # Print exit code
setopt list_packed
#unsetopt promptcr

setopt no_flow_control       # Ignore C-q, C-s
setopt mark_dirs             # Add "/" to end if matches directories
setopt numeric_glob_sort     # Numeric sort
#setopt magic_equal_subst    # Enable completion after "=" e.g. --prefix=/usr

# Completion
compctl -g '*.pdf' + -/ acroread
compctl -g '*.zip' unzip
compctl -g '*.lzh' lha

zstyle ':completion:*:default' menu select=1 # Use emacs keybind in completions

#env
export GREP_OPTIONS="--color=auto"
export LESS="-iMQ"; # less default option
#export LESSOPEN="| lesspipe %s"
export PAGER='less -R'

alias   e='emacs -nw'
alias   r='emacs -nw --read-only'

alias   cdp='cd -P .'
alias   ..='cd ..'
alias   cd..='cd ..'  # For typo
alias   lcd='cd'      # For typo
alias   kess='less'   # For typo
alias   les='less'    # For typo
alias   ess='less'    # For typo
alias   cp='cp -i'
#alias   defdiff="`which diff`"
#alias   diff='colordiff'
alias   cdiff='colordiff'
alias   h='history 1'
alias   ls='ls -CFG -x'
alias   ks='ls'       # For typo
alias   ll='ls -la'
alias   kk='ll'       # For typo
alias   l='ls -l'
alias   k='l'         # For typo
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

#alias -g L='| less -r'
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


