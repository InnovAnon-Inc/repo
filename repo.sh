#! /bin/bash
set -exu
[[ $# -eq 1 ]]
REPO=$1

#[[ -d $REPO/`dpkg --print-architecture` ]] ||
[[ -e $REPO/`dpkg --print-architecture` ]] ||
mkdir -pv $REPO/`dpkg --print-architecture`
#sudo cp -v /tmp/build/${k,,}/*/${k,,}*.deb $REPO/`dpkg --print-architecture`
cd $REPO
#rm -f /opt/KEY.gpg
#gpg --output /opt/KEY.gpg --armor --export 53F31F9711F06089\!
#apt-key add /opt/KEY.gpg
apt-ftparchive --arch `dpkg --print-architecture` packages `dpkg --print-architecture` | tee Packages > /dev/null
xz -9kf Packages
apt-ftparchive release . | tee Release > /dev/null
rm -fr InRelease
gpg --default-key 53F31F9711F06089\! --clearsign -o InRelease Release

