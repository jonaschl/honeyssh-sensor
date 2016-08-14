#!/bin/bash
#
#settings
#
mysql_host="database"
mysql_pass=""

pot_authmode="1"
pot_sleeptime="10"

# install a packages
apt-get update -y && apt-get install -y  gcc make git  libjansson-dev libssh-dev libmysqlclient-dev  libmysqlclient18 libjansson4 libssh-4
# add user pot this is user is the normale user (runnig the pot under root is too dangerous)
addgroup --gid 2000 pot 
adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 pot
# build the pot
mkdir -p /opt/dev
(cd /opt/dev
git clone -b master https://github.com/jonaschl/SecureHoney.git 
(cd SecureHoney 
# insert the password into the config.h
sed -i s/"mysqlpassword"/"$mysql_pass"/g config.h
sed -i s/"mysqlhost"/"$mysql_host"/g config.h
sed -i s/"authmode"/"$pot_authmode"/g config.h
sed -i s/"sleeptime"/"$pot_sleeptime"/g config.h
cat config.h
chmod +x install.sh
./install.sh
))
# cleanup
apt-get remove -y git make gcc libjansson-dev libssh-dev libmysqlclient-dev
apt-get autoremove -y 
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /opt/dev/*

#lld /opt/securehoney/sshpot

# set permissions
chown -R pot:pot /opt
