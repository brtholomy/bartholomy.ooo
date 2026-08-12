#!/bin/zsh

# make a 100x100 round .webp thumbnail
#
# takes optional float args for X and Y center and ZOOM level
# NOTE: even if edges are specified, won't crop outside the image.

if [ -z "$1" ]; then
    echo 'usage: thumb.zsh IMAGE [X] [Y] [ZOOM]'
    echo 'defaults: 0.5 0.5 1.0'
    exit 1
fi

IMAGE=$1
THUMB="${1:r}.thumb.webp"
CX=${2:-0.5}
CY=${3:-0.5}
ZOOM=${4:-1.0}

# get image dimensions from magick
read W H < <(magick identify -ping -format "%w %h" "$IMAGE")

# compute crop size, position, and clamping
read C X Y < <(awk -v w="$W" -v h="$H" -v cx="$CX" -v cy="$CY" -v z="$ZOOM" 'BEGIN {
    b = (w < h) ? w : h
    c = int(b / z)
    x = int(w * cx - c / 2)
    y = int(h * cy - c / 2)

    # clamp bounds so it never crops outside the image
    if (x < 0) x = 0; else if (x > w - c) x = w - c
    if (y < 0) y = 0; else if (y > h - c) y = h - c

    print c, x, y
}')

# feed into magick
magick "$IMAGE" \
  -crop "${C}x${C}+${X}+${Y}" +repage \
  -resize 100x100 \
  -alpha set \
  \( +clone -evaluate set 0 -fill white -draw "circle 50,50 50,0" \) \
  -compose DstIn -composite \
  -quality 95 \
  -define webp:lossless=false \
  "$THUMB"

echo "$THUMB"
echo "crop: ${C}x${C}+${X}+${Y}"
