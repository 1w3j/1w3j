#!/usr/bin/env sh

>&1 ls "$1" -lam1N | tail -n+3
