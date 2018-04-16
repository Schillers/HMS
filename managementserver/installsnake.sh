#!/bin/bash
function installsnake {
#-----------------------------------------------
#
# Install Snake
#
#-----------------------------------------------
cd
sleep 2
echo -e "\n\n### Downloading and installing Snake prerequisites... ###"
sleep 5

#-----------------------------------------------
#
# Install curl
#
#-----------------------------------------------
apt-get install curl

#-----------------------------------------------
#
# Add repository for MongoDB 3.6
#
#-----------------------------------------------
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list

#-----------------------------------------------
#
# Add repository for nodejs 8
#
#-----------------------------------------------
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

#-----------------------------------------------
#
# Install dependencies
#
#-----------------------------------------------
apt-get update
apt-get install -y libyaml-dev mongodb-org nodejs python3-dev python3-pip redis-server libfuzzy-dev ssdeep nginx

#-----------------------------------------------
#
# Update pip and setuptools
#
#-----------------------------------------------
sudo -H pip3 install --upgrade pip setuptools


sleep 2
echo -e "\n\n### Downloading and installing Snake... ###"
sleep 5
#-----------------------------------------------
#
# Install Snake
#
#-----------------------------------------------
git clone https://github.com/countercept/snake.git
cd snake
sudo sys/install.sh

HOST_IP_ADDR="$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | grep -v '10.0.*' | cut -d: -f2 | awk '{ print $1}')"
APP_JS_FILENAME=$(find /var/www/snake-skin/static/js/ -type f -name app.*.js)

sleep 2
echo -e "\n\n### Configuring Snake to run on $HOST_IP_ADDR:8000... ###"
sleep 5
sed -i "s|127.0.0.1|$HOST_IP_ADDR|g" /etc/snake/snake.conf
sed -i "s|127.0.0.1|$HOST_IP_ADDR|g" $APP_JS_FILENAME

#-----------------------------------------------
#
# Start Snake Pit, Snake and required services
#
#-----------------------------------------------
systemctl start mongod
systemctl start snake-pit
systemctl start snake

#-----------------------------------------------
#
# Start Nginx to host Snake Skin
#
#-----------------------------------------------
systemctl stop nginx
systemctl start nginx

cd ~
}
