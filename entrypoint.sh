#!/bin/bash

set -e

NAGIOS_ETC=/usr/local/nagios/etc
NAGVIS_ETC=/usr/local/nagvis/etc
NAGVIS_SHARE=/usr/local/nagvis/share
CONFIG=1

CENTREONPAGE=${centreonpage:-0.0.0.0:9401}
LOGIN_CENTREON=${centreonlogin:-admin}
PASSWORD_CENTREON=${centreonpassword:-admin}

DOKUWIKIPAGE=${dokuwikipage:-0.0.0.0:9402}
LOGIN_DOKUWIKI=${dokuwikilogin:-admin}
PASSWORD_DOKUWIKI=${dokuwikipassword:-admin}

MANTISBTPAGE=${mantisbtpage:-0.0.0.0:9403}
LOGIN_MANTISBT=${mantisbtlogin:-admin}
PASSWORD_MANTISBT=${mantisbtpassword:-admin}

SONARPAGE=${sonarpage:-0.0.0.0:9404}
LOGIN_SONAR=${sonarlogin:-admin}
PASSWORD_SONAR=${sonarpassword:-admin}

SVNPAGE=${svnpage:-0.0.0.0:9405}
LOGIN_SVN=${svnlogin:-admin}
PASSWORD_SVN=${svnpassword:-admin}

FTPPAGE=${ftppage:-0.0.0.0:9406}
LOGIN_FTP=${ftplogin:-admin}
PASSWORD_FTP=${ftppassword:-admin}

JENKINSPAGE=${jenkinspage:-0.0.0.0:9407}
LOGIN_JENKINS=${jenkinslogin:-admin}
PASSWORD_JENKINS=${jenkinspassword:-admin}

NEXUSPAGE=${nexuspage:-0.0.0.0:9408}
LOGIN_NEXUS=${nexuslogin:-admin}
PASSWORD_NEXUS=${nexuspassword:-admin}

UTILSPAGE=${utilspage:-0.0.0.0:9409}
LOGIN_UTILS=${utilslogin:-admin}
PASSWORD_UTILS=${utilspassword:-admin}

LOGIN_NAGIOS=${nagioslogin:-nagiosadmin}
PASSWORD_NAGIOS=${nagiospassword:-admin}

LOGIN_NAGVIS=${nagvislogin:-admin}
PASSWORD_NAGVIS=${nagvispassword:-admin}

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

sed -i 's|##SONAR##|'"${SONARPAGE}"'|g' /var/www/html/index.php
sed -i 's|##LOGIN_SONAR##|'"${LOGIN_SONAR}"'|g' /var/www/html/index.php
sed -i 's|##PASSWORD_SONAR##|'"${PASSWORD_SONAR}"'|g' /var/www/html/index.php

sed -i 's|##SVN##|'"${SVNPAGE}"'|g' /var/www/html/index.php
sed -i 's|##LOGIN_SVN##|'"${LOGIN_SVN}"'|g' /var/www/html/index.php
sed -i 's|##PASSWORD_SVN##|'"${PASSWORD_SVN}"'|g' /var/www/html/index.php

sed -i 's|##FTP##|'"${FTPPAGE}"'|g' /var/www/html/index.php
sed -i 's|##LOGIN_FTP##|'"${LOGIN_FTP}"'|g' /var/www/html/index.php
sed -i 's|##PASSWORD_FTP##|'"${PASSWORD_FTP}"'|g' /var/www/html/index.php

sed -i 's|##JENKINS##|'"${JENKINSPAGE}"'|g' /var/www/html/index.php
sed -i 's|##LOGIN_JENKINS##|'"${LOGIN_JENKINS}"'|g' /var/www/html/index.php
sed -i 's|##PASSWORD_JENKINS##|'"${PASSWORD_JENKINS}"'|g' /var/www/html/index.php

sed -i 's|##NEXUS##|'"${NEXUSPAGE}"'|g' /var/www/html/index.php
sed -i 's|##LOGIN_NEXUS##|'"${LOGIN_NEXUS}"'|g' /var/www/html/index.php
sed -i 's|##PASSWORD_NEXUS##|'"${PASSWORD_NEXUS}"'|g' /var/www/html/index.php

sed -i 's|##UTILS##|'"${UTILSPAGE}"'|g' /var/www/html/index.php
sed -i 's|##LOGIN_UTILS##|'"${LOGIN_UTILS}"'|g' /var/www/html/index.php
sed -i 's|##PASSWORD_UTILS##|'"${PASSWORD_UTILS}"'|g' /var/www/html/index.php

sed -i 's|##LOGIN_NAGIOS##|'"${LOGIN_NAGIOS}"'|g' /var/www/html/index.php
sed -i 's|##PASSWORD_NAGIOS##|'"${PASSWORD_NAGIOS}"'|g' /var/www/html/index.php

sed -i 's|##LOGIN_NAGVIS##|'"${LOGIN_NAGVIS}"'|g' /var/www/html/index.php
sed -i 's|##PASSWORD_NAGVIS##|'"${PASSWORD_NAGVIS}"'|g' /var/www/html/index.php
													
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
