#!/bin/bash


cat <<EOF > rpmlist.tmp
$(ssh casper.hpc.ucar.edu rpm -qa 2>/dev/null || echo "Cannot connect")
EOF

grep "Cannot connect" rpmlist.tmp && exit 1

exit 0
