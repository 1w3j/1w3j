#!/usr/bin/env zsh

SCRIPTS_PATH=~/1w3j/scripts;
CONFIGS_PATH=~/1w3j/config;
BIN_PATH=~/bin;
CONFIG_FILES=(
#              bashrc
#              gvimrc
              ideavimrc
              tmux.conf
              vimrc
#              vimrc.after
#              vimrc.before
#              zshrc
              );

link_scripts() {
    echo -e "\033[32m(*) Found these .$1 scripts:\033[m";
    FILES=();
    # globbing files with the specified extension on '$1'
    for f in $SCRIPTS_PATH/*.$1; do
        # check if current $f file is actually a file (not dirs) while excluding this script file
        [ -f "$f" ] && [ "$f" != "$(realpath $0)" ] && FIEL=$(basename $f);
        # note: shortened filenames just for fooling around
        # concatenating the SCRIPTS_PATH "path string", a "/" slash, and the current file string "globbed"
        FILE=$SCRIPTS_PATH/$FIEL;
        echo -e "\t$FILE";
        # append that string to the FILES array
        FILES=("$FILE" "${FILES[@]}");
        # echo "FILES: " "${FILES[@]}";
    done;
    echo -e "\033[32mStarting the link process:\033[m";
    #iterating over all files in the array
    for f in "${FILES[@]}"; do
        from=$f;
        #getting the basename of the script file
        to_base=$(basename $f);
        #trimming out the extension
        to=$BIN_PATH/${to_base%.*};
        echo -e "linking \033[31m$from\033[m to \033[31m$to\033[m";
        rm -f $to;
        ln -s $from $to;
    done;
    echo -e "\r"
}

link_config_files() {
    echo -e "\033[32m(*)Found these config files\033[m";
    for c in "${CONFIG_FILES[@]}"; do
        echo -e "\t$CONFIGS_PATH/$c";
    done;
    echo -e "\033[32mStarting the link process:\033[m";
    for c in "${CONFIG_FILES[@]}"; do
        from=$CONFIGS_PATH/$c;
        to=~/.$c;
        echo -e "linking \033[31m$from\033[m to \033[31m$to\033[m";
        rm -f $to;
        ln -s $from $to;
    done;
    echo -e "\r";
}

if [[ (! $SHELL = "/usr/bin/zsh") && (! $SHELL = "/bin/zsh") ]]; then chsh -s /usr/bin/zsh iqbal; fi;
link_scripts "sh"
link_scripts "py"
link_config_files
