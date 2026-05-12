#!/bin/bash
#set -x

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

log() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*"
}

pick_border_color() {
  case "${1}" in
    "contemporary")
      BORDER_COLOR="#5294DC"
      ;;
    "grand_californian")
      BORDER_COLOR="#FAC04B"
      ;;
    "pop_century")
      BORDER_COLOR="#498BD9"
      ;;
    *)
      err "Could not find hotel! Exiting."
      exit 1
  esac
  echo "${BORDER_COLOR}"
}
