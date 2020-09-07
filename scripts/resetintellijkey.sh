#!/bin/bash

# Usage: resetintellijkey 'idea' && resetintellijkey 'clion' && resetintellijkey 'goland'
# NOTE:
# To reset plugin expiration, remove the respective '${IDE_CONFIG}/config/eval/*.evaluation.key' file

source ~/1w3j/functions.sh;

INTELLIJ_HOME=/opt

PYCHARM=pycharm; #usage => $ resetintellijkey charm
# shellcheck disable=SC2034
PYCHARM_CONFIG=${INTELLIJ_HOME}/pycharm;

IDEA=idea; #usage => $ resetintellijkey idea
# shellcheck disable=SC2034
IDEA_CONFIG=${INTELLIJ_HOME}/idea;

CLION=clion #usage => $ resetintellijkey clion
# shellcheck disable=SC2034
CLION_CONFIG=${INTELLIJ_HOME}/clion;

GOLAND=goland; #usage => $ resetintellijkey goland
# shellcheck disable=SC2034
GOLAND_CONFIG=${INTELLIJ_HOME}/goland;

WEBSTORM=webstorm; #usage => $ resetintellijkey webstorm
# shellcheck disable=SC2034
WEBSTORM_CONFIG=${INTELLIJ_HOME}/webstorm;

PHPSTORM=phpstorm
# shellcheck disable=SC2034
PHPSTORM_CONFIG=${INTELLIJ_HOME}/phpstorm;

DATAGRIP=datagrip
# shellcheck disable=SC2034
DATAGRIP_CONFIG=${INTELLIJ_HOME}/datagrip;

reset_keys(){
    IDE=${1};
    IDE_CONFIG=${2};

    msg "Removing the evaluation keys";
    rm  -rf "${IDE_CONFIG}/config/eval";

    rm -rf "${HOME}/.java/.userPrefs/jetbrains/${IDE}";

    msg "Resetting evalsprt in options.xml";
    # 2018 versions : change other.xml to options.xml
    sed -i '/evlsprt/d' "${IDE_CONFIG}/config/options/other.xml";

    msg "Resetting evalsprt in prefs.xml";
    sed -i '/evlsprt/d' "${HOME}/.java/.userPrefs/prefs.xml";

    msg "Deleting eval folder";
    rm -f "${IDE_CONFIG}/config/options/eval";

    msg "Deleting ${IDE} user prefs folder";
    rm -rf "${HOME}/.java/userPrefs/jetbrains/${IDE}";

    msg "Touching files";
    find "${IDE_CONFIG}" -type d -exec touch -t "$(date +"%Y%m%d%H%M")" {} +;
    find "${IDE_CONFIG}" -type f -exec touch -t "$(date +"%Y%m%d%H%M")" {} +;

    msg "Resetting plugins";
    rm -f "${IDE_CONFIG}"/config/eval/plg_*.evaluation.key
}

handle_config_path_params(){
    case "${1}" in
        "${PYCHARM}")
            IDE=${PYCHARM};
            ;;
        "${IDEA}")
            IDE=${IDEA};
            ;;
        "${CLION}")
            IDE=${CLION};
            ;;
        "${GOLAND}")
            IDE=${GOLAND};
            ;;
        "${PHPSTORM}")
            IDE=${PHPSTORM};
            ;;
        "${WEBSTORM}")
            IDE=${WEBSTORM};
            ;;
        "${DATAGRIP}")
            IDE=${DATAGRIP};
            ;;
        *)
            err "--just-get-configpath needs the name of the IDE being passed as an argument";
    esac;
}

print_usage() {
    case "${0##*/}" in
        resetintellijkey|resetintellijkey.sh)
            cat <<EOF
Usage: ${0##*/} {IDE} [--just-get-configpath {IDE}]
Options:
        {IDE}                                     The IDE name as in the scripts created by the
                                                  Jetbrains Toolbox app, must be lowercase, and only
                                                  one name per runtime
        --just-get-configpath                     Just output the config folder of IDE
Note:
 To reset plugin expiration, remove the respective 'IDE_CONFIG/config/eval/*.evaluation.key file
EOF
        ;;
    esac
}

resetintellijkey(){
    local UPPERCASE_IDE
    case "${1}" in
        -h)
            ;;
        --help)
            ;;
        "${PYCHARM}")
            IDE=${PYCHARM};
            ;;
        "${IDEA}")
            IDE=${IDEA};
            ;;
        "${CLION}")
            IDE=${CLION};
            ;;
        "${GOLAND}")
            IDE=${GOLAND};
            ;;
        "${PHPSTORM}")
            IDE=${PHPSTORM};
            ;;
        "${WEBSTORM}")
            IDE=${WEBSTORM};
            ;;
        "${DATAGRIP}")
            IDE=${DATAGRIP};
            ;;
        --just-get-configpath)
            handle_config_path_params "${2}";
            ;;
        *)
            err "IDE named \"${1}\" not available - nothing to do here...";
    esac

    UPPERCASE_IDE=$(echo ${IDE} | awk '{print toupper($0)}');
    IDE_CONFIG=$(eval echo '$'"${UPPERCASE_IDE}_CONFIG");
    #IDE_CONFIG=$(find ${IDE_CONFIG}* -type d | head -1);
    IDE_CONFIG=$(find "${IDE_CONFIG}" -type d | head -1);

    case "${1}" in
        --help|-h)
            print_usage;
            ;;
        --just-get-configpath)
            msg ${IDE} detected;
            msg "${IDE_CONFIG}" detected;
            ;;
        *)
            msg ${IDE} detected;
            msg "${IDE_CONFIG}" detected;
            reset_keys ${IDE} "${IDE_CONFIG}";
            ;;
    esac
}

resetintellijkey "${@}";
