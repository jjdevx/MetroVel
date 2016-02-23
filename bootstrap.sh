#!/usr/bin/env bash

echo ">>> Installing SQLite Server"

# Install SQL lite
sudo apt-get install -qq sqlite

cd /vagrant && composer install
mv /vagrant/.env.example /vagrant/.env
php artisan key:generate