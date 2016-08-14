#!/bin/bash
#
#settings
#
mysql_host="database"
mysql_pass=""

logstash_session_host=""
logstash_session_user=""
logstash_session_password=""

logstash_login_host=""
logstash_login_user=""
logstash_login_password=""

# install a packages
apt-get update -y && apt-get install -y  gcc make git libjansson-dev  libmysqlclient-dev  libcurl4-gnutls-dev libmysqlclient18 libjansson4 libcurl3
# add user pot this is user is the normale user (runnig the pot under root is too dangerous)
addgroup --gid 2000 pot 
adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 pot
# build the pot
mkdir -p /opt/dev
(cd /opt/dev
git clone -b master https://github.com/jonaschl/honeyssh-transferdaemon.git
(cd honeyssh-transferdaemon

# insert the password into the config.h
sed -i s/"mysql_pass"/"$mysql_pass"/g config.h
sed -i s/"mysql_host"/"$mysql_host"/g config.h
sed -i 's|'logstash_session_host'|'$logstash_session_host'|g' config.h
sed -i s/"logstash_session_user"/"$logstash_session_user"/g config.h
sed -i s/"logstash_session_password"/"$logstash_session_password"/g config.h
sed -i 's|'logstash_login_host'|'$logstash_login_host'|g' config.h
sed -i s/"logstash_login_user"/"$logstash_login_user"/g config.h
sed -i s/"logstash_login_password"/"$logstash_login_password"/g config.h
cat config.h
chmod +x install.sh
./install.sh
))
# cleanup
apt-get remove -y git make gcc libjansson-dev libssh-dev libmysqlclient-dev libcurl-dev
apt-get autoremove -y 
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /opt/dev/*

# set permissions
chown -R pot:pot /opt
