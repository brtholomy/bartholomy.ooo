#!/bin/zsh

# hugonew NAME
# use um next to create new post number and hugo new to populate defaults.
function hugonew {
    [[ -z $1 ]] && echo "usage: $0 NAME" && exit 1

    local SCRIPTSDIR="${0:A:h}"
    local ROOTDIR=$SCRIPTSDIR/..
    cd $ROOTDIR/content/posts || exit 1
    local NEXT=content/posts/`um next $1`
    cd $ROOTDIR
    hugo new $NEXT || exit 1
    emacsclient -n $NEXT
    cd -
}
hugonew $1
