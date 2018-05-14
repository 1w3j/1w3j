#!/bin/bash

PYCHARM=pycharm;
PYCHARM_CONFIG=~/.PyCharm;

IDEA_CONFIG=~/.IntelliJIdea;
IDEA=idea;

CLION=clion
CLION_CONFIG=~/.CLion;

GOLAND=goland;
GOLAND_CONFIG=~/.GoLand;

WEBSTORM=webstorm;
WEBSTORM_CONFIG=~/.WebStorm;

case $1 in
  $PYCHARM)
    IDE=$PYCHARM;
    ;;
  $CLION)
    IDE=$CLION;
    ;;
  *)
    err "$1: ide not available - nothing do do here...";
    ;;
esac


echo "removing evaluation key"
rm  -rf $IDE*/config/eval

rm -rf ~/.java/.userPrefs/jetbrains/pycharm

echo "resetting evalsprt in options.xml"
sed -i '/evlsprt/d' $IDE*/config/options/options.xml

echo "resetting evalsprt in prefs.xml"
sed -i '/evlsprt/d' ~/.java/.userPrefs/prefs.xml


echo "change date file"
find ~/.PyCharm* -type d -exec touch -t $(date +"%Y%m%d%H%M") {} +;
find ~/.PyCharm* -type f -exec touch -t $(date +"%Y%m%d%H%M") {} +;

#find ~/.IntelliJIdea* -type d -exec touch -t $(date +"%Y%m%d%H%M") {} +;
#find ~/.IntelliJIdea* -type f -exec touch -t $(date +"%Y%m%d%H%M") {} +;

#find ~/.GoLand* -type d -exec touch -t $(date +"%Y%m%d%H%M") {} +;
#find ~/.GoLand* -type f -exec touch -t $(date +"%Y%m%d%H%M") {} +;

#find ~/.WebStorm* -type d -exec touch -t $(date +"%Y%m%d%H%M") {} +;
#find ~/.WebStorm* -type f -exec touch -t $(date +"%Y%m%d%H%M") {} +;
