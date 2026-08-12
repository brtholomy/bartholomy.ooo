#!/bin/zsh

# make a 100x100 round .webp thumbnail
#
# takes optional float args for X and Y center and ZOOM level
# NOTE: even if edges are specified, won't crop outside the image.

# :A absolute path following symlinks
# :h head
DIR="${0:A:h}"
"$DIR/cover.zsh" "$1" "${2:-0.5}" "${3:-0.5}" "${4:-1.0}" "thumb"
