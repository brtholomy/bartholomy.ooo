#!/bin/zsh

# make a 100x100 round .webp thumbnail
#
# takes optional float args for X Y center, ZOOM, and pos/neg ROTATE deg
# NOTE: even if edges are specified, won't crop outside the image.

# :A absolute path following symlinks
# :h head
SCRIPTSDIR="${0:A:h}"
"$SCRIPTSDIR/cover.zsh" "$1" "${2:-0.5}" "${3:-0.5}" "${4:-1.0}" "${5:-0}" "thumb"
