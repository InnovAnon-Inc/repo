#! /usr/bin/env bash
set -exu
cd $1
#git pull origin master
#( git add . ; git commit -m 'auto update' ; git push origin master ) || :

# https://www.lpenz.org/articles/debgit/index.html

REPO=`basename ${PWD}`
PACKAGE=`basename ${PWD,,}`

rm -rf  /tmp/$PACKAGE
cp -a . /tmp/$PACKAGE
cd      /tmp/$PACKAGE

git reset --hard
git clean -dfx
git clean -dfx

cat << "BLAH"
{ cat << "EOF"
This may not be a comprehensive list, specifically:
only git collaborators are listed.
EOF
;

# https://coderwall.com/p/jt8mpq/create-authors-file-from-git
git log --format="%aN"                 | \
sort                                   | \
uniq -c                                | \
sort -rn                               | \
awk '$1>=$THRESHOLD {$1=""; print $0}' | \
cut -d" " -f2- ; } > AUTHORS

#cat > $PACKAGE.1 << "EOF"
#Use the Source, Luke!
#EOF
BLAH



# https://cd34.com/blog/programming/using-git-to-generate-an-automatic-version-number/
if [[ -z "`git tag`" ]] ; then
  git tag v1.0
  set +e
  git add .
  git commit -m tagged
  git push origin master
  set -e
fi
git describe --tags --long

revisioncount=`git log --oneline | wc -l`
projectversion=`git describe --tags --long`
#cleanversion=${projectversion%%-*}
cleanversion="`git describe --tags --long | grep -o '^v[^.]*\.[^.-]*' | sed s/^v//`"

#echo "$projectversion-$revisioncount"
#echo "$cleanversion.$revisioncount"
VERSION="$cleanversion.$revisioncount"



#PREFIX=${PACKAGE}_${VERSION}

rm -rf    /tmp/build/${PACKAGE}
mkdir -pv /tmp/build/${PACKAGE}/${VERSION}
git archive --format=tar --prefix=${PACKAGE}-${VERSION}/ master | \
xz -c1                                                          > \
          /tmp/build/${PACKAGE}/${VERSION}/${PACKAGE}-${VERSION}.tar.xz
cd        /tmp/build/${PACKAGE}/${VERSION}
tar xf    ${PACKAGE}-${VERSION}.tar.xz
cd        ${PACKAGE}-${VERSION}
./autogen.sh
./configure
make
#cd        ..
#tar af- | gzip -c9 > \
#          ${PACKAGE}-${VERSION}.tar.gz
#cd        ${PACKAGE}-${VERSION}

DEBFULLNAME='InnovAnon, Inc. (Ministries)'        \
dh_make                                           \
  --email         InnovAnon-Inc@protonmail.com    \
  --copyright     mit                             \
  --docs                                          \
  --library -y --createorig
#  --packagename   $PREFIX                         \
#  --copyright     custom                          \
#  --copyrightfile ../LICENSE                      \
#  --file          ../${PACKAGE}-${VERSION}.tar.gz \

#dpkg-depcheck -d ./configure
sed -i 's/BROKEN/1/g' debian/control
#vi debian/control
#echo 'usr/share/pkgconfig/*' > debian/not-installed
#find debian -exec grep share {} +
#cat debian/install debian/restart.install
#sed -i 'd#^usr/share/pkgconfig/\\*$#' debian/${PACKAGE}-dev.install
sed -i 'd#^usr/share/pkgconfig/\*$#' debian/${PACKAGE}-dev.install
echo 'usr/lib/*/pkgconfig/*' >> debian/${PACKAGE}-dev.install
echo 'usr/include/*'         >> debian/${PACKAGE}-dev.install
#if grep -q '\^lib_LTLIBRARIES *\+= *' src/Makefile.am ; then
#if grep -q '^lib_LTLIBRARIES *\+= *' src/Makefile.am ; then
#if grep -q 'lib_LTLIBRARIES *\+= *' src/Makefile.am ; then
#if grep -q 'lib_LTLIBRARIES \\+=' src/Makefile.am ; then
if grep -q 'lib_LTLIBRARIES +=' src/Makefile.am ; then
echo 'usr/lib/*/*.so*'       >> debian/${PACKAGE}1.install
echo 'usr/lib/*/*.a*'        >> debian/${PACKAGE}1.install
else
#sed -i 'd#^usr/lib/\\*/lib\\*\\.so\\.\\*$#' debian/${PACKAGE}-dev.install
sed -i 'd#^usr/lib/\*/lib\*\.so\.\*$#' debian/${PACKAGE}1.install
#sed -i 'd#^usr/lib/\\*/lib\\*\.so\.\\*$#' debian/${PACKAGE}-dev.install
fi
# TODO weird
#if grep -qe '^bin_PROGRAMS *= *[^ ]' -e '^bin_PROGRAMS *\+= *[^ ]' src/Makefile.am ; then
#if grep -q '^bin_PROGRAMS *\+= *' src/Makefile.am ; then
#if grep -q '\^bin_PROGRAMS *\+= *' src/Makefile.am ; then
#if grep -q '^bin_PROGRAMS *\+= *' src/Makefile.am ; then
#if grep -q 'bin_PROGRAMS *\+= *' src/Makefile.am ; then
#if grep -q 'bin_PROGRAMS \\+=' src/Makefile.am ; then
if grep -q 'bin_PROGRAMS +=' src/Makefile.am ; then
echo 'usr/bin/*'             >> debian/${PACKAGE}1.install
fi
if [[ $PACKAGE = yacs ]] ; then
#mkdir -v debian/tmp
echo 'bin/*'             >> debian/${PACKAGE}1.install
fi
if [[ -e m4/doxygen.cfg ]] ; then
#echo 'doxygen-doc/man/man1/*.1' >> debian/${PACKAGE}-doc.install
#echo 'doxygen-doc/man/man1/*.*' >> debian/manpages
echo 'doxygen-doc/man/man1/*' >> debian/manpages

#echo 'doxygen-doc/html/*' >> debian/${PACKAGE}.docs

sed -e '/Format.*sgml/d' \
    -e '/Files:.*sgml/d' \
    -e '/Format.*text/d' \
    -e '/Files:.*text/d' \
    -e 's/\.ps\.gz/\.ps/' \
    debian/${PACKAGE}.doc-base.EX >> debian/${PACKAGE}.doc-base
    cat >> debian/${PACKAGE}.doc-base << EOF

Format: pdf
Files: /usr/share/doc/glitter/glitter.pdf

EOF

#mkdir -pv debian/tmp/usr/share/doc/${PACKAGE}
#cp -a doxygen-doc/html debian/tmp/usr/share/doc/${PACKAGE}/
#echo "usr/share/doc/${PACKAGE}/html/*" >> debian/${PACKAGE}.docs
#echo 'doxygen-doc/html/*' >> debian/${PACKAGE}.docs
#echo "usr/share/doc/${PACKAGE}/html/*" >> debian/${PACKAGE}-docs.install

fi

cat > debian/watch << EOF
version=4

# GitHub hosted projects
opts="filenamemangle=s%(?:.*?)?v?(\d[\d.]*)\.tar\.gz%${PACKAGE}-\$1.tar.gz%" \\
   https://github.com/InnovAnon-Inc/${REPO}/tags \\
   (?:.*?/)?v?(\d[\d.]*)\.tar\.gz debian uupdate
EOF

# copyright: where to get the package and license
# changelog: email

#debuild                   \
dpkg-buildpackage         \
  --root-command=fakeroot \
  --compression-level=9   \
  --compression=xz        \
  --sign-key=53F31F9711F06089\!
#  --sign-key=38BBDB7C15E81F38AAF6B7E614F31DFAC260053E
#  --sign-key=14F31DFAC260053E
#  --sign-key=27FB3DF3B6F32E8C
#  --sign-key=27FB3DF3B6F32E8C!
#  --sign-key='InnovAnon-Inc@protonmail.com'

#sudo dpkg -i ${PACKAGE}_${VERSION}-1_amd64.deb
