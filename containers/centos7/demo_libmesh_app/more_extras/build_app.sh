#!/bin/badh


[ -f ${STACK_CONFIG} ] && source ${STACK_CONFIG}

#------------------------------------------------------------------
# Vanilla libmesh app
cd /opt/local || exit 1
cp -r ${LIBMESH_DIR}/examples/introduction/ex4 . && cd ex4 || exit 1
make
ldd ./example-opt
mpiexec -n 4 ./example-opt -d 3 -n 50


#------------------------------------------------------------------
CHAR_SRC_DIR=${CHAR_SRC_DIR:-"/sv/char-wo_testing"}

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
