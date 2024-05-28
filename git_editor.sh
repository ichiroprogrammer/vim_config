#!/bin/sh

if [ -e ~/.config/nvim.appimage ]; then
    ~/.config/nvim.appimage $@
else
    vim $@
fi
