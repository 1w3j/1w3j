#!/bin/bash

# Usage: resetintellijkey 'idea' && resetintellijkey 'clion' && resetintellijkey 'goland'

source ~/1w3j/functions.sh;

INTELLIJ_HOME=/opt

PYCHARM=charm; #usage => $ resetintellijkey charm
PYCHARM_CONFIG=$INTELLIJ_HOME/pycharm/.PyCharm;

IDEA=idea; #usage => $ resetintellijkey idea
IDEA_CONFIG=$INTELLIJ_HOME/idea/.IntelliJIdea;

CLION=clion #usage => $ resetintellijkey clion
CLION_CONFIG=$INTELLIJ_HOME/clion/.CLion;

GOLAND=goland; #usage => $ resetintellijkey goland
GOLAND_CONFIG=$INTELLIJ_HOME/goland/.GoLand;

WEBSTORM=webstorm; #usage => $ resetintellijkey webstorm
WEBSTORM_CONFIG=$INTELLIJ_HOME/webstorm/.WebStorm;

DATAGRIP=datagrip
DATAGRIP_CONFIG=$INTELLIJ_HOME/datagrip/.DataGrip;

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
    find ${IDE_CONFIG} -type d -exec touch -t "$(date +"%Y%m%d%H%M")" {} +;
    find ${IDE_CONFIG} -type f -exec touch -t "$(date +"%Y%m%d%H%M")" {} +;
}

handle_config_path_params(){
    case "${1}" in
        ${PYCHARM})
            IDE=${PYCHARM};
            ;;
        ${IDEA})
            IDE=${IDEA};
            ;;
        ${CLION})
            IDE=${CLION};
            ;;
        ${GOLAND})
            IDE=${GOLAND};
            ;;
        ${WEBSTORM})
            IDE=${WEBSTORM};
            ;;
          ${DATAGRIP})
            IDE=${DATAGRIP};
            ;;
        *)
            err "--just-get-configpath needs the name of the IDE being passed as an argument";
    esac;
}

print_usage() {
    case "$(basename ${0})" in
        resetintellijkey|resetintellijkey.sh)
            cat <<EOF
Usage: ${0} {IDE} [--just-get-configpath {IDE}]
Options:
        {IDE}                                     The IDE name as in the scripts created by the
                                                Jetbrains Toolbox app, must be lowercase, and only
                                                one name per runtime
        --just-get-configpath                     Just output the config folder of IDE
EOF
        ;;
    esac
}

resetintellijkey(){
    case "${1}" in
        -h)
            ;;
        --help)
            ;;
        ${PYCHARM})
            IDE=${PYCHARM};
            ;;
        ${IDEA})
            IDE=${IDEA};
            ;;
        ${CLION})
            IDE=${CLION};
            ;;
        ${GOLAND})
            IDE=${GOLAND};
            ;;
        ${WEBSTORM})
            IDE=${WEBSTORM};
            ;;
        ${DATAGRIP})
            IDE=${DATAGRIP};
            ;;
        --just-get-configpath)
            handle_config_path_params "${2}";
            ;;
        *)
            err "IDE named \"${1}\" not available - nothing to do here...";
    esac

    UPPERCASE_IDE=`echo ${IDE} | awk '{print toupper($0)}'`;
    IDE_CONFIG=`eval echo '$'"${UPPERCASE_IDE}_CONFIG"`;
    IDE_CONFIG=$(ls -td ${IDE_CONFIG}* | head -1 | tr ':' ' ');

    case "${1}" in
        --help|-h)
            print_usage;
            ;;
        --just-get-configpath)
            msg ${IDE} detected;
            msg ${IDE_CONFIG} detected;
            ;;
        *)
            msg ${IDE} detected;
            msg ${IDE_CONFIG} detected;
            reset_keys ${IDE} ${IDE_CONFIG};
            ;;
    esac
}

resetintellijkey "${@}";
