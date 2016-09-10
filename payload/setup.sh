#!/bin/bash

chown www-data:www-data -R /var/www >/dev/null
chmod 0777 -R /var/www >/dev/null

service redis-server restart >/dev/null
service mysql restart >/dev/null

#mysql -u root mysql -e "UPDATE mysql.user SET Password=PASSWORD('secret') WHERE User='root'; DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'); DELETE FROM mysql.user WHERE User=''; DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'; FLUSH PRIVILEGES;"

#mysql -u root -p"secret" mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'); DELETE FROM mysql.user WHERE User=''; DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'; FLUSH PRIVILEGES;"
