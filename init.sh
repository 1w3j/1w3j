#!/usr/bin/env bash
# 1. Select your IDEs before running the script
# 2. You can use -dnia flag to skip installing packages
# 3. Check if you need the -f flag for the cp command, enabled by default in the link_config_files function, this will overwrite existing config files in $HOME
# TODO:
# - Detect broken links an remove them
# - Detect oh-my-zsh installation
# - Detect vim plugins

check_if_currently_on_home() {
    echo 'Checking if the repo was cloned in your HOME path...'
    if [[ ! ${HOME} == $(dirname "$(dirname "$(realpath "${0}")")") ]]; then # Check if 'two dirs up' path is equivalent to HOME
        echo "Please run the following command: \`mv $(dirname "$(realpath "${0}")") ${HOME}\`"
        exit 163
    fi
}

check_if_currently_on_home
check_tools
# shellcheck disable=SC1090
source "$(dirname "$0")/functions.sh"

SCRIPTS_PATH=~/1w3j/scripts
CONFIG_PATH=~/1w3j/config
BIN_PATH=~/bin
PROJECTS_PATH=~/Projects
GTK_THEMES_PATH=~/.themes
GTK_ICONS_PATH=~/.icons

check_if_important_folders_exists() {
    msg "Checking if ${BIN_PATH} exists..."
    if [[ ! -d ${BIN_PATH} ]]; then
        warn "Creating ${BIN_PATH} for you..." && mkdir ${BIN_PATH}
    fi
    msg "Checking if ${PROJECTS_PATH} exists..."
    if [[ ! -d ${PROJECTS_PATH} ]]; then
        warn "Creating ${PROJECTS_PATH} for you..." && mkdir ${PROJECTS_PATH}
    fi
    msg "Checking if ${GTK_THEMES_PATH} exists"
    if [[ ! -d ${GTK_THEMES_PATH} ]]; then
        warn "Creating ${GTK_THEMES_PATH} for you..." && mkdir ${GTK_THEMES_PATH}
    fi
    msg "Checking if ${GTK_ICONS_PATH} exists"
    if [[ ! -d ${GTK_ICONS_PATH} ]]; then
        warn "Creating ${GTK_ICONS_PATH} for you..." && mkdir ${GTK_ICONS_PATH}
    fi
}
check_if_important_folders_exists

# Don't change these values, just comment/uncomment according to your setup
# idea, webstorm, pycharm, datagrip, phpstorm, clion
MY_INTELLIJ_IDES=(
    idea
    #   webstorm
    pycharm
    #   datagrip
    phpstorm
    #   clion
)

# Allowed platforms:
# bat, c, c++, dotnet, electron, gradle, java, js, matlab, php, py, rb, sh, vb
MY_PROJECTS=(
    sh/chjdk # ~/Projects/sh/chjdk/
    py/1w3jpdf
    #	bat/...
    #	c/...
    #	c++/...
    #	dotnet/...
    #	electron/...
    #	gradle/...
    #	java/...
    #	js/...
    #	matlab/...
    #	php/...
    #	py/...
    #	rb/...
    #	sh/...
    #	vb/...
)

MY_GTK_THEMES=(
    oomox-1w3j-dark # ${CONFIG_PATH}/.themes/oomox-1w3j-dark/
)

MY_GTK_ICONS=(
    oomox-1w3j-dark # ${CONFIG_PATH}/.icons/oomox-1w3j-dark/
)

readonly SCRIPTS_PATH CONFIG_PATH BIN_PATH PROJECTS_PATH GTK_THEMES_PATH GTK_ICONS_PATH MY_GTK_ICONS MY_GTK_THEMES MY_INTELLIJ_IDES MY_PROJECTS

# After generating a new theme we need to upload the theme folder (usually on ~/.theme -> GTK_THEMES_PATH) and compress it to GTK_ICONS_PATH to a tarball
upload_themes_and_icons() {
    for theme in "${MY_GTK_THEMES[@]}"; do
        rm -i "${CONFIG_PATH}/themes/${theme}.tar.gz"
        msg "Compressing ${GTK_THEMES_PATH}/${theme} to ${CONFIG_PATH}/themes/${theme}.tar.gz"
        cd ${GTK_THEMES_PATH} && tar czf "${CONFIG_PATH}/themes/${theme}.tar.gz" "${theme}" && cd - || return
    done
    for icon_theme in "${MY_GTK_ICONS[@]}"; do
        rm -i "${CONFIG_PATH}/icons/${icon_theme}.tar.gz"
        msg "Compressing ${GTK_ICONS_PATH}/${icon_theme} to ${CONFIG_PATH}/icons/${icon_theme}.tar.gz"
        cd ${GTK_ICONS_PATH} && tar czf "${CONFIG_PATH}/icons/${icon_theme}.tar.gz ${icon_theme}" && cd - || return
    done
}

unload_themes() {
    if [[ is_not_wsl ]]; then
        for theme in "${MY_GTK_THEMES[@]}"; do
            msg "Extracting ${CONFIG_PATH}/themes/${theme}.tar.gz to ${GTK_THEMES_PATH}"
            tar xzf "${CONFIG_PATH}/themes/${theme}.tar.gz" -C ${GTK_THEMES_PATH}
        done
    fi
}

unload_icons() {
    if [[ is_not_wsl ]]; then
        for icon_theme in "${MY_GTK_ICONS[@]}"; do
            msg "Extracting ${CONFIG_PATH}/icons/${icon_theme}.tar.gz to ${GTK_ICONS_PATH}"
            tar xzf "${CONFIG_PATH}/icons/${icon_theme}.tar.gz" -C ${GTK_ICONS_PATH}
        done
    fi
}

link_ides_scripts() {
    warn "If some IDE scripts are missing, first check jetbrains-toolbox configuration and set 'shell scripts location' to ${SCRIPTS_PATH}"
    for ide in "${MY_INTELLIJ_IDES[@]}"; do
        local ide_script=${SCRIPTS_PATH}/${ide} from to
        if [[ -f ${ide_script} ]]; then
            from=${ide_script}
            to=${BIN_PATH}/$(basename "${ide_script}")
            echo -e "\t\033[31m${from}\033[m → \033[31m${to}\033[m"
            rm -f "${to}"
            ln -s "${from}" "${to}"
        else
            warn "${ide} script is missing!"
        fi
    done
}

link_projects() {
    # in order to avoid .gitignore problems, first move the script to PROJECTS_PATH, then run git add * and commit
    msg "Found these project files:"
    for project in "${MY_PROJECTS[@]}"; do
        case ${project%%/*} in # extracting the leading part of the string before the first parentheses
            bat) ;;

            c) ;;

            c++) ;;

            dotnet) ;;

            electron) ;;

            gradle) ;;

            java) ;;

            js) ;;

            matlab) ;;

            php) ;;

            py)
                echo -e "\t⚫Main python script on ${PROJECTS_PATH}/${project}/${project##*/}.py"
                echo -e "\t\033[31m↳\033[m${PROJECTS_PATH}/${project}/${project##*/}.py\033[31m → \033[m${SCRIPTS_PATH}/${project##*/}.py"
                cp -sf "${PROJECTS_PATH}/${project}/${project##*/}.py" ${SCRIPTS_PATH}
                echo -e "\t\t\033[31m↳\033[m Appending to .gitignore"
                append_if_not_exists "$(basename ${SCRIPTS_PATH})/${project##*/}.py" ~/1w3j/.gitignore
                ;;
            rb) ;;

            sh)
                echo -e "\t⚫Main bash script on ${PROJECTS_PATH}/${project}/${project##*/}.sh"
                echo -e "\t\033[31m↳\033[m${PROJECTS_PATH}/${project}/${project##*/}.sh\033[31m → \033[m${SCRIPTS_PATH}/${project##*/}.sh"
                cp -sf "${PROJECTS_PATH}/${project}/${project##*/}.sh" ${SCRIPTS_PATH}
                echo -e "\t\t\033[31m↳\033[m Appending to .gitignore"
                append_if_not_exists "$(basename ${SCRIPTS_PATH})/${project##*/}.sh" ~/1w3j/.gitignore
                ;;
            vb) ;;

            *)
                err "Please check the MY_PROJECTS array, it can only contain the keywords commented up there"
                ;;
        esac
    done
}

clean_binpath() {
    msg "Cleaning ${BIN_PATH}" && rm -f ${BIN_PATH}/*
}

link_scripts() {
    msg "Found these .${1} scripts:"
    local FILES=() FIEL FILE from to to_basename
    # globbing files with the specified extension on '${1}'
    for f in "${SCRIPTS_PATH}"/*."${1}"; do
        # check if current ${f} file is actually a file (not dirs) while excluding this script file
        [[ -f ${f} ]] && [[ ${f} != "$(realpath "${0}")" ]] && FIEL=$(basename "${f}")
        # note: shortened filenames just for fooling around
        # concatenating the SCRIPTS_PATH "path string", a "/" slash, and the current file string "globbed"
        FILE=${SCRIPTS_PATH}/${FIEL}
        echo -e "\t${FILE}"

        FILES=("${FILE}" "${FILES[@]}") # append that string to the FILES array
    done
    msg "Started linking:"
    for f in "${FILES[@]}"; do # iterating over all files in the array
        from=${f}
        to_basename=$(basename "${f}")   # getting the basename of the script file
        to=${BIN_PATH}/${to_basename%.*} # trimming out the extension
        echo -e "\t\033[31m${from}\033[m → \033[31m${to}\033[m"
        ln -s "${from}" "${to}"
    done
    echo -e "\r"
}

link_config_files() {
    msg "Started linking config files"
    msg "Checking for oh-my-zsh installation..."
    if [[ ! -d ${CONFIG_PATH}/oh-my-zsh ]]; then
        ZSH="${CONFIG_PATH}/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=${CONFIG_PATH}/oh-my-zsh/custom}/plugins/zsh-completions
    fi
    if [[ ! -d ${CONFIG_PATH}/vim ]]; then
        git clone https://github.com/VundleVim/Vundle.vim.git ${CONFIG_PATH}/vim
    fi
    read -r -p "$(warn "WARNING: force -f flag was activated on cp commands, Continue? (Press ENTER)")"
    for c in "${CONFIG_PATH}"/*; do
        case "$(basename "${c}")" in
            intellij)
                msg "intellij folder detected \"${c}\""
                for ide in ${MY_INTELLIJ_IDES[*]}; do
                    # shellcheck disable=SC1090
                    source ~/1w3j/scripts/resetintellijkey.sh --just-get-configpath "${ide}"
                    local CURRENT_IDE_CONFIG=${IDE_CONFIG}
                    msg "Soft linking config files for ${IDE}"
                    if [[ -d ${CURRENT_IDE_CONFIG} ]]; then
                        msg "${CURRENT_IDE_CONFIG} config folder detected for ${ide}"
                        msg "Recursively copying into ${CURRENT_IDE_CONFIG} with '-s' flag"
                        cp -rsf "${c}"/* "${CURRENT_IDE_CONFIG}"
                    else
                        warn "${CURRENT_IDE_CONFIG} doesn't exist. Install and run ${ide} first, then reload init.sh"
                    fi
                done
                msg "++++++++++++++ IMPORTANT NOTE +++++++++++++++"
                msg "You may now want to run your IDEs right now, if color scheme default resets (or awfully displayed), consider running init.sh again before 'restarting your IDE'. This 'may' be due to the plugin version displayed in material_theme.xml. Always update the Material Theme UI Plugin on your IDEs"
                ;;
            themes)
                if [[ is_not_wsl ]]; then
                    msg "GTK themes folder detected \"${c}\""
                    unload_themes
                fi
                ;;
            icons)
                if [[ is_not_wsl ]]; then
                    msg "GTK icons folder detected \"${c}\""
                    unload_icons
                fi
                ;;
            *)
                local from to
                from="${c}"
                to=~/."$(basename "${c}")"
                if [[ -d ${c} ]]; then
                    if [[ ! -d ${to} ]]; then
                        warn "${to} folder didn't exist. Using mkdir -p ${to}"
                        mkdir -p ${to}
                    fi
                    cp -rsf "${from}"/* "${to}" && echo -e "\t\033[31m${from}/*\033[m → \033[31m${to}/\033[m"
                else
                    cp -sf "${c}" "${to}" && echo -e "\t\033[31m${from}\033[m → \033[31m${to}\033[m"
                fi
                ;;
        esac
    done
    if [[ is_not_wsl ]]; then
        reload_themes
    fi
}

check_zsh() {
    msg "Checking if zsh is your current shell"
    if [[ (! ${SHELL} == "/usr/bin/zsh") && (! ${SHELL} == "/bin/zsh") ]]; then
        warn "Nope, $SHELL is your shell right now, we need to use ZSH"
        chsh -s /usr/bin/zsh "${US3R}"
    fi
    msg "Everything will be just fine"
}

print_usage() {
    case "${0##*/}" in
        init.sh)
            cat << EOF

Usage: ${0##*/} [--do-not-install-anything | -dnia ]
Options:
        --do-not-install-anything, -dnia            Just link your config files without installing the packages listed in \
~/1w3j/pkgnames
        -rc,--rc,--reload-config-files              Link dotfiles, themes, color schemes, etc
        -rs,--rs,--reload-scripts                   Link scripts/* files to ~/bin
        -uti,--uti,--upload-themes-icons            Compress all theme and icon folders located at GTK_THEMES_PATH and \
GTK_ICONS_PATH respectively, preparing it for repo updates
EOF
            ;;
    esac
}

get_pkgnames() {
    comm -12 <(pacman -Slq | sort) <(sort ~/1w3j/${pkgdir}/"${1}")
}

install_packages() {
    local pkgdir pacman_pkgs yaourt_pkgs
    pkgdir="pkgnames"
    pacman_pkgs=$(get_pkgnames "pacman")
    yaourt_pkgs=$(get_pkgnames "yaourt")
    msg "Starting pacman sync"
    # Deprecated message:
    # msg "DON'T forget to select number 3) when installing 'i3' -> i3blocks";
    # All these dotfiles work best with the manjaro-i3 distro
    sudo pacman -Syyu
    msg "Performing pacman pkgs installation"
    sudo pacman -S --needed $(echo "${pacman_pkgs}")
    msg "Starting yaourt pkgs installation"
    pacaur -S --needed $(echo "${yaourt_pkgs}")
    msg "Starting pip modules installation"
    sudo pip install -r ~/1w3j/${pkgdir}/pip
    #msg "Starting mhwd -i bumblebee"
    #sudo mhwd -i pci video-hybrid-intel-nvidia-bumblebee
    msg "Bootstrapping BlackArch repo"
    if ! pacman -Qi blackarch-keyring; then
        sudo sh -c "$(curl -fSsL https://blackarch.org/strap.sh)"
    else
        warn "Blackarch keyring detected, no need for bootstrapping"
    fi
}

reload_themes() {
    #wal -i ~/1w3j/wallpapers/OMEN_by_HP.jpg -nst
    msg "xrdb ~/.Xresources"
    xrdb ~/.Xresources
    msg "i3-msg reload"
    i3-msg reload
    read -r -p "$(warn "Linking gtk themes and icons to /usr/share requires root privileges, Continue? (Press ENTER)")"
    for theme in "${MY_GTK_THEMES[@]}"; do
        msg "Linking ${GTK_THEMES_PATH}/${theme} to /usr/share/themes"
        sudo ln -sf "${GTK_THEMES_PATH}/${theme}" /usr/share/themes

    done
    for icon_theme in "${MY_GTK_ICONS[@]}"; do
        msg "Linking ${GTK_ICONS_PATH}/${icon_theme} to /usr/share/icons"
        sudo ln -sf "${GTK_ICONS_PATH}/${icon_theme}" /usr/share/icons
    done
}

init_sh() {
    case "${1}" in
        --help | -h)
            print_usage
            exit 0
            ;;
        -dnia | --dnia | --do-not-install-anything)
            check_zsh
            clean_binpath
            link_projects
            link_scripts "sh"
            link_scripts "py"
            link_ides_scripts
            link_config_files
            ;;
        -uti | --uti | --upload-themes-icons)
            upload_themes_and_icons
            ;;
        -rs | --rs | --reload-scripts)
            check_zsh
            clean_binpath
            link_projects
            link_scripts "sh"
            link_scripts "py"
            link_ides_scripts
            ;;
        -rc | --rc | --reload-config-files)
            check_zsh
            link_config_files
            ;;
        *)
            check_zsh
            clean_binpath
            link_projects
            link_scripts "sh"
            link_scripts "py"
            link_ides_scripts
            link_config_files
            install_packages
            ;;
    esac
}

# After a reboot all customizations should be displayed
init_sh "${@}"
