#!/usr/bin/env bash
setxkbmap us -print | xkbcomp - $DISPLAY
