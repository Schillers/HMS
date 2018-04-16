#!/bin/bash
function installmrf {
#-----------------------------------------------
#
# Install the Malware Repository Freamework (MRF)
#
#-----------------------------------------------

#-----------------------------------------------
#
# Set the root password for the database
#
#-----------------------------------------------
sleep 2
echo -e "\n\n### Setting up Malware Repository Framework (MRF) webserver prerequisites... ###"
echo -e "Enter a MySQL/phpmyadmin Server Password..."
while true; do
    read -s -p "Password: " mysqlpassword
    echo
    read -s -p "Password (again): " mysqlpassword2
    echo
    [ "$mysqlpassword" = "$mysqlpassword2" ] && break
    echo "Please try again"
done

#-----------------------------------------------
#
# Set the passwords for MySQL/phpmyadmin installation
#
#-----------------------------------------------
echo debconf mysql-server/root_password password $mysqlpassword | debconf-set-selections
echo debconf mysql-server/root_password_again password $mysqlpassword | debconf-set-selections
echo phpmyadmin phpmyadmin/dbconfig-install boolean true | debconf-set-selections
echo phpmyadmin phpmyadmin/app-password-confirm password $mysqlpassword | debconf-set-selections
echo phpmyadmin phpmyadmin/mysql/admin-pass password $mysqlpassword | debconf-set-selections
echo phpmyadmin phpmyadmin/mysql/app-pass password $mysqlpassword | debconf-set-selections
echo phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2 | debconf-set-selections

#-----------------------------------------------
#
# Install webserver prerequisites
#
#-----------------------------------------------
sleep 2
echo -e "\n\n### Installing required packages for the Malware Repository Framework (MRF)... ###"
sleep 5
add-apt-repository ppa:ondrej/php -y
apt-get update
apt-get install lamp-server^ php5.6-curl phpmyadmin git -y

#-----------------------------------------------
#
# Set the directories for the Malware Repository Framework (MRF) installation
#
#-----------------------------------------------
sleep 2
echo -e "\n\n### Creating Directories for Malware Repository Framework (MRF)... ###"
sleep 5
mkdir /var/www/html/mrf
mkdir /var/www/html/mrf/storage
ln -s /usr/share/phpmyadmin/ /var/www/html/mrf/phpmyadmin

#-----------------------------------------------
#
# Reconfigure Apache2 for the Malware Repository Framework (MRF) installation
#
#-----------------------------------------------
sleep 2
echo -e "\n\n### Reconfiguring Apache2 for Malware Repository Framework (MRF)... ###"
sleep 5
sed -i "s|Listen 80|Listen 8080|g" /etc/apache2/ports.conf
sed -i 's|<VirtualHost \*:80>|#<VirtualHost \*:80>|g' /etc/apache2/sites-available/000-default.conf
sed -i 's|	ServerAdmin webmaster@localhost|#	ServerAdmin webmaster@localhost|g' /etc/apache2/sites-available/000-default.conf
sed -i 's|	DocumentRoot /var/www/html|#	DocumentRoot /var/www/html|g' /etc/apache2/sites-available/000-default.conf
sed -i 's|	ErrorLog ${APACHE_LOG_DIR}/error.log|#	ErrorLog ${APACHE_LOG_DIR}/error.log|g' /etc/apache2/sites-available/000-default.conf
sed -i 's|	CustomLog ${APACHE_LOG_DIR}/access.log combined|#	CustomLog ${APACHE_LOG_DIR}/access.log combined|g' /etc/apache2/sites-available/000-default.conf
sed -i 's|</VirtualHost>|#</VirtualHost>|g' /etc/apache2/sites-available/000-default.conf
echo -e "\n\n<VirtualHost *:8080>\n\n        ServerAdmin webmaster@localhost\n        DocumentRoot /var/www/html/mrf\n\n        ErrorLog \${APACHE_LOG_DIR}/error.log\n        CustomLog \${APACHE_LOG_DIR}/access.log combined\n\n</VirtualHost>" >> /etc/apache2/sites-available/000-default.conf
service apache2 restart

#-----------------------------------------------
#
# Create 'mrf' database for the Malware Repository Framework (MRF) installation
#
#-----------------------------------------------
sleep 2
echo -e "\n\n### Creating database for Malware Repository Framework (MRF)... ###"
sleep 5
mysql -uroot -p${mysqlpassword} -e "CREATE DATABASE mrf;"

sleep 2
echo -e "\n\n### Setting up Malware Repository Framework (MRF) Ubuntu modules prerequisites... ###"
sleep 5
apt-get install python-pip -y
pip install --upgrade pip
apt-get install -y build-essential libffi-dev python python-dev python-pip \
libfuzzy-dev python-m2crypto libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev \
libwebp-dev tcl8.6-dev tk8.6-dev python-tk
pip install future pyasn1 ssdeep oletools peepdf

#-----------------------------------------------
#
# Downloading the Malware Repository Framework (MRF)
#
#-----------------------------------------------
sleep 2
echo -e "\n\n### Downloading the Malware Repository Framework (MRF) ###"
sleep 5
cd /var/www/html/mrf/
git clone https://github.com/Tigzy/malware-repo.git
cp -r malware-repo/* /var/www/html/mrf/
rm -r malware-repo*

#-----------------------------------------------
#
# Configure the src/config.php file from the Malware Repository Framework (MRF) ready for install
#
#-----------------------------------------------
sleep 2
echo -e "Enter your VirusTotal API key Server Password..."
while true; do
    read -s -p "VirusTotal API key: " virus_total_api
    echo
    read -s -p "VirusTotal API key (again): " virus_total_api2
    echo
    [ "$virus_total_api" = "$virus_total_api2" ] && break
    echo "VirusTotal API keys did not match, please try again..."
done

host_ip_addr="$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')"
sed -i "s|            \"password\" => \"\",|            \"password\" => \"$mysqlpassword\",|g" /var/www/html/mrf/src/config.php
sed -i "s|        \"baseUrl\" => \"http://localhost/mrf/\",|        \"baseUrl\" => \"http://$host_ip_addr:8080/\",|g" /var/www/html/mrf/src/config.php
sed -i "s|        \"storagePath\" => \"/path/to/samples/storage\",|        \"storagePath\" => \"/var/www/html/mrf/storage\",|g" /var/www/html/mrf/src/config.php
sed -i "s|        \"storageUrl\"  => \"http://localhost/mrf/storage/\"|        \"storageUrl\"  => \"http://$host_ip_addr:8080/storage/\"|g" /var/www/html/mrf/src/config.php
sed -i "s|			\"key\" => 'YOUR_API_KEY',|			\"key\" => '$virus_total_api',|g" /var/www/html/mrf/src/config.php

#-----------------------------------------------
#
# Restart Apache2
#
#-----------------------------------------------
chown -R www-data:www-data /var/www/html/mrf
chmod -R 777 /var/www/html/mrf/storage
service apache2 restart

#-----------------------------------------------
#
# Install the Malware Repository Framework (MRF)
#
#-----------------------------------------------
sleep 2
echo -e "\n\n### Downloading the Malware Repository Framework (MRF) ###"
sleep 5
curl -X POST http://localhost:8080/install/?install=true > /dev/null
rm -r /var/www/html/mrf/install*
}
