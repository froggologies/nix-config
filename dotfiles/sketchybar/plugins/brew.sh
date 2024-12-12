#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

COUNT=$(brew outdated | wc -l | tr -d ' ')

COLOR=${ALPHA_ITEM}${TEXT}

case "$COUNT" in
  [3-5][0-9]) COLOR=${ALPHA_ITEM}${MAROON}
  ;;
  [1-2][0-9]) COLOR=${ALPHA_ITEM}${PEACH}
  ;;
  [1-9]) COLOR=${ALPHA_ITEM}${YELLOW}
  ;;
  0) COLOR=${ALPHA_ITEM}${GREEN}
     COUNT=􀆅
  ;;
esac

sketchybar --set $NAME label=$COUNT icon.color=$COLOR
