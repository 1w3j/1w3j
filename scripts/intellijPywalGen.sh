#!/usr/bin/env bash
# value=\"(\K[a-f0-9]{6})
# (?sm)(^[^\r\n]+$)(?!.*^\1$)


# Attempts to retrieve wals colors
cache_dir="${HOME}/.cache/wal"
# Import colors
c=($(< "${cache_dir}/colors"))
c=("${c[@]//\#}")

# Read input param
ijConfigPath=$1

# Set colors based on pywal
fgColor=${c[15]} #d09899
bgColor=${c[0]} #0c0a09
txtColor=${c[15]} #d09899
sfgColor=${c[0]} #0c0a09
sbgColor=${c[1]} #9e231f
caretRowColor=${sfgColor} #0c0a09
lnColor=${c[1]} #9e231f
bg2Color=${c[1]} #9e23if
contrastColor=${c[1]} #9e231f
sbColor=${c[1]} #9e231f
treeColor=${c[15]} #d09899
disabledColor=${c[15]} #d09899
activeColor=${c[2]} #b22828

# Get current Directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Paths to templates
templatePath=$DIR\/material_scheme_template.xml
materialTPath=$DIR\/material_template.xml

# Paths to IDE
ijCfPath=$ijConfigPath/colors/material-pywal.icls
ijMPath=$ijConfigPath/options/material_custom_theme.xml

# Override existing config
cp -f $templatePath $ijCfPath
cp -f $materialTPath $ijMPath

# Replace placeholders for colors
exp=s/leTXT/$txtColor/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath

exp=s/leBG/$bgColor/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath

# Selection/Highlight colors
exp=s/leSFG/$sfgColor/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath

exp=s/leSBG/$sbgColor/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath

exp=s/leCROW/$caretRowColor/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath

exp=s/leLN/$lnColor/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath

exp=s/leFG/$fgColor/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath

exp=s/leBG2/$bg2Color/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath

exp=s/leContrast/$contrastColor/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath

exp=s/leSBC/$sbColor/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath

exp=s/leTree/$treeColor/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath

exp=s/leDisabled/$disabledColor/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath

exp=s/leActive/$activeColor/g
sed -i $exp $ijCfPath
sed -i $exp $ijMPath
