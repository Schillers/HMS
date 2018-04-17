#!/bin/bash
source ./managementserver/installmrf.sh
source ./managementserver/installmhn.sh
source ./managementserver/installsnake.sh

#-----------------------------------------------
#
# Show title banner
#
#-----------------------------------------------
clear
echo -e "#########################################################"
echo -e "##                                                     ##"
echo -e "##          H.M.S - Honeynet Management Suite          ##"
echo -e "##                                                     ##"
echo -e "##           https://github.com/Schillers/HMS          ##"
echo -e "##                                                     ##"
echo -e "#########################################################"
sleep 5

#-----------------------------------------------
#
# Checking is user is running as root
#
#-----------------------------------------------
echo -e "\n\n### Checking if running as root user... ###"
if [ "$EUID" -ne 0 ]
  then read -n 1 -s -r -p "Please run as root. Press any key to continue..."
  clear
  exit 1
else
  echo -e "Check complete..."
fi

#-----------------------------------------------
#
# Prepare the system for install
#
#-----------------------------------------------
sleep 2
echo -e "\n\n### Updating your system and preparing for install ###"
sleep 5
apt-get update
apt-get upgrade -y
apt-get install nano git -y

sleep 2
read -r -p "\n\n### Would you like to install Snake? [Y/n] ###" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY]|)+$ ]]
then
    installsnake
else
    :
fi

sleep 2
read -r -p "\n\n### Would you like to install the Malware Repository Framework (MRF)? [Y/n] ###" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY]|)+$ ]]
then
    installmrf
else
    :
fi

sleep 2
read -r -p "\n\n### Would you like to install the Modern Honey Network (MHN)? ### [Y/n] ###" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY]|)+$ ]]
then
    installmhn
else
    :
fi

#-----------------------------------------------
#
# Exit the installation script
#
#-----------------------------------------------
echo -e "#########################################################"
echo -e "##                                                     ##"
echo -e "##                Thank you for using HMS              ##"
echo -e "##                                                     ##"
echo -e "##          H.M.S - Honeynet Management Suite          ##"
echo -e "##                                                     ##"
echo -e "##           https://github.com/Schillers/HMS          ##"
echo -e "##                                                     ##"
echo -e "#########################################################"
sleep 5
