#!/bin/zsh

# NOTE: must be outside the function to get the script path:
SCRIPTSDIR="${0:A:h}"

# hugonew NAME
# use um next to create new post number and hugo new to populate defaults.
function hugonew {
    [[ -z $1 ]] && echo "usage: $0 NAME" && exit 1

    local ROOTDIR=$SCRIPTSDIR/..
    cd $ROOTDIR/content/posts || exit 1
    local NEXT=content/posts/$(um next $1)
    cd $ROOTDIR
    # WARN: because um next writes to this file with its own header, but we only want the name:
    rm $NEXT || exit 1
    hugo new $NEXT || exit 1
    emacsclient -n $NEXT
    cd -
}
hugonew $1
