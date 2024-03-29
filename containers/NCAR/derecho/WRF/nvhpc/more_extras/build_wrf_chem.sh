#!/bin/bash -l

#----------------------------------------------------------------------------
# environment
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#----------------------------------------------------------------------------

cd ${SCRIPTDIR} && echo "Building WRF-Chem in $(pwd)" || exit 1

[ -f /container/config_env.sh ] && . /container/config_env.sh

which mpif90 || { echo "Cannot locate an MPI compiler - check your environment?!"; exit 1; }

export WRFIO_NCD_LARGE_FILE_SUPPORT=1
export WRF_CHEM=1
export WRF_EM_CORE=1
export WRF_KPP=1
export WRF_NMM_CORE=0

git clean -xdf .

outdir=/container/wrf-chem-${WRF_VERSION}
rm -rf ${outdir} && mkdir -p ${outdir} || exit 1
rsync -ax ./run/ ${outdir}/

env | sort > build-env-wrfchem.log

# ------------------------------------------------------------------------
# Please select from among the following Linux x86_64 options:

#   1. (serial)   2. (smpar)   3. (dmpar)   4. (dm+sm)   PGI (pgf90/gcc)
#   5. (serial)   6. (smpar)   7. (dmpar)   8. (dm+sm)   PGI (pgf90/pgcc): SGI MPT
#   9. (serial)  10. (smpar)  11. (dmpar)  12. (dm+sm)   PGI (pgf90/gcc): PGI accelerator
#  13. (serial)  14. (smpar)  15. (dmpar)  16. (dm+sm)   INTEL (ifort/icc)
#                                          17. (dm+sm)   INTEL (ifort/icc): Xeon Phi (MIC architecture)
#  18. (serial)  19. (smpar)  20. (dmpar)  21. (dm+sm)   INTEL (ifort/icc): Xeon (SNB with AVX mods)
#  22. (serial)  23. (smpar)  24. (dmpar)  25. (dm+sm)   INTEL (ifort/icc): SGI MPT
#  26. (serial)  27. (smpar)  28. (dmpar)  29. (dm+sm)   INTEL (ifort/icc): IBM POE
#  30. (serial)               31. (dmpar)                PATHSCALE (pathf90/pathcc)
#  32. (serial)  33. (smpar)  34. (dmpar)  35. (dm+sm)   GNU (gfortran/gcc)
#  36. (serial)  37. (smpar)  38. (dmpar)  39. (dm+sm)   IBM (xlf90_r/cc_r)
#  40. (serial)  41. (smpar)  42. (dmpar)  43. (dm+sm)   PGI (ftn/gcc): Cray XC CLE
#  44. (serial)  45. (smpar)  46. (dmpar)  47. (dm+sm)   CRAY CCE (ftn $(NOOMP)/cc): Cray XE and XC
#  48. (serial)  49. (smpar)  50. (dmpar)  51. (dm+sm)   INTEL (ftn/icc): Cray XC
#  52. (serial)  53. (smpar)  54. (dmpar)  55. (dm+sm)   PGI (pgf90/pgcc)
#  56. (serial)  57. (smpar)  58. (dmpar)  59. (dm+sm)   PGI (pgf90/gcc): -f90=pgf90
#  60. (serial)  61. (smpar)  62. (dmpar)  63. (dm+sm)   PGI (pgf90/pgcc): -f90=pgf90
#  64. (serial)  65. (smpar)  66. (dmpar)  67. (dm+sm)   INTEL (ifort/icc): HSW/BDW
#  68. (serial)  69. (smpar)  70. (dmpar)  71. (dm+sm)   INTEL (ifort/icc): KNL MIC
#  72. (serial)  73. (smpar)  74. (dmpar)  75. (dm+sm)   AMD (flang/clang) :  AMD ZEN1/ ZEN2/ ZEN3 Architectures
#  76. (serial)  77. (smpar)  78. (dmpar)  79. (dm+sm)   INTEL (ifx/icx) : oneAPI LLVM
#  80. (serial)  81. (smpar)  82. (dmpar)  83. (dm+sm)   FUJITSU (frtpx/fccpx): FX10/FX100 SPARC64 IXfx/Xlfx


./configure <<EOF 2>&1 |& tee configure-wrfchem-out.log
3
1
EOF

# WRFv3 requires linking with the XDR API, on OpenSUSE that's -ltirpc
case "${WRF_VERSION}" in
    3.*)
        echo "appending -ltirpc to libs..."
        sed -i 's/-lnetcdff -lnetcdf/-lnetcdff -lnetcdf -ltirpc/g' configure.wrf
        ;;
    *)
        ;;
esac

# OK, now we have a configure.wrf file.  Manually hack it up for ./chem/ usage
# specifically, dial-down the optimization levels so than nvfortran does not hang...
cp configure.wrf configure-wrf.chem_special
sed -i 's/-O3/-O1/g' configure-wrf.chem_special
sed -i 's/-O2/-O1/g' configure-wrf.chem_special
git grep -l configure.wrf ./chem/ | xargs sed -i 's/configure.wrf/configure-wrf.chem_special/g'
git diff ./chem/

# add optimization architecture flags
# add optimization architecture flags
sed -i 's/FCOPTIM         =       -O3/FCOPTIM         =       -O3 -tp=znver3/g' configure.wrf
sed -i 's/FCOPTIM         =       -O2/FCOPTIM         =       -O2 -tp=znver3/g' configure.wrf

./compile em_real 2>&1 |& tee compile-wrfchem-out.log
#./compile em_real > compile-wrfchem-out.log 2>&1 || { cat compile-wrfchem-out.log; exit 1; }

set -x
for file in main/*.exe *.log configure.wrf; do
    cp -r ${file} ${outdir}/
done
