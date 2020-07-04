#!/usr/bin/env zsh
curl -fsSL https://raw.githubusercontent.com/mohnkhan/Free-OReilly-Books/master/README.md | grep -v '##' | sed -e 's/<\/br>//' -e 's/http/https/' | while read book; do curl -LO ${book};done
