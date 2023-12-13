#!/bin/bash

[[ $# == 1 ]] || { echo "Usage: $0 <path>"; exit 1; }

ESGPULL_INST_PATH=$1

which esgpull || exit 1

set -x
esgpull --version
esgpull self install -n host ${ESGPULL_INST_PATH}

esgpull config api.index_node esgf-node.llnl.gov

esgpull config paths.data /glade/collections/cmpipfoo/

echo 'y' | esgpull config --generate

esgpull search project:CMIP6 variable_id:tas experiment_id:'ssp*' member_id:r1i1p1f1 frequency:mon --detail 0

esgpull config

#mkdir -p ${ESGPULL_INST_PATH}/etc
#cd ${ESGPULL_INST_PATH}
#mv config.toml config_container.toml
#cp config_container.toml config_host.toml
#sed -i 's/container/host/g' config_host.toml
#ln -s config_container.toml config.toml
