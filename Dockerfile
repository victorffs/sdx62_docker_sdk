FROM ubuntu:18.04

LABEL maintainer="Victor Fragoso"

ARG DEBIAN_FRONTEND=noninteractive

# Install software requirements
RUN apt-get update -y

RUN apt-get install -y \
build-essential \
gawk \
wget \
git-core \
git \
diffstat \
unzip \
texinfo \
build-essential \
chrpath \
libsdl1.2-dev \
xterm \
make \
xsltproc \
docbook-utils \
fop \
python3 \
gcc-7 \
g++-7 \
chrpath \
texinfo \
libncurses5-dev \
libncursesw5-dev \
tmux \
cpio \
locales \
#### additional tools
unzip \
wget \
curl \
vim \
sudo \
uuid-dev

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Adding symbolic link
RUN ln -sf /bin/bash /bin/sh
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Transfer folder
RUN mkdir -p /tmp/shared
VOLUME ["/tmp/shared"]

# sources
RUN mkdir -p /home/openlinux
VOLUME ["/home/openlinux"]
WORKDIR /home/openlinux
RUN cd /home/openlinux

# Install croostools
#COPY docs_and_tools/Fibocom_Appcation_V1.0.0.zip /usr/src/
RUN mkdir -p /usr/src/toolchain
COPY docs_and_tools/fibocom_appcation_build/toolchain/nogplv3-debug-x86_64-qti-mbb-image-armv7vet2hf-neon-sdxlemur-toolchain-2-106-g7b8612028a.sh /usr/src/toolchain/
#RUN unzip /usr/src/Fibocom_Appcation_V1.0.0.zip -d /usr/src/
RUN chmod +x /usr/src/toolchain/nogplv3-debug-x86_64-qti-mbb-image-armv7vet2hf-neon-sdxlemur-toolchain-2-106-g7b8612028a.sh
RUN /usr/src/toolchain/nogplv3-debug-x86_64-qti-mbb-image-armv7vet2hf-neon-sdxlemur-toolchain-2-106-g7b8612028a.sh -y

# Bitbake cant run as sudo
RUN useradd -s /bin/bash openlinux
RUN adduser openlinux sudo
RUN echo 'openlinux:openlinux' | chpasswd

USER openlinux

# How to build
# docker build -t sdx62_sdk -f Dockerfile .

# How to run
# docker run -di --name sdx62_sdk --mount type=bind,source=$PWD/,target=/home/openlinux sdx62_sdk:latest &

# How to start and execute
# docker start sdx62_sdk && docker exec -it sdx62_sdk bash

# To check current environmental variables
# printenv

# Compilando em um subshell sem interferir nas veriaveis de ambiente do sistema inteiro:
# (source /usr/local/nogplv3-debug-x86_64/environment-setup-armv7vet2hf-neon-oe-linux-gnueabi && make)
