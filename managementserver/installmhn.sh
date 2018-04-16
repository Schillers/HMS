#!/bin/bash
function installmhn {
#-----------------------------------------------
#
# Install Modern Honey Network (MHN)
#
#-----------------------------------------------
cd
sleep 2
echo -e "\n\n### Downloading Modern Honey Network (MHN)... ###"
sleep 5
cd /opt/
git clone https://github.com/threatstream/mhn.git-
sleep 2
echo -e "\n\n### Installing Modern Honey Network (MHN)... ###"
sleep 5
./install.sh

sleep 2
echo -e "\n\n### Installation of Modern Honey Network (MHN) complete...\n"
echo -e "Checking the status of nginx...\n"
service nginx status

sleep 2
echo -e "Checking the status of supervisor...\n"
service supervisor status

sleep 2
echo -e "Checking the status of Modern Honey Network (MHN) processes...\n"
supervisorctl status
cd
}
