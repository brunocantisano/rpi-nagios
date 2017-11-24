#!/bin/bash

set -e

NAGIOS_ETC=/usr/local/nagios/etc
NAGVIS_ETC=/usr/local/nagvis/etc
NAGVIS_SHARE=/usr/local/nagvis/share
CONFIG=1

CENTREONPAGE=${centreonpage:-0.0.0.0:9430}
LOGIN_CENTREON=${centreonlogin:-admin}
PASSWORD_CENTREON=${centreonpassword:-admin}

DOKUWIKIPAGE=${dokuwikipage:-0.0.0.0:9411}
LOGIN_DOKUWIKI=${dokuwikilogin:-admin}
PASSWORD_DOKUWIKI=${dokuwikipassword:-admin}

MANTISBTPAGE=${mantisbtpage:-0.0.0.0:9408}
LOGIN_MANTISBT=${mantisbtlogin:-admin}
PASSWORD_MANTISBT=${mantisbtpassword:-admin}

# Configure index.php to link centreon and dokuwiki
sed -i 's|##CENTREON##|'"${CENTREONPAGE}"'|g' /var/www/html/index.php
sed -i 's|##LOGIN_CENTREON##|'"${LOGIN_CENTREON}"'|g' /var/www/html/index.php
sed -i 's|##PASSWORD_CENTREON##|'"${PASSWORD_CENTREON}"'|g' /var/www/html/index.php

sed -i 's|##DOKUWIKI##|'"${DOKUWIKIPAGE}"'|g' /var/www/html/index.php
sed -i 's|##LOGIN_DOKUWIKI##|'"${LOGIN_DOKUWIKI}"'|g' /var/www/html/index.php
sed -i 's|##PASSWORD_DOKUWIKI##|'"${PASSWORD_DOKUWIKI}"'|g' /var/www/html/index.php

sed -i 's|##MANTISBT##|'"${MANTISBTPAGE}"'|g' /var/www/html/index.php
sed -i 's|##LOGIN_MANTISBT##|'"${LOGIN_MANTISBT}"'|g' /var/www/html/index.php
sed -i 's|##PASSWORD_MANTISBT##|'"${PASSWORD_MANTISBT}"'|g' /var/www/html/index.php

# check for required vars
if [[ -z "$CONFIG_REPO" ]]; then
    echo -n >&2 "Warning: no configuration repository is set "
    echo >&2 "Did you forget to add -e CONFIG_REPO=... ?"
    CONFIG=0
fi
if [[ -z "$CONFIG_USER" ]]; then
    echo -n >&2 "Warning: the user or team name is not set "
    echo >&2 "Did you forget to add -e CONFIG_USER=... ?"
    CONFIG=0
fi
if [[ -z "$CONFIG_PASS" ]]; then
    echo -n >&2 "Warning: the password or API key is not set "
    echo >&2 "Did you forget to add -e CONFIG_PASS=... ?"
    CONFIG=0
fi

if [[ CONFIG -eq 1 ]]; then
    # reset configuration directories for nagios and nagvis
    rm -rf ${NAGIOS_ETC}
    rm -rf ${NAGVIS_ETC}/maps
    rm -rf ${NAGVIS_SHARE}/userfiles

    # clone the git repo
    echo "cloning config repository..."
    rm -rf /tmp/nagios-config
    git clone https://${CONFIG_USER}:${CONFIG_PASS}@${CONFIG_REPO} /tmp/nagios-config

    # copy nagios config
    echo "linking config to ${NAGIOS_ETC}"
    ln -s /tmp/nagios-config/nagios ${NAGIOS_ETC}

    # copy nagvis maps
    echo "linking maps to ${NAGVIS_ETC}/maps"
    ln -s /tmp/nagios-config/nagvis/maps ${NAGVIS_ETC}/maps

    # copy nagvis userfiles
    echo "linking userfiles to ${NAGVIS_SHARE}/userfiles"
    ln -s /tmp/nagios-config/nagvis/userfiles ${NAGVIS_SHARE}/userfiles

    # fix permissions
    echo "fixing permissions"
    chown nagios:nagcmd $NAGIOS_ETC -R
    chown nagios:nagcmd /tmp/nagios-config/nagios -R
    chown www-data:www-data $NAGVIS_ETC -R
    chown www-data:www-data $NAGVIS_SHARE -R
    chown www-data:www-data /tmp/nagios-config/nagvis -R
fi

echo "starting the server"
exec "$@"
