#!/usr/bin/env sh
if tmux has-session -t terminal; then eval "gnome-terminal -- tmux attach-session -t terminal"; else eval "gnome-terminal -- tmux new-session -s terminal"; fi
