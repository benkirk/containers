#!/bin/bash -l

#----------------------------------------------------------------------------
# environment
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#----------------------------------------------------------------------------

cd ${SCRIPTDIR} || exit 1

[ -f /opt/local/config_env.sh ] && . /opt/local/config_env.sh

export WRFIO_NCD_LARGE_FILE_SUPPORT=1
export WRF_DIR=/opt/local/WRF

git clean -xdf .

env | sort > build-env-wps.log

# ------------------------------------------------------------------------
# Please select from among the following supported platforms.
#
#    1.  Linux x86_64, gfortran    (serial)
#    2.  Linux x86_64, gfortran    (serial_NO_GRIB2)
#    3.  Linux x86_64, gfortran    (dmpar)
#    4.  Linux x86_64, gfortran    (dmpar_NO_GRIB2)
#    5.  Linux x86_64, PGI compiler   (serial)
#    6.  Linux x86_64, PGI compiler   (serial_NO_GRIB2)
#    7.  Linux x86_64, PGI compiler   (dmpar)
#    8.  Linux x86_64, PGI compiler   (dmpar_NO_GRIB2)
#    9.  Linux x86_64, PGI compiler, SGI MPT   (serial)
#   10.  Linux x86_64, PGI compiler, SGI MPT   (serial_NO_GRIB2)
#   11.  Linux x86_64, PGI compiler, SGI MPT   (dmpar)
#   12.  Linux x86_64, PGI compiler, SGI MPT   (dmpar_NO_GRIB2)
#   13.  Linux x86_64, IA64 and Opteron    (serial)
#   14.  Linux x86_64, IA64 and Opteron    (serial_NO_GRIB2)
#   15.  Linux x86_64, IA64 and Opteron    (dmpar)
#   16.  Linux x86_64, IA64 and Opteron    (dmpar_NO_GRIB2)
#   17.  Linux x86_64, Intel compiler    (serial)
#   18.  Linux x86_64, Intel compiler    (serial_NO_GRIB2)
#   19.  Linux x86_64, Intel compiler    (dmpar)
#   20.  Linux x86_64, Intel compiler    (dmpar_NO_GRIB2)
#   21.  Linux x86_64, Intel compiler, SGI MPT    (serial)
#   22.  Linux x86_64, Intel compiler, SGI MPT    (serial_NO_GRIB2)
#   23.  Linux x86_64, Intel compiler, SGI MPT    (dmpar)
#   24.  Linux x86_64, Intel compiler, SGI MPT    (dmpar_NO_GRIB2)
#   25.  Linux x86_64, Intel compiler, IBM POE    (serial)
#   26.  Linux x86_64, Intel compiler, IBM POE    (serial_NO_GRIB2)
#   27.  Linux x86_64, Intel compiler, IBM POE    (dmpar)
#   28.  Linux x86_64, Intel compiler, IBM POE    (dmpar_NO_GRIB2)
#   29.  Linux x86_64 g95 compiler     (serial)
#   30.  Linux x86_64 g95 compiler     (serial_NO_GRIB2)
#   31.  Linux x86_64 g95 compiler     (dmpar)
#   32.  Linux x86_64 g95 compiler     (dmpar_NO_GRIB2)
#   33.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (serial)
#   34.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (serial_NO_GRIB2)
#   35.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (dmpar)
#   36.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (dmpar_NO_GRIB2)
#   37.  Cray XC CLE/Linux x86_64, Intel compiler   (serial)
#   38.  Cray XC CLE/Linux x86_64, Intel compiler   (serial_NO_GRIB2)
#   39.  Cray XC CLE/Linux x86_64, Intel compiler   (dmpar)
#   40.  Cray XC CLE/Linux x86_64, Intel compiler   (dmpar_NO_GRIB2)

./configure <<EOF 2>&1 | tee configure-wps-out.log
1
EOF

./compile > compile-wps-out.log 2>&1 || cat compile-wps-out.log && exit 1

outdir=/opt/local/wps-${WPS_VERSION}
mkdir -p ${outdir} || exit 1

for file in */src/*.exe *.log configure.wps; do
    cp -r ${file} ${outdir}
done
