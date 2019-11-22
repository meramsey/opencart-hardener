#!/bin/bash
## Author: Michael Ramsey
## Objective: Opencart Hardener: change default admin path, Enable HTTPS, and secure permissions.
## https://gitlab.com/mikeramsey/
## 
## How to use. start script and optionally specify custom admin folder name and OpenCart document root
# ./opencart_hardener.sh customadmin /full/path/to/opencart/docroot/
# sh opencart_hardener.sh customadmin /home/username/public_html/


CUSTOMADMIN="${1:-ogadmin69}"

#Default Document root
DEFAULTDOCROOT=$($HOME/public_html); #echo $DEFAULTDOCROOT

#If no Document root specified fallback to default document root
DOCROOT="${2:-$DEFAULTDOCROOT}"

#Strip trailing slash "/" from path
DOCROOT=$(echo $DOCROOT| sed 's:/*$::')

echo user name: $USER, user home: $HOME

echo "Opencart Document Root: $DOCROOT"

echo '1. Finding current Opencart Base URL from config.php'
#define('HTTP_SERVER', 'https://domain.com/');
# https://domain.com/
OCBASEURL=$(grep HTTP_SERVER $DOCROOT/config.php | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*")

echo "Found: $OCBASEURL"

echo '2. Enable HTTPS'

echo "Enabling HTPPS in $DOCROOT/.htaccess"

#Create SSL rewrite rules file /tmp/opencartsslrewrite
cat >> /tmp/opencartsslrewrite <<EOL
# Force https everywhere
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

#Upgrade insecure requests
<ifModule mod_headers.c>
Header always set Content-Security-Policy "upgrade-insecure-requests;"
</IfModule>
EOL

#Append current htaccess rules to redirect to SSL
cat $DOCROOT/.htaccess >> /tmp/opencartsslrewrite

#backup current .htaccess
mv $DOCROOT/.htaccess $DOCROOT/.htaccess-bak_$(date '+%Y-%m-%d_%H:%M:%S')

#place new current htacces 
cp /tmp/opencartsslrewrite $DOCROOT/.htaccess

echo "Enforce HTTPS: $DOCROOT/{config.php,admin/config.php}"

sed -i 's|http:|https:|g' $DOCROOT/{config.php,admin/config.php}

# -admin/config.php

#3. Change admin to custom folder
# -admin/config.php
# define('HTTP_SERVER', 'http://domain.com/ogadmin69/');
# define('HTTPS_SERVER', 'https://domain.com/ogadmin69/');
# define('DIR_APPLICATION', '/home/username/public_html/ogadmin69/');
grep -rl '/admin/' $DOCROOT/admin/config.php | xargs sed -i "s|/admin/|/$CUSTOMADMIN/|g"


#4. Move files from $DOCROOT/admin to $DOCROOT/ogadmin69
rsync -azh --remove-source-files --info=progress2 $DOCROOT/admin/ $DOCROOT/${CUSTOMADMIN}/

#5. Remove empty admin source folders after Rsync
find $DOCROOT/admin -mindepth 1 -type d -empty -delete

#6. Setup deny alls

#Catalog
cat >> $DOCROOT/catalog/.htaccess <<EOL
<FilesMatch "\.(php|twig|txt)$">
Order Deny,Allow
Deny from all
#Allow from "your ip address"
</FilesMatch>
EOL

#Wget option
#wget -O $DOCROOT/catalog/.htaccess https://gitlab.com/mikeramsey/opencart-hardener/raw/master/catalog_htaccess

#System
cat >> $DOCROOT/system/.htaccess  <<EOL
<Files *.*>
Order Deny,Allow
Deny from all
#Allow from "your ip address"
</Files>
EOL

#Wget option
#wget -O $DOCROOT/system/.htaccess https://gitlab.com/mikeramsey/opencart-hardener/raw/master/system_htaccess

#Honeypot Original OCAdmin
cat >> $DOCROOT/admin/.htaccess  <<EOL
Order Deny,Allow
Deny from all

#rickroll hackers
ErrorDocument 403 https://www.youtube.com/watch?v=dQw4w9WgXcQ
EOL

#Wget option
#wget -O $DOCROOT/admin/.htaccess https://gitlab.com/mikeramsey/opencart-hardener/raw/master/default_admin_htacces


#Custom Admin
cat >> $DOCROOT/${CUSTOMADMIN}/.htaccess  <<EOL
Order Deny,Allow
Deny from all
# whitelist home IP address
#allow from 1.2.3.4
 
#whitelist office IP Address
#allow from 1.2.3.5

#whitelist vpn IP Address
#allow from 1.2.3.6


# softy1 NL Amsterdam
Allow from 93.158.203.109

#softy2 NL Amsterdam
Allow from 93.158.203.91

#softy3 US Miami
Allow from 144.202.38.159

#softy4 US Chicago
Allow from 8.12.16.99

#softy5 US New Jersey
Allow from 45.32.6.181

#softy6 US Seattle
Allow from 144.202.93.38

#softy7 US Los Angeles
Allow from 45.76.174.145

#softy8 AU Sydney
Allow from 149.28.162.174

#softy9 JP Tokyo
Allow from 202.182.105.46

#softy10 HK Singapore
Allow from 149.28.151.117

#softy11 FR Paris
Allow from 140.82.54.59

#softy12 DE Frankfurt
Allow from 104.238.167.21

#softy13 UK London
Allow from 45.63.101.64

#Softy14 NL Amsterdam
Allow from 93.158.203.100

#softy15 NL Amsterdam
Allow from 93.158.203.112

#softy16 CA Toronto
Allow from 155.138.147.206
ErrorDocument 403 https://www.youtube.com/watch?v=dQw4w9WgXcQ
EOL

#Wget option
#wget -O $DOCROOT/${CUSTOMADMIN}/.htaccess https://gitlab.com/mikeramsey/opencart-hardener/raw/master/custom_admin_htaccess_WTS


echo '7. Harden permissions'

#chmod 444 $DOCROOT/config.php
#chmod 444 $DOCROOT/index.php
#chmod 444 $DOCROOT/${CUSTOMADMIN}/config.php
#chmod 444 $DOCROOT/${CUSTOMADMIN}/index.php
#chmod 444 $DOCROOT/system/startup.php

chmod 444 $DOCROOT/{config.php,index.php,system/startup.php,${CUSTOMADMIN}/{config.php,index.php}}
#chmod 444 $DOCROOT/${CUSTOMADMIN}/{config.php,index.php}

