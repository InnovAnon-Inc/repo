#! /bin/bash
set -exu
#USE_REPO=0
USE_REPO=1

[[ $USE_REPO -eq 0 ]] ||
sudo rm -rf /opt/repo

sudo rm -rf /tmp/build

#for k in glitter restart EZIO swap MultiMalloc StD Array ezparse AVA CAQ CHeap PArray CPAQ C-Thread-Pool DArr ezfork SFork DFork YACS DOS EVIO network eztcp ezudp iSqrt kahan lunar RW2ChIPC RW2ChIPCStd RW2ChIPCStdExec shell SLL solar TSCPAQ ThIpe ThrEll ThrEv ThrIO ZePaSt ; doA
#for k in glitter restart EZIO swap MultiMalloc StD Array ezparse     CAQ CHeap PArray CPAQ C-Thread-Pool DArr ezfork SFork DFork YACS DOS EVIO network eztcp ezudp iSqrt kahan       RW2ChIPC RW2ChIPCStd RW2ChIPCStdExec shell SLL       TSCPAQ ThIpe ThrEll ThrEv ThrIO ZePaSt ; do
#for k in lunar ; do
#for k in AVA ; do
for k in glitter ; do

( set +e
  cd ~/src/$k/
  git pull origin master
  git add .
  git commit -m pkgconfig
  git push origin master )
set -e
sudo -u cis -i \
~/src/dpkg.sh ~/src/$k
if [[ $USE_REPO -eq 0 ]] ; then
sudo dpkg -i /tmp/build/${k,,}/*/${k,,}*.deb
else
[[ -d /opt/repo/amd64 ]] ||
sudo mkdir -pv /opt/repo/amd64
sudo cp -v /tmp/build/${k,,}/*/${k,,}*.deb /opt/repo/amd64
( cd /opt/repo
  #dpkg-scanpackages . /dev/null | xz -9c | sudo tee Packages.xz > /dev/null
  sudo rm -f /opt/KEY.gpg
  #sudo gpg --output /opt/KEY.gpg --armor --export 38BBDB7C15E81F38AAF6B7E614F31DFAC260053E
  sudo gpg --output /opt/KEY.gpg --armor --export 53F31F9711F06089\!
  sudo apt-key add /opt/KEY.gpg
  apt-ftparchive --arch amd64 packages amd64 | sudo tee Packages > /dev/null
  sudo xz -9kf Packages
  apt-ftparchive release . | sudo tee Release > /dev/null
  sudo rm -fr InRelease
  #sudo gpg --default-key 38BBDB7C15E81F38AAF6B7E614F31DFAC260053E --clearsign -o InRelease Release
  sudo gpg --default-key 53F31F9711F06089\! --clearsign -o InRelease Release
)
sudo apt-fast update
DEBS="${k,,}1 ${k,,}-dev ${k,,}-doc"
sudo apt-fast install --reinstall --yes $DEBS
fi
#pkg-config --libs ${k,,}

done

