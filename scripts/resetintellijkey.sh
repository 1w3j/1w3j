#!/bin/bash

# Usage: resetintellijkey 'idea' && resetintellijkey 'clion' && resetintellijkey 'goland'

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
    rm  -rf "${IDE_CONFIG}/config/eval";

    rm -rf "~/.java/.userPrefs/jetbrains/${IDE}";

    msg "Resetting evalsprt in options.xml";
    # 2018 versions : change other.xml to options.xml
    sed -i '/evlsprt/d' "${IDE_CONFIG}/config/options/other.xml";

    msg "Resetting evalsprt in prefs.xml";
    sed -i '/evlsprt/d' ~/.java/.userPrefs/prefs.xml;

    msg "Deleting eval folder";
    rm -f "${IDE_CONFIG}/config/options/eval";

    msg "Deleting ${IDE} user prefs folder";
    rm -rf "~/.java/userPrefs/jetbrains/${IDE}";

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

print_usage() {
    case "$(basename ${0})" in
        resetintellijkey|resetintellijkey.sh)
            cat <<EOF
Usage: ${0} {IDE} [--just-get-configpath {IDE}]
Options:
        {IDE}                                     The IDE name as in the scripts created by the
                                                Jetbrains Toolbox app, must be lowercase, and only
                                                one name per runtime
        --just-get-configpath                     Only output the config folder of IDE
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
            handle_configpath_params "${2}";
            ;;
        *)
            err "IDE named \"$1\" not available - nothing to do here...";
    esac

    UPPER_IDE=`echo ${IDE} | awk '{print toupper($0)}'`;
    IDE_CONFIG=`eval echo '$'"${UPPER_IDE}_CONFIG"`;
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
            msg resettt
            #reset_keys ${IDE} ${IDE_CONFIG};
            ;;
    esac
}

resetintellijkey ${*};
