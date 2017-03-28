#!/bin/bash
#
echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
echo _/                                                                          _/
echo _/ Installing GUI...                                                        _/
echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

yum -y install epel-release
yum -y update
yum clean all
yum groupinstall "GNOME Desktop" "Graphical Administration Tools" -y
# systemctl set-default graphical.target
# systemctl isolate graphical.target
# sudo yum update -y

echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
echo _/                                                                          _/
echo _/ Installing NoMachine...                                                  _/
echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

wget http://download.nomachine.com/download/5.2/Linux/nomachine_5.2.11_1_x86_64.rpm
sudo yum install nomachine_5.2.11_1_x86_64.rpm -y

echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
echo _/                                                                          _/
echo _/ Installing WINE...                                                       _/
echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

cd /
set -o errexit
yum erase wine wine-*
yum install samba-winbind-clients -y
yum groupinstall 'Development Tools' -y
yum install libjpeg-turbo-devel -y
yum install libtiff-devel -y
yum install freetype-devel -y
yum install glibc-devel.{i686,x86_64} -y
yum install libgcc.{i686,x86_64} -y
yum install libX11-devel.{i686,x86_64} -y
yum install freetype-devel.{i686,x86_64} -y
yum install gnutls-devel.{i686,x86_64} -y
yum install libxml2-devel.{i686,x86_64} -y
yum install libjpeg-turbo-devel.{i686,x86_64} -y
yum install libpng-devel.{i686,x86_64} -y 
yum install libXrender-devel.{i686,x86_64} -y
cd /usr/src
ver=2.0
wget http://dl.winehq.org/wine/source/2.0/wine-${ver}.tar.bz2 -O wine-${ver}.tar.bz2
tar xjf wine-${ver}.tar.bz2
cd wine-${ver}/
mkdir -p wine32 wine64
cd wine64
../configure --enable-win64
make -j 4
cd ../wine32
../configure --with-wine64=../wine64
make -j 4
make install
cd ../wine64
make install

echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
echo _/                                                                          _/
echo _/ Installing Kloxo-MR...                                                   _/
echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

cd /
yum update -y
yum install yum-utils yum-priorities vim-minimal subversion curl zip unzip -y
yum install telnet wget -y
cd /tmp
rm -f mratwork*
rpm -ivh https://github.com/mustafaramadhan/rpms/raw/master/mratwork/release/neutral/noarch/mratwork-release-0.0.1-1.noarch.rpm
cd /
yum clean all
yum update mratwork-* -y
yum install kloxomr7 -y
sh /script/upcp

read -p "Installation Complete, press [enter] to reboot..."
reboot
