#!/bin/bash


# https://possiblelossofprecision.net/?p=1300
# http://ftp.rpm.org/api/4.4.2.2/queryformat.html
# rpm -qa --queryformat "%-60{Name} %{Vendor}\n"
# rpm -qa --queryformat "%{NAME}-%{VERSION} %80{Vendor}\n"

cat <<EOF > rpmlist.tmp
$(ssh casper.hpc.ucar.edu 'rpm -qa --queryformat "%{Name},%{Vendor}\n"' 2>/dev/null || echo "Cannot connect")
EOF

grep "Cannot connect" rpmlist.tmp && exit 1

cat rpmlist.tmp | sort > rpmlist.tmp2 && mv rpmlist.tmp{2,}
cat rpmlist.tmp | grep -i "SUSE" > rpmlist.tmp2 && mv rpmlist.tmp{2,}
cat rpmlist.tmp | cut -d',' -f1 > rpmlist.tmp2 && mv rpmlist.tmp{2,}

mv rpmlist.tmp rpmlist
cat rpmlist



exit 0
