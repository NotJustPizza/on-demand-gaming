FROM ubuntu:22.04

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# Auto-approve license agreement
RUN echo steam steam/question select "I AGREE" | debconf-set-selections
RUN echo steam steam/license note '' | debconf-set-selections

RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get install wget gnupg2 ca-certificates steamcmd -y --no-install-recommends && \
    apt-get clean

# Create symlink for steamcmd
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

# Using old repo for GCC 5 reqired by Avorion
RUN echo "deb http://archive.ubuntu.com/ubuntu/ xenial main" > /etc/apt/sources.list.d/xenial-archive.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5

RUN apt-get update && \
    apt-get install gcc-5 g++-5 -y --no-install-recommends && \
    apt-get clean

# Finally, add game server files
WORKDIR /opt/avorion

RUN steamcmd +login anonymous +force_install_dir /opt/avorion +app_update 565060 validate +exit

CMD ["./server.sh", "--datapath", "/data"]

HEALTHCHECK NONE
