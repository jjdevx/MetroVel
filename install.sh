#!/usr/bin/env bash

apt-get install -qq language-pack-en-base
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
apt-get update
apt-get install -qq php7.0 php7.0-cli php7.0-fpm php7.0-pgsql php7.0-curl php7.0-gd php7.0-gmp php7.0-mcrypt php7.0-intl