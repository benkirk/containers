#!/bin/bash

echo "CC=$CC"
echo "CC=$FC"

git clone https://github.com/mmbell/samurai || exit 1

cd samurai || exit 1

mkdir -p build && cd build || exit 1


cmake3 -DnetCDF_INSTALL_PREFIX=/usr .. || exit 1

make -j 8 VERBOSE=1 || exit 1

ln -sf $(pwd)/release/bin/samurai ../bin || exit 1
