#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash borgbackup

set -eu

cd "$(dirname "$(readlink -f "$0")")"

export REPOSITORY='svein@brage.info:short-term/backups/borg'
export BORG_REMOTE_PATH='bin/borg'
source /run/agenix/borgbackup

set -x

borg create -vxp --stats \
  --compression zstd \
  $REPOSITORY::'{hostname}-{now:%Y-%m-%dT%H:%M:%S}' \
  $HOME \
  --exclude '*/steamapps' \
  --exclude '*/target' \
  --exclude '*/Cache' \
  --exclude '/home/*/.cache' \
  --exclude '/home/*/.gradle' \
  --exclude '/home/*/.MCUpdater/cache' \
  --exclude '/home/*/.nox' \
  --exclude '/home/*/tmp'

borg prune -v --list $REPOSITORY --prefix '{hostname}-' \
  --keep-daily=7 --keep-weekly=8 --keep-monthly=24 \
  | grep -v '^Keeping archive:'
