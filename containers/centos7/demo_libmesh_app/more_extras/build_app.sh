#!/bin/badh


CHAR_SRC_DIR=${CHAR_SRC_DIR:-"/sv/char-wo_testing"}

[ -f ${STACK_CONFIG} ] && source ${STACK_CONFIG}

cd ${CHAR_SRC_DIR} || exit 1
./bootstrap || exit 1


cd ${APP_STAGE_PATH} || exit 1
mkdir -p build && cd build || exit 1

${CHAR_SRC_DIR}/configure \
               --prefix=${APP_STAGE_PATH}/install \
               --enable-static --disable-shared \
               GTK_LIBS="-lgfortran" \
    || exit 1

make -j 8 -l 16. || exit 1
make install || exit 1
make check

ldd ${APP_STAGE_PATH}/install/bin/char
