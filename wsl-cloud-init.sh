#!/bin/bash

if [ "$1" = "--noclean" ]; then
  shift 1
  CLEAN="0"
else
  echo "clean existing cloud-init config"
  CLEAN="1"
  cloud-init clean --logs --seed
fi

if [ -n "$1" ]; then
  DEBUG_PROC_CMDLINE="ds=nocloud;seedfrom=$1"
  shift 1
  case "$DEBUG_PROC_CMDLINE" in
  */)
    # Slash at end, ok!
    ;;
  *)
    # Add slash
    DEBUG_PROC_CMDLINE="$DEBUG_PROC_CMDLINE/"
    ;;
  esac
else
  DEBUG_PROC_CMDLINE="$(cat /proc/cmdline)" # by default cloud-init uses /proc/1/cmdline in a 'container'
fi

set -o pipefail
set -eu
exec 2>&1

DSIDENTIFY="/usr/lib/cloud-init/ds-identify"
if [ ! -x $DSIDENTIFY ]; then
  DSIDENTIFY="$(find /usr -path '*/cloud-init/ds-identify' | head -n 1)"
fi

export DEBUG_PROC_CMDLINE
DEBUG_LEVEL="$CLEAN" DI_LOG=stderr $DSIDENTIFY --force

cloud-init --version
cloud-init init --local
cloud-init init
cloud-init modules --mode=config
cloud-init modules --mode=final

cloud-init analyze show
cloud-id -j

if [ "nocloud" != "$(cloud-id | tr -d '\n')" ]; then
  echo "cloud-id should be nocloud!"
  exit 1
fi
