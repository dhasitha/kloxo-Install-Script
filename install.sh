echo Installing Kloxo-MR...
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
echo Configuring FTP...
yum -y downgrade pure-ftpd
sh /script/upcp
sh /script/cleanup
yum -y update
service xinetd restart
echo Installing GUI...
yum groupinstall "GNOME Desktop" -y
echo Installing XRDP...
rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install xrdp tigervnc-server -y
systemctl start xrdp
netstat -antlup | grep xrdp
systemctl enable xrdp
firewall-cmd --permanent --zone=public --add-port=3389/tcp
firewall-cmd --reload
chcon --type=bin_t /usr/sbin/xrdp
chcon --type=bin_t /usr/sbin/xrdp-sesman
echo Installing WINE...
set -o errexit
log='mktemp -t install-wine.XXXXXX.log'
ver=1.8.5
yum erase wine wine-*
yum install samba-winbind-clients -y 2>&1 >>$log
yum groupinstall 'Development Tools' -y 2>&1 >> $log
yum install libjpeg-turbo-devel libtiff-devel freetype-devel -y 2>&1 >> $log
yum install glibc-devel.{i686,x86_64} libgcc.{i686,x86_64} libX11-devel.{i686,x86_64} freetype-devel.{i686,x86_64} gnutls-devel.{i686,x86_64} libxml2-devel.{i686,x86_64} libjpeg-turbo-devel.{i686,x86_64} libpng-devel.{i686,x86_64} libXrender-devel.{i686,x86_64} -y 2>&1 >> $log
cd /usr/src 2>&1 >> $log
wget http://dl.winehq.org/wine/source/1.8/wine-${ver}.tar.bz2 -O wine-${ver}.tar.bz2 2>&1 >> $log
tar xjf wine-${ver}.tar.bz2 2>&1 >> $log
cd wine-${ver}/ 2>&1 >> $log
mkdir -p wine32 wine64 2>&1 >> $log
cd wine64 2>&1 >> $log
../configure --enable-win64 2>&1 >> $log
make -j 4 2>&1 >> $log
cd ../wine32 2>&1 >> $log
../configure --with-wine64=../wine64 2>&1 >> $log
make -j 4 2>&1 >> $log
make install 2>&1 >> $log
cd ../wine64 2>&1 >> $log
make install 2>&1 >> $log
rm -f $log
read -p "Installation Complete, press [enter] to reboot..."
reboot
