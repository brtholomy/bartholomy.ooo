#!/bin/zsh

# make a 720x480 .webp cover or 100x100 round .webp thumbnail
#
# takes optional float args for X and Y center and ZOOM level
# NOTE: even if edges are specified, won't crop outside the image.

IMAGE=$1
CX=${2:-0.5}
CY=${3:-0.5}
ZOOM=${4:-1.0}
MODE=${5:-cover}
OUT="${IMAGE:r}.${MODE}.webp"

if [[ ! -f "$IMAGE" ]]; then
    echo "Usage: $0 IMAGE [X=0.5] [Y=0.5] [ZOOM=1.0] [MODE=cover|thumb]"
    exit 1
fi

# get dimensions
read -r W H < <(magick identify -ping -format "%w %h" "$IMAGE")

# aspect-aware crop math via awk
read -r CW CH X Y TW TH < <(awk -v w="$W" -v h="$H" -v cx="$CX" -v cy="$CY" -v z="$ZOOM" -v mode="$MODE" 'BEGIN {
    # source aspect ratio
    sar = w / h

    # target aspect ratio
    tw = (mode == "thumb") ? 100 : 720
    th = (mode == "thumb") ? 100 : 480
    tar = tw / th

    # scale based on the limiting dimension:
    # if source ratio is wider than target ratio:
    # set crop height to source h/z, width to ch * target ratio
    # otherwise crop width to w/z, etc.
    if (sar > tar) { ch = h / z; cw = ch * tar }
    else           { cw = w / z; ch = cw / tar }

    cw = int(cw); ch = int(ch)

    # calculate offsets based on ratio
    x = int(w * cx - cw / 2)
    y = int(h * cy - ch / 2)

    # clamp bounds to prevent out-of-bounds errors
    if (x < 0) x = 0; else if (x > w - cw) x = w - cw
    if (y < 0) y = 0; else if (y > h - ch) y = h - ch

    print cw, ch, x, y, tw, th
}')

# command array
CMD=(
  "$IMAGE"
  -crop "${CW}x${CH}+${X}+${Y}" +repage
  # forces exact dimensions since we already fixed the aspect ratio
  -resize "${TW}x${TH}!"
)

if [[ "$MODE" == "thumb" ]]; then
    CMD+=(
        -alpha set
        \( +clone -evaluate set 0 -fill white -draw "circle 50,50 50,0" \)
        -compose DstIn -composite
    )
fi

CMD+=(
    -quality 95
    -define webp:lossless=false
    "$OUT"
)

magick "${CMD[@]}"
echo "Generated: $OUT (Crop: ${CW}x${CH}+${X}+${Y})"
