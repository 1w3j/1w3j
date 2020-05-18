#!/usr/bin/env bash

# Add more vexatious strings found in PDF eBook here:
declare -a aRemoveText=(
    "http://free-pdf-books.com"
    "http://freepdf-books.com"
    "www.freepdf-books.com"
    "Free ebooks ==>"
    "www.it-ebooks.info"
    "www.allitebooks.com"
    "www.allitebooks.org"
    "www.ebook777.com"
    "http://itbookshub.com"
    "www.itbookshub.com"
    "IT-EBOOKS.DIRECTORY"
    "http://www.it-ebooks.directory/"
    "http:///"
)


PROGNAME=${0##*/}
STARTTIME=$(date +%s)

function Usage {
    printf "
Usage:
  ${0##*/} filepath.pdf \"text to be removed\" \"another string of text to be removed\" ...
    or
  ${0##*/} filepath.pdf
Function:
  Use this utility to remove any given string of text from a PDF file without having to edit the file with a PDF editor.
  If you don't specify a removal string, then a list commonly-encountered strings found in downloaded PDF books will be used instead.
Example:
	rmanno ebook.pdf \"http://free-pdf-books.com\" \"Free ebooks ==>\"
Author:
  Gerrit Hoekstra. You can contact me via https://github.com/gerritonagoodday
"
    exit 1
}

function die {
    if [[ -z $1 ]]; then
        printf "$(tput setaf 9)failed.\nExiting...\n$(tput sgr 0)"
    else
        printf "*** $1 ***\nExiting...\n"
    fi
    exit 1
}

function warn {
    printf "$(tput setaf 3)Warning: $1\n$(tput sgr 0)"
}

function info {
    printf "$(tput setaf 10)$1...\n$(tput sgr 0)"
}

function doneit {
    if [[ -n $1 ]]; then
        printf "$(tput setaf 12)$1, done\n$(tput sgr 0)"
    else
        printf "done\n"
    fi
}

PDFFILE="${1}"
[[ -z $PDFFILE ]] && Usage
shift
if [[ -n $1 ]]; then
    # Removal string indicated - decretely put each into the array
    # Can't do this: aRemoveText=($@) in case some strings contain spaces
    i=0
    while :; do
        aRemoveText [ i ] = $1
        shift
        [[ -z $1 ]] && break
    done
fi

# Temp work files
TMPFILE1=$(mktemp "/tmp/tmp.${PROGNAME}.$$.XXXXXX")
#TMPFILE2=$(mktemp "/tmp/tmp.${PROGNAME}.$$.XXXXXX.2")

#============================================================================#
# Set traps and signal BEGIN and END
# Need logging to work for this
#============================================================================#
function cleanup {
    rm "${TMPFILE1}" 2> /dev/null
    #rm "${TMPFILE2}" 2>/dev/null
    ENDTIME=$(date +%s)
    elapsedseconds=$((ENDTIME - STARTTIME))
    s=$((elapsedseconds % 60))
    m=$(( ((elapsedseconds / 60) % 60 ) ))
    h=$(( ( elapsedseconds / 60 / 60 ) % 24 ))
    duration=$(printf "Duration (h:m:s): %02d:%02d:%02d" $h $m $s)
    doneit "${duration}"
    exit
}

for sig in KILL TERM INT EXIT; do
    trap 'cleanup${sig}' " $sig ";
done

info " Checking environment "
PDFTK=` which pdftk 2> /dev/null `
[[ -z " $PDFTK " ]] && die " pdftk does not appear to be installed. "
info " Checking  $PDFFILE "
[[ ! -f ${PDFFILE} ]] && die " $PDFFILE  does not exist "
filetype=$( file -b " $PDFFILE " )
if [[ ${filetype} =~ ^PDF ]]; then
info " $PDFFILE  is a PDF file "
else
die " File  $PDFFILE  does not appear to be a PDF file. "
fi

info " Uncompressing  $PDFFILE "
pdftk " $PDFFILE " output ${TMPFILE1} uncompress > /dev/null 2>&1
retcode=$?
[[ ${retcode} -ne 0 ]] && die " pdftk returned error code  $retcode "

info " Removing text from  $PDFFILE "
for i in $( seq 0 $(( ${#aRemoveText[@]} - 1 )) ); do
# escape single and double quote marks
vextext=$(echo ${aRemoveText[$i]} | sed -e " s|'|\x27|g " | sed -e 's/"/\x22/g' )
sed -e " s| $ { vextext } ||gi " -i $TMPFILE1
done

info " Re-Compressing  $PDFFILE "
pdftk $TMPFILE1 output " $PDFFILE " compress > /dev/null 2>&1
retcode=$?
[[ $retcode -ne 0 ]] && die " pdftk returned error code  $retcode "
