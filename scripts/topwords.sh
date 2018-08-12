#!/usr/bin/env sh

source ~/1w3j/functions.sh;

FOLDER=${1};
# no indentation
EXCLUDED_WORDS="pdf\|zip\|epub\|azw3\|azw4\|chm\|video\|1st\|3rd\|2nd\|s\|First\|Second\|third\|fourth\|technologies\|edition\|practical\|hands\|cookbook\|guide\|application\|applications\|app\|stop\|apps\
\|using\|build\|learning\|introduction\|user\|users\|skills\|theoretical\|theory\|yourself\|concepts\|beginner\|beginners\|start\|own\|click\|like\|mine\|make\|techniques\|technique\|beginning\|begin\
\|fifth\|sixth\|eight\|ninth\|tenth\|eleventh\|twelfth\|thirteenth\|fourteenth\|fifteenth\|4th\|5th\|6th\|7th\|8th\|9th\|10th\|11th\|12th\|13th\|14th\|15th\|manage\|student\|students"

topwords() {
    if [[ -n "${FOLDER}" ]]; then
        listnames ${FOLDER} | tr -c '[:alnum:]' '[\n*]' | grep -v -w -f /usr/share/groff/current/eign -e "${EXCLUDED_WORDS}" -i | sort | uniq -c | sort -nr | head -20;
    else
        err "Wh4t f0lder did you say?"
    fi;
}

topwords ${*};