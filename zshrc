#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
#

# agnoster theme setup:
DEFAULT_USER=iqbal
prompt_context(){}

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
for config_file ($HOME/.yadr/zsh/*.zsh) source $config_file

#my configurations
autoload -Uz promptinit
promptinit
prompt agnoster

export JAVA_HOME=/usr/lib/jvm/default
export IDEA_JDK=$JAVA_HOME
export JDK_HOME=$JAVA_HOME
export GRADLE_HOME=/opt/gradle/gradle-4.1
export CATALINA_HOME=/usr/share/tomcat8
export CATALINA_BASE=/var/lib/tomcat8
export PATH=$PATH:~/bin:~/.node_modules_global/bin:$GRADLE_HOME/bin:$JAVA_HOME/bin

alias install='sudo apt install'
alias update='sudo apt update'
alias upgrade='sudo apt full-upgrade'
alias autoremove='sudo apt autoremove'
translation(){
  echo $* | translate-bin -s google -f en -t es
  echo -e '\n'
}
alias trns=translation
alias resetx='sudo systemctl restart lightdm'
alias reboot='sudo reboot'

#start highlighting files in terminal
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls -F --color=auto"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#TMUX
if [[ -z "$TMUX" ]] ;then
    ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
    if [[ -z "$ID" ]] ;then # if not available create a new one
        tmux new-session
    else
        tmux attach-session -t "$ID" # if available attach to it
    fi
    # when quitting tmux, try to attach
    # if using multiple terminal sessions, it makes impossible to not kill all tmux sessions
    #while test -z ${TMUX}; do
    #    tmux attach || break
    #done
fi
