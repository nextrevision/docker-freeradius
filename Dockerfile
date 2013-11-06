FROM ubuntu
RUN apt-get update -y
RUN apt-get install wget
RUN wget https://raw.github.com/nextrevision/docker-freeradius/master/scripts/install_freeradius.sh
RUN chmod 755 install_freeradius.sh
RUN ./install_freeradius.sh
