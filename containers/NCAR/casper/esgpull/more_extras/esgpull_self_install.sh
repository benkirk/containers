#!/bin/bash

[[ $# == 1 ]] || { echo "Usage: $0 <path>"; exit 1; }

ESGPULL_INST_PATH=$1

which esgpull || exit 1

set -x
timestamp="$(date +%F@%H:%M)"
conffile="${HOME}/.config/esgpull/installs.json"

# remove any existing config
[ -f ${conffile} ] && mv ${conffile} ${conffile}.old.${timestamp}

esgpull --version
esgpull self install -n host ${ESGPULL_INST_PATH}

# use the "local" LLNL node as primary
esgpull config api.index_node "esgf-node.llnl.gov"

# increase concurrent downloads
esgpull config download.max_concurrent 12

# configure the data and download tmp paths.
# (best to have these on the same file system so that tmp -> data mvs are just relinks.)
esgpull config paths.data  "/glade/derecho/scratch/benkirk/esgpull_repo"
esgpull config paths.tmp   "/glade/derecho/scratch/benkirk/esgpull_repo/.tmp"

# override some defaults - use distributed & replicated sources by default.
esgpull config api.default_options.distrib "true"
esgpull config api.default_options.replica "true"

echo 'y' | esgpull config --generate

# give the log directory tmpdir-like permissions
chmod 1777 ${ESGPULL_INST_PATH}/log && ls -ld ${ESGPULL_INST_PATH}/log

esgpull search project:CMIP6 variable_id:tas experiment_id:'ssp*' member_id:r1i1p1f1 frequency:mon --detail 0

esgpull config
