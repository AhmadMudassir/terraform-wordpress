#!/bin/bash

sudo apt update -y

sudo apt install -y \
    apache2 \
    ghostscript \
    libapache2-mod-php \
    mysql-server \
    php \
    php-bcmath \
    php-curl \
    php-imagick \
    php-intl \
    php-json \
    php-mbstring \
    php-mysql \
    php-xml \
    php-zip

sudo mkdir -p /srv/www
sudo chown www-data: /srv/www
curl -s https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www

sudo mkdir -p /etc/apache2/sites-available/
cat <<EOF | sudo tee /etc/apache2/sites-available/wordpress.conf
<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
EOF

sudo a2ensite wordpress.conf
sudo a2enmod rewrite
sudo a2dissite 000-default

sudo systemctl restart apache2

# 👉 Install unzip, AWS CLI, and jq BEFORE MySQL setup
sudo apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sudo apt install -y jq

# 👉 Fetch DB password from AWS Secrets Manager
echo "Fetching DB password from Secrets Manager..."
DB_SECRET=$(aws secretsmanager get-secret-value --secret-id ahmad/wordpress/creds --region us-east-2 --query SecretString --output text)

# 👉 Parse password
DB_PASS=$(echo "$DB_SECRET" | jq -r .dbpass)

# 👉 Start MySQL and create DB/user using secret password
sudo service mysql start

sudo mysql -e "CREATE DATABASE IF NOT EXISTS wordpress;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'wpuser'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# 👉 Configure wp-config.php with the correct credentials
sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i "s/database_name_here/wordpress/" /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i "s/username_here/wpuser/" /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i "s/password_here/$DB_PASS/" /srv/www/wordpress/wp-config.php

# 👉 Inject salt keys
curl -s https://api.wordpress.org/secret-key/1.1/salt/ > temp-salt.txt
sudo -u www-data sed -i "/define( 'AUTH_KEY'/,/define( 'NONCE_SALT'/d" /srv/www/wordpress/wp-config.php
sudo -u www-data sed -i "/Authentication/r temp-salt.txt" /srv/www/wordpress/wp-config.php
sudo rm temp-salt.txt

sudo systemctl restart apache2

echo "WordPress installation completed successfully!"