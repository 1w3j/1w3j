#!/usr/bin/env sh

source `dirname "$0"`/functions.sh

SCRIPTS_PATH=~/1w3j/scripts;
CONFIGS_PATH=~/1w3j/config;
BIN_PATH=~/bin;
CONFIG_FILES=(
              lessfilter
              rtorrent.rc
#              bashrc
              gvimrc
              ideavimrc
              tmux.conf
              tmux.conf.local
              vimrc
#              vimrc.after
#              vimrc.before
              zshrc
              );

link_scripts() {
    msg "Found these .$1 scripts:";
    FILES=();
    # globbing files with the specified extension on '$1'
    for f in ${SCRIPTS_PATH}/*.$1; do
        # check if current $f file is actually a file (not dirs) while excluding this script file
        [ -f "${f}" ] && [ "${f}" != "$(realpath $0)" ] && FIEL=$(basename ${f});
        # note: shortened filenames just for fooling around
        # concatenating the SCRIPTS_PATH "path string", a "/" slash, and the current file string "globbed"
        FILE=${SCRIPTS_PATH}/${FIEL};
        echo -e "\t$FILE";
        # append that string to the FILES array
        FILES=("$FILE" "${FILES[@]}");
        # echo "FILES: " "${FILES[@]}";
    done;
    msg "Started linking:";
    #iterating over all files in the array
    for f in "${FILES[@]}"; do
        from=${f};
        #getting the basename of the script file
        to_base=$(basename ${f});
        #trimming out the extension
        to=${BIN_PATH}/${to_base%.*};
        echo -e "\t\033[31m$from\033[m ==>> \033[31m$to\033[m";
        rm -f ${to};
        ln -s ${from} ${to};
    done;
    echo -e "\r"
}

link_config_files() {
    source ~/1w3j/scripts/resetintellijkey.sh --just-get-configpath webstorm;
    echo ide config detected ${IDE_CONFIG};
    warn "Found these config files";
    for c in "${CONFIG_FILES[@]}"; do
        echo -e "\t$CONFIGS_PATH/$c";
    done;
    msg "Started linking:";
    for c in "${CONFIG_FILES[@]}"; do
        from=${CONFIGS_PATH}/$c;
        to=~/.$c;
        echo -e "\t\033[31m$from\033[m ==>> \033[31m$to\033[m";
        rm -f $to;
        ln -s $from $to;
    done;
    echo -e "\r";
}

make_intellij_configs() {
    echo adamn
}

check_zsh() {
    msg "Checking if zsh is your current shell"
    if [[ (! $SHELL = "/usr/bin/zsh") && (! $SHELL = "/bin/zsh") ]]; then
        warn "Nope, $SHELL is your shell right now, we need to change";
        chsh -s /usr/bin/zsh "${US3R}";
    fi;
    msg "Everything is just fine";
}

init_sh() {
    check_zsh
    link_scripts "sh"
    link_scripts "py"
    link_config_files
}

init_sh ${*};
