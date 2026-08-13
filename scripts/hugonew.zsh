#!/bin/zsh

# hugonew NAME
# use um next to create new post number and hugo new to populate defaults.
function hugonew {
    [[ -z $1 ]] && echo "usage: $0 NAME" && exit 1

    local DIR="${0:A:h}"
    cd ../content/posts || exit 1
    local NEXT=`um next $1`
    hugo new $NEXT || exit 1
    emacsclient -n $NEXT
    cd -
}
hugonew $1
