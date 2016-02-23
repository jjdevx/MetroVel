#!/usr/bin/env bash

dpkg-reconfigure locales
apt-get install -qq locales
apt-get install -qq util-linux-locales
echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
echo "LANG=en_US.UTF-8" >> /etc/default/locale
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

apt-get update
apt-get install -qq curl unzip git-core ack-grep software-properties-common \
build-essential dbus nano aptitude supervisor
apt-get install -qq ntp ntpdate
service apparmor stop
update-rc.d -f apparmor remove
apt-get remove -qq apparmor apparmor-utils

apt-get install -qq unattended-upgrades
echo "APT::Periodic::Unattended-Upgrade \"1\";" >> /etc/apt/apt.conf.d/10periodic


GROUP=$(id -Gn)
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
add-apt-repository -y ppa:ondrej/php5-5.6
apt-key update
aptitude update
aptitude install -y php5-cli php5-fpm php5-mysql php5-pgsql php5-sqlite php5-curl php5-gd php5-gmp \
php5-mcrypt php5-memcached php5-imagick php5-intl php-pear php5-imap php5-memcache php5-pspell \
php5-recode php5-snmp php5-tidy php5-xmlrpc php5-xsl snmp

php5enmod mcrypt
aptitude install -y php-apc
sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf
sed -i 's/;listen.allowed_clients/listen.allowed_clients/' /etc/php5/fpm/pool.d/www.conf
sed -i "s/listen\.owner.*/listen.owner = www-data/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = www-data/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php5/fpm/pool.d/www.conf
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini
sed -i "s/;date.timezone =.*/date.timezone = \"UTC\"/" /etc/php5/fpm/php.ini
sed -i "s/;date.timezone =.*/date.timezone = \"UTC\"/" /etc/php5/cli/php.ini
sed -i "/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0" /etc/php5/fpm/php.ini
service php5-fpm restart
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

curl -sL https://deb.nodesource.com/setup | bash -
aptitude install -y nodejs
echo -e "\033[1;31;40m Instalacion de Paquetes NPM \033[0m"
npm install -g bower gulp

wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
rm nginx_signing.key
echo -e "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list
aptitude update
aptitude install -y nginx

usermod -a -G www-data vagrant

mkdir -p /home/vagrant/logs
touch /home/vagrant/logs/access.log
touch /home/vagrant/logs/error.log

cd /vagrant/storage && find . -type d -exec chmod 775 {} \; && find . -type f -exec chmod 664 {} \;
cd /vagrant/storage && chown vagrant:vagrant .gitignore logs/.gitignore

chmod -R 777 /vagrant/storage

chgrp www-data /vagrant

chown -R www-data:www-data /vagrant/storage

SSL_DIR="/etc/ssl"
DOMAIN="*.xip.io"
PASSPHRASE="ubuntubastion"
SUBJ="
C=US
ST=Connecticut
O=Vaprobash
localityName=New Haven
commonName=bastion
organizationalUnitName=
emailAddress=
"
mkdir -p "$SSL_DIR"
openssl genrsa -out "$SSL_DIR/ssl.key" 1024
openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/ssl.key" -out "$SSL_DIR/ssl.csr" -passin pass:$PASSPHRASE
openssl x509 -req -days 365 -in "$SSL_DIR/ssl.csr" -signkey "$SSL_DIR/ssl.key" -out "$SSL_DIR/ssl.crt"

> /etc/nginx/conf.d/default.conf
cat <<EOF >/etc/nginx/conf.d/default.conf
server {
    listen 80;
    root /vagrant/public;
    index index.php;

    server_name metrolaravel.dev;
    access_log /home/vagrant/logs/access.log;
    error_log  /home/vagrant/logs/error.log error;
    charset utf-8;
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt  { access_log off; log_not_found off; }
    error_page 404 /index.php;
    # pass the PHP scripts to php5-fpm
    # Note: \.php$ is susceptible to file upload attacks
    # Consider using: "location ~ ^/(index|app|app_dev|config)\.php(/|$) {"
    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        # With php5-fpm:
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param LARA_ENV local; # Environment variable for Laravel
        fastcgi_param HTTPS off;
    }
    # Deny .htaccess file access
    location ~ /\.ht {
        deny all;
    }
    location = /nginx_status {
        stub_status on;
        allow 127.0.0.1;
        deny all;
    }

}
EOF

service php5-fpm restart
service nginx restart

echo ">>> Installing SQLite Server"

# Install SQL lite
apt-get install -qq sqlite

cd /vagrant && composer install
cp /vagrant/.env.example /vagrant/.env

cd /vagrant && php artisan cache:clear

service nginx restart
service php5-fpm restart
