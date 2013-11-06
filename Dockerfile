FROM ubuntu
RUN apt-get update -y
RUN apt-get -y install build-essential net-tools tcpdump lsb-base libc6 libgdbm3 libltdl7 libpam0g libperl5.14 libpython2.7 libssl1.0.0 ssl-cert ca-certificates adduser wget libmhash-dev libperl-dev libssl-dev libpam-dev libgdb-dev libgdbm-dev

RUN wget 
