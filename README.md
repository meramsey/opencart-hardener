---
description: "Opencart Hardener is designed to make securing new Opencart installs easy."
---

# OpenCart Hardener

Opencart Hardener is designed to make securing new Opencart installs easy. It configures custom admin folder, HTTPS, secures permissions, provides honeypot default admin area, and hides real admin area behind Static/VPN IP whitelist. 

## Overview

Features:
*  Custom Admin folder support (**Including [vQmod](http://docs.opencart.com/en-gb/administration/vqmod/) Support if detected**)
*  Honeypot default admin path and rickroll hackers
*  Setup SSL/HTTPS for all URLS
*  Setup deny all for System, Catalog, and sensitive files
*  Set permissions to 444 for Opencart recommended hardening.
*  Generates custom Maintenance Script in $HOME/opencart_hardener_updater_$OCBASEDOMAIN.sh. This allows for easy maintenance after extensions/mods/themes installed or after Opencart updates.
*  Supports specifying custom Opencart document root for subfolder or addon domain installs.
*  Hides the real custom Opencart Admin area behind [WTS VPN](https://whattheserver.com/vpn-service/). Can be customized with different Static/VPN IPs to ensure custom admin area is invisible to all IP's not whitelisted.

## Use cases
Great for single site owners or Devs/Sys Admins who setup and maintain alot of Opencart installs.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

* SSH access
* BASH
* WGET


### Installing

1. Download the file from Gitlab to server and account where opencart is installed:

`wget https://gitlab.com/mikeramsey/opencart-hardener/raw/master/opencart_hardener.sh`

2. Run the script with desired admin folder name and path to the opencart document root. Please Note: If no admin folder name is provided it defaults to using "cooladmin99". If no document root is provided it defaults to the current user's $HOME/public_html which is the default for primary domain on cPanel/Cyberpanel.

`sh opencart_hardener.sh <your_custom_admin_name> <your_oc_install_directory>`

Example: if we wanted admin area to be "secretadmin123" and our installation folder for Opencart was "/home/cooluserjoe/public_html/ocart2/"

`sh opencart_hardener.sh secretadmin123 /home/cooluserjoe/public_html/ocart2/`


After it completes it outputs how to reapply this after theme/mods/updates to Opencart which go into the default admin path via two commands. This script also outputs the path to the custom upgrade maintenance script. Make sure to note this down. That script is generated in the "$HOME/opencart_hardener_updater_$OCBASEDOMAIN.sh" to ensure its not publicly visible and in the public path where it can be scraped and your custom admin path is leaked.

Example of how it looks when run:
```
[cooluserjoe@cpanel ocart2]$ sh opencart_hardener.sh secretadmin123 /home/cooluserjoe/public_html/ocart2/ ;
opencart_hardener.sh: line 14: /home/cooluserjoe/public_html: Is a directory
user name: cooluserjoe, user home: /home/cooluserjoe

Opencart Document Root: /home/cooluserjoe/public_html/ocart2

1. Finding current Opencart Base URL from config.php

Found: https://example.com/ocart2/

2. Enable HTTPS

Enabling HTPPS in /home/cooluserjoe/public_html/ocart2/.htaccess

Create SSL rewrite rules tmp file /tmp/opencartsslrewrite

Append current htaccess rules to redirect to SSL

backup current .htaccess to /home/cooluserjoe/public_html/ocart2/.htaccess-bak_2019-11-23_02:06:24

Place new current htaccess with SSL rewrite rules at top

Enforce HTTPS: /home/cooluserjoe/public_html/ocart2/{config.php,admin/config.php}

3. Change admin to custom folder /home/cooluserjoe/public_html/ocart2/secretadmin123 in admin/config.php

vQmod file /home/cooluserjoe/public_html/ocart2/vqmod/pathReplaces.php exists. Configuring with custom admin path

4. Move files from /home/cooluserjoe/public_html/ocart2/admin to /home/cooluserjoe/public_html/ocart2/secretadmin123
            112 100%    0.00kB/s    0:00:00 (xfr#1, to-chk=0/2)

5. Remove empty admin source folders after admin folder moved

6. Setup deny alls for Catalog,System,default admin folder

7. Harden permissions

OpenCart Hardening completed!

New OpenCart Admin login page: https://example.com/ocart2/secretadmin123
New OpenCart Admin path: /home/cooluserjoe/public_html/ocart2/secretadmin123


After upgrading or installing plugins themes run the custom upgrade bash script: /home/cooluserjoe/opencart_hardener_updater_example.com.sh

Or run the below commands manually to move files from default admin to custom admin folder

rsync -azh --remove-source-files --info=progress2 /home/cooluserjoe/public_html/ocart2/admin/ /home/cooluserjoe/public_html/ocart2/secretadmin123/
find /home/cooluserjoe/public_html/ocart2/admin -mindepth 1 -type d -empty -delete
```


## Built With

* [BASH](https://www.gnu.org/software/bash/) - The scripting used

## Contributing

Please read [CONTRIBUTING.md](https://gitlab.com/mikeramsey/) for details on our code of conduct, and the process for submitting pull requests to us.
 

## Authors

* **Michael Ramsey** - *Initial work* - [mikeramsey](https://gitlab.com/mikeramsey/)

See also the list of [contributors](https://gitlab.com/mikeramsey/opencart-hardener/-/graphs/master) who participated in this project.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration : [http://docs.opencart.com/en-gb/administration/security/](http://docs.opencart.com/en-gb/administration/security/)
