#!/usr/bin/env sh

# include common definitions
# shellcheck source=scripts/core/sxmo_common.sh
. "$(dirname "$0")/sxmo_common.sh"

#echo "$LOGDIR"/modemlog.tsv
#termite -e tail "$LOGDIR"/modemlog.tsv
echo $LOGDIR
tty | grep tty && termite --name=sxmo_log -e "less +G $LOGDIR/modemlog.tsv" ||
   less +G $LOGDIR/modemlog.tsv

