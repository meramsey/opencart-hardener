Opencart Hardener is designed to make securing new Opencart installs easy.

Reference:
[http://docs.opencart.com/en-gb/administration/security/](http://docs.opencart.com/en-gb/administration/security/)

Features:
*  Custom Admin Support (Including vQmod Support if detected)
*  Honeypot default admin path and rickroll hackers
*  Setup SSL/HTTPS for all URLS
*  Setup deny all for System, Catalog, and sensitive files
*  Set permissions to 444 for Opencart recommended hardening.
*  Generates custom Maintenance Script in $HOME/opencart_hardener_updater_$OCBASEDOMAIN.sh. This allows for easy maintenance after extensions/mods/themes installed or after Opencart updates. Just run that script or setup as cron to auto move files from default admin to custom admin path. so 