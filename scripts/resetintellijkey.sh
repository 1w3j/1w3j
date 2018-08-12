#!/bin/bash

source ~/1w3j/functions.sh;

PYCHARM=charm; #usage => $ resetintellijkey charm
PYCHARM_CONFIG=~/.PyCharm;

IDEA=idea; #usage => $ resetintellijkey idea
IDEA_CONFIG=~/.IntelliJIdea;

CLION=clion #usage => $ resetintellijkey clion
CLION_CONFIG=~/.CLion;

GOLAND=goland; #usage => $ resetintellijkey goland
GOLAND_CONFIG=~/.GoLand;

WEBSTORM=webstorm; #usage => $ resetintellijkey webstorm
WEBSTORM_CONFIG=~/.WebStorm;

DATAGRIP=datagrip
DATAGRIP_CONFIG=~/.DataGrip;

reset_keys(){
    IDE=${1};
    IDE_CONFIG=${2};

    msg "Removing the evaluation keys";
    rm  -rf ${IDE_CONFIG}/config/eval;

    rm -rf ~/.java/.userPrefs/jetbrains/pycharm;

    msg "Resetting evalsprt in options.xml";
    sed -i '/evlsprt/d' ${IDE_CONFIG}/config/options/options.xml;

    msg "Resetting evalsprt in prefs.xml";
    sed -i '/evlsprt/d' ~/.java/.userPrefs/prefs.xml;

    msg "Touching files";
    find ${IDE_CONFIG} -type d -exec touch -t $(date +"%Y%m%d%H%M") {} +;
    find ${IDE_CONFIG} -type f -exec touch -t $(date +"%Y%m%d%H%M") {} +;
}

handle_configpath_params(){
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

resetintellijkey(){
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
        --just-get-configpath)
            handle_configpath_params "${2}";
            ;;
        *)
            err "IDE named \"$1\" not available - nothing to do here...";
    esac

    UPPER_IDE=`echo ${IDE} | awk '{print toupper($0)}'`;
    IDE_CONFIG=`eval echo '$'"${UPPER_IDE}_CONFIG"`;
    IDE_CONFIG=$(ls -td ${IDE_CONFIG}* | head -1 | tr ':' ' ');

    msg ${IDE} detected;
    msg ${IDE_CONFIG} detected;

    if [[ ! "${1}" = "--just-get-configpath" ]]; then
        reset_keys ${IDE} ${IDE_CONFIG};
    fi
}

resetintellijkey ${*};
