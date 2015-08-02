#!/bin/bash
read -p "Enter your site name : " site

while true; do
    read -p "Do you wish to make the vhost?" yn
    case $yn in
        [Yy]* ) echo "<VirtualHost *:80>
			    ServerName $site
			    DocumentRoot "/var/www/$site/public/"
			 
			    SetEnv APPLICATION_ENV "development"
			 
			    <Directory "/var/www/$site/public/">
			        DirectoryIndex index.php
			        AllowOverride All
			        Order allow,deny
			        Allow from all
			    </Directory>
				</VirtualHost>" >> /etc/apache2/sites-available/$site.conf
				cd /etc/apache2/sites-enabled/
				ln -s /etc/apache2/sites-available/$site.conf $site.conf
				/etc/init.d/apache2 restart
				echo "Remember to update your local hosts file!"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

cd /vagrant
zf create project $site
cd $site
zf enable layout
#initialise view resource
#sed -i '/APPLICATION_PATH \"\/layouts\/scripts\/\"/a resources.view[] =' /vagrant/$site/application/configs/application.ini
\cp -r /vagrant/quickstart_src/application.ini /vagrant/$site/application/configs/application.ini
#setup _initDoctype
\cp -r /vagrant/quickstart_src/Bootstrap.php /vagrant/$site/application/Bootstrap.php
\cp -r /vagrant/quickstart_src/layout.phtml /vagrant/$site/application/layouts/scripts/layout.phtml
zf configure db-adapter \
'adapter=PDO_SQLITE&dbname=APPLICATION_PATH "/../data/db/guestbook.db"' \
production
zf configure db-adapter \
'adapter=PDO_SQLITE&dbname=APPLICATION_PATH "/../data/db/guestbook-testing.db"' \
testing

zf configure db-adapter \
'adapter=PDO_SQLITE&dbname=APPLICATION_PATH "/../data/db/guestbook-dev.db"' \
development
mkdir -p data/db; chmod -R a+rwX data
\cp -r /vagrant/quickstart_src/scripts /vagrant/$site/
php /vagrant/$site/scripts/load.sqlite.php --withdata
zf create db-table Guestbook guestbook
zf create model GuestbookMapper
\cp -r /vagrant/quickstart_src/GuestbookMapper.php /vagrant/$site/application/models/GuestbookMapper.php
zf create model Guestbook
\cp -r /vagrant/quickstart_src/Guestbook.php /vagrant/$site/application/models/Guestbook.php
zf create controller Guestbook
\cp -r /vagrant/quickstart_src/GuestbookController.php /vagrant/$site/application/controllers/GuestbookController.php
\cp -r /vagrant/quickstart_src/index.phtml /vagrant/$site/application/views/scripts/guestbook/index.phtml
zf create form Guestbook
\cp -r /vagrant/quickstart_src/forms/Guestbook.php /vagrant/$site/application/forms/Guestbook.php
zf create action sign Guestbook
\cp -r /vagrant/quickstart_src/sign.phtml /vagrant/$site/application/views/scripts/guestbook/sign.phtml
