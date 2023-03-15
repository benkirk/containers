#git clone --filter=blob:none --no-checkout git@gitlab-fsl.jsc.nasa.gov:CHAR/char.git
git clone --filter=blob:none --no-checkout git@gitlab-fsl.jsc.nasa.gov:CHAR/char.git char-wo_testing

cd char-wo_testing

git sparse-checkout init --no-cone

# cat .git/info/sparse-checkout

# include everything except regression, verification directories.
cat > .git/info/sparse-checkout <<EOF
/*
/*/
!/regression/*/
!/verification/*/
!/testing/*/
EOF

git read-tree -vmu HEAD
du -hs ../char-wo_testing
for tag in "Orion_release_to_LM_12.1.2017_r7508" "Orion_release_to_LM_2.28.2019_r8627"; do
    branch=${tag%_*}
    git checkout -b ${branch} ${tag}
    du -hs ../char-wo_testing
done
git checkout -b devel origin/devel
du -hs ../char-wo_testing
