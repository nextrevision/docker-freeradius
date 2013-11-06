#!/bin/bash

FR_SRC_URL="ftp://ftp.freeradius.org/../pub/freeradius/old/freeradius-server-2.2.1.tar.gz"

apt-get update
apt-get -y install build-essential net-tools tcpdump lsb-base\
  libc6 libgdbm3 libltdl7 libpam0g libperl5.14 libpython2.7\
  libssl1.0.0 ssl-cert ca-certificates adduser libmhash-dev\
  libperl-dev libssl-dev libpam-dev libgdb-dev libgdbm-dev

cd /root
wget ftp://ftp.freeradius.org/../pub/freeradius/old/freeradius-server-2.2.1.tar.gz
tar xzf freeradius-server-*.tar.gz
cd freeradius-server*

./configure
make
make install

ldconfig

useradd radius
mkdir /var/log/radius
touch /var/log/radius/radius.log
chown -R radius: /var/log/radius
chown -R radius: /usr/local/etc/raddb
chown -R radius: /usr/local/var/run/radiusd
# -xx turns on debugging, not good in production, but useful for our HAproxy testing
echo 'FREERADIUS_OPTIONS="-xx -l /var/log/radius/radius.log"' > /etc/default/radiusd

wget https://raw.github.com/nextrevision/docker-freeradius/master/scripts/init_script 

install -o root -g root -m 0755 init_script /etc/init.d/radiusd

chmod 755 /etc/init.d/radiusd
update-rc.d radiusd defaults

cat >> /usr/local/etc/raddb/clients.conf << EOF
client 0.0.0.0/0 {
  secret    = supersecret
  shortname = everyone
}
EOF

cat >> /usr/local/etc/raddb/users << EOF
user1   Cleartext-Password := "secretpass"
        Reply-Message = "Hello, %{User-Name}, the auth was successful!"
EOF

service radiusd start
