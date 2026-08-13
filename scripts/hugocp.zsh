#!/bin/zsh

# hugocp FILE [PUBLISH]
function hugocp {
    [[ -z $1 ]] && echo "usage: $0 FILE [PUBLISH]" && exit 1

    local DIR="${0:A:h}"
    local FILE="$1"
    local CONTENT
    local TITLE
    local NEXT
    local TAGS
    local PUBLISH

    if [[ -n $2 && $2 == "publish" ]]; then
        # draft=false
        PUBLISH="true"
    else
        # draft=true
        PUBLISH="false"
    fi

    CONTENT=`cat $FILE` || exit 1
    TAGS=`echo $CONTENT | grep -Eo '^\+ .*$' | sed 's/\+ //g' | tr '\n' ','`
    DESCRIPTOR=`echo ${FILE:t} | sed -E 's/[0-9]+\.(.*)\.md/\1/'`

    # call hugo new with env vars caught in the archetype
    NEXT=$(HUGO_SKIPIMG=true HUGO_TAGS="$TAGS" HUGO_PUBLISH=$PUBLISH $DIR/hugonew.zsh $DESCRIPTOR) || exit 1
    NEXT=$(echo $NEXT | sed -E 's/Content \"(.*?)\" created/\1/g')

    # paragraph
    echo >> $NEXT
    # dump everything after the first \n\n
    echo $CONTENT | awk -v RS= 'NR > 1 { print $0 "\n"}' >> $NEXT
    cd -
}
hugocp $1 $2
