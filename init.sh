#!/usr/bin/env sh

check_home() {
	echo 'Checking if the repo was cloned in your $HOME path...';
  two_dirs_up=$(dirname $(dirname $(realpath $0)));
  if [[ ! $HOME = "$two_dirs_up" ]]; then
    echo "Please run the following command: \`mv $(dirname $(realpath $0)) $HOME\`";
		exit 1336
	fi;
}

check_home;
source `dirname "$0"`/functions.sh

SCRIPTS_PATH=~/1w3j/scripts;
CONFIG_PATH=~/1w3j/config;
BIN_PATH=~/bin;
MY_INTELLIJ_IDES=(
    idea
    webstorm
    pycharm
    datagrip
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
    msg "Started linking config files";
    for c in "${CONFIG_PATH}"/*; do
        case "$(basename ${c})" in
            intellij)
                for ide in ${MY_INTELLIJ_IDES[*]}; do
                    source ~/1w3j/scripts/resetintellijkey.sh --just-get-configpath ${ide};
                    CURRENT_IDE_CONFIG=$(realpath ${IDE_CONFIG}*);
                    msg "Soft linking config files for ${IDE}";
                    if [[ -d ${CURRENT_IDE_CONFIG} ]]; then
                        msg ${CURRENT_IDE_CONFIG} "config folder detected for ${ide}";
                        msg "Recursively copying into" ${CURRENT_IDE_CONFIG} "with '-s' flag";
                        cp -rsf "${c}"/* ${CURRENT_IDE_CONFIG};
                    else
                        warn ${CURRENT_IDE_CONFIG} "doesn't exist. Install ${ide} first then run init.sh";
                    fi;
                done;
                msg "++++++++++++++ IMPORTANT NOTE +++++++++++++++";
                msg "You may now want to run your IDEs, if color scheme resets as in normal (or awfully) again, consider running init.sh again before 'restarting your IDE'. This 'may' be due to the version displayed in material_theme.xml. Always update the Material Theme UI Plugin";
                ;;
            *)
                from="${c}";
                to=~/."$(basename ${c})";
                if [[ -d "${c}" ]]; then
                    msg "${c} folder detected"
                    msg "Creating parent folders for you"
                    mkdir -p "$(dirname {to})"
                    msg "Recursively copying into ${to}"
                    cp -rsf "${from}"/* "${to}";
                else
                    cp -rsf "${from}" "${to}";
                    echo -e "\t\033[31m$from\033[m ==>> \033[31m$to\033[m";
                fi;
                ;;
        esac
    done;
    echo -e "\r";
}

check_zsh() {
    msg "Checking if zsh is your current shell"
    if [[ ( ! $SHELL = "/usr/bin/zsh") && (! $SHELL = "/bin/zsh") ]]; then
        warn "Nope, $SHELL is your shell right now, we need to change";
        chsh -s /usr/bin/zsh "${US3R}";
    fi;
    msg "Everything is just fine";
}

print_usage(){
cat<<EOF

Usage: ${0} [--do-not-install-anything]
Options:
      --do-not-install-anything           Just link your config files without isntalling the 'binaries'
EOF
}

install_packages() {
    pacman_pkgs=$(cat ~/1w3j/binaries/pacman | tr '\n' ' ');
    yaourt_pkgs=$(cat ~/1w3j/binaries/yaourt | tr '\n' ' ');
    msg "Starting pacman sync";
    msg "Please select number 3) when installing 'i3' -> i3blocks";
    sudo pacman -Syyyu;
    sudo pacman -S $pacman_pkgs;
    yaourt -S $yaourt_pkgs;
    sudo pip install -r ~/1w3j/binaries/pip;
    mhwd -i pci video-hybrid-intel-nvidia-bumblebee;
    sh -c "$(curl -fSsL https://blackarch.org/strap.sh)";
}

init_sh() {
    if [[ "${1}" = "--help" || "${1}" = "-h" ]]; then
      print_usage;
      exit 0;
    fi;
    check_zsh;
    link_scripts "sh";
    link_scripts "py";
    link_config_files;
    if [[ ! "${1}" = "--do-not-install-anything" ]]; then
      echo installing PACKAGESSSSS
#      install_packages;
    fi;
    #wal -i ~/1w3j/wallpapers/OMEN_by_HP.jpg;
}

init_sh ${*};
