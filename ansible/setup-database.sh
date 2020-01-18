#!/bin/bash

set -u
set -x

dhclient

cd /root/beaker

cd Server/
mysql -uroot <<"EOF"
CREATE DATABASE beaker;
GRANT ALL ON beaker.* TO 'beaker'@'localhost' IDENTIFIED BY 'beaker';
EOF

PYTHONPATH=../Common:. python bkr/server/tools/init.py \
    --user=admin \
    --password=adminpassword \
    --email=me@example.com

# Needed for integration tests
mysql -uroot <<"EOF"
CREATE DATABASE beaker_test;
GRANT ALL ON beaker_test.* TO 'beaker'@'localhost' IDENTIFIED BY 'beaker';
EOF

mysql -uroot <<"EOF"
CREATE DATABASE beaker_migration_test;
GRANT ALL ON beaker_migration_test.* TO 'beaker'@'localhost' IDENTIFIED BY 'beaker';
EOF

