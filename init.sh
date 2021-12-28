#!/bin/sh

rsync -a /tmp/discuz_x/* /var/www/html
rsync -a /tmp/discuz_x_overwirte/* /var/www/html
if test -f "/var/www/html/config/config_global.php"; then
  rm /var/www/html/install/index.php
fi

/usr/local/bin/apache2-foreground
