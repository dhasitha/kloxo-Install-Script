#!/bin/bash
#
echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
echo _/                                                                          _/
echo _/ Installing Kloxo-MR...                                                   _/
echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

cd /
yum update -y
yum install yum-utils yum-priorities vim-minimal subversion curl zip unzip -y
yum install telnet wget -y
setenforce 0
wget https://github.com/mustafaramadhan/kloxo/raw/rpms/release/neutral/noarch/mratwork-release-0.0.1-1.noarch.rpm --no-check-certificate
rpm -ivh mratwork-release-0.0.1-1.noarch.rpm
yum clean all
yum update mratwork-* -y
yum install kloxomr7 -y
sh /script/upcp

echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
echo _/                                                                          _/
echo _/ Configuring FTP...                                                       _/
echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
yum -y downgrade pure-ftpd
sh /script/upcp
sh /script/cleanup
yum -y update
service xinetd restart

echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
echo _/                                                                          _/
echo _/ Installing GUI...                                                        _/
echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
yum groupinstall "Server with GUI" -y
systemctl set-default graphical.target
systemctl isolate graphical.target

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
echo _/ Installing XRDP...                                                       _/
echo _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm
yum install xrdp tigervnc-server -y
systemctl start xrdp
systemctl enable xrdp
firewall-cmd --permanent --zone=public --add-port=3389/tcp
firewall-cmd --reload
chcon --type=bin_t /usr/sbin/xrdp
chcon --type=bin_t /usr/sbin/xrdp-sesman
netstat -antlup | grep xrdp
echo  _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
echo  _/                                                                          _/
echo  _/ Congratulations. Kloxo-MR has been installed succesfully as 'MASTER'     _/
echo  _/                                                                          _/
echo  _/ You can connect to the server at:                                        _/
echo  _/     https://IP-Address:7777 - secure ssl connection, or                  _/
echo  _/     http://IP-Address:7778 - normal one.                                 _/
echo  _/                                                                          _/
echo  _/ The login and password are 'admin' and 'admin' for new install.          _/
echo  _/ After Logging in, you will have to change your password to               _/
echo  _/ something more secure.                                                   _/
echo  _/                                                                          _/
echo  _/ - Run 'sh /script/mysql-convert --engine=myisam' to minimize MySQL       _/
echo  _/   memory usage. Or, go to 'Webserver Configure'                          _/
echo  _/ - Run 'sh /script/make-slave' for change to 'SLAVE'                      _/
echo  _/                                                                          _/
echo  _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
read -p "Installation Complete, press [enter] to reboot..."
reboot
