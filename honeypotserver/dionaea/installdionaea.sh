#!/bin/bash
function installsnake {
#-----------------------------------------------
#
# Install Dionaea
#
#-----------------------------------------------
cd

sleep 2
echo -e "\n\n### Downloading and installing Dionaea prerequisites... ###"
sleep 5
#-----------------------------------------------
#
# Install Dionaea
#
#-----------------------------------------------
sudo apt-get update
sudo apt-get install autoconf automake build-essential check cython3 libcurl4-openssl-dev \
    libemu-dev libev-dev libglib2.0-dev libloudmouth1-dev libnetfilter-queue-dev libnl-3-dev \
    libpcap-dev libssl-dev libtool libudns-dev python3 python3-dev python3-bson python3-yaml \
    ttf-liberation -y

sleep 2
echo -e "\n\n### Downloading and installing Dionaea... ###"
sleep 5

#-----------------------------------------------
#
# Install Dionaea
#
#-----------------------------------------------

git clone https://github.com/DinoTools/dionaea.git
cd dionaea/

autoreconf -vi
./configure --disable-werror --prefix=/opt/dionaea --with-python=/usr/bin/python3 \
    --with-cython-dir=/usr/bin --with-ev-include=/usr/include/ --with-ev-lib=/usr/lib \
    --with-emu-lib=/usr/lib/libemu --with-emu-include=/usr/include \
    --with-nl-include=/usr/include/libnl3 --with-nl-lib=/usr/lib

make
make install

#-----------------------------------------------
#
# Configure Dionaea by removing bistream capture and nfq
#
#-----------------------------------------------
sed -i 's|modules=curl,python,nfq,emu,pcap|modules=curl,python,emu,pcap|g' /opt/dionaea/etc/dionaea/dionaea.cfg
sed 's|processors=filter_streamdumper,filter_emu|processors=filter_emu|g' /opt/dionaea/etc/dionaea/dionaea.cfg

#-----------------------------------------------
#
# Configure Dionaea to restart if crashed
#
#-----------------------------------------------
sed -i '$ d' /etc/crontab
echo "* * * * * root /opt/dionaea/restartdionaea.sh" >> /etc/crontab
echo "#" >> /etc/crontab
}
