#docker run -d --name nagios -p 80:80 -p 9411:5666 paperinik/rpi-nagios

#docker cp nagios:/usr/local/nagios/ /home/docker/monitor
#docker cp nagios:/usr/local/nagiosgraph/ /home/docker/monitor
#docker cp nagios:/usr/local/nagvis/ /home/docker/monitor

docker run -d --name nagios  \
  -v /home/pi/docker_path/nagios/nagios:/usr/local/nagios \
  -v /home/pi/docker_path/nagios/nagiosgraph:/usr/local/nagiosgraph \
  -v /home/pi/docker_path/nagios/nagvis:/usr/local/nagvis \
  -e portainerpage=0.0.0.0:9400 \
  -e centreonpage=0.0.0.0:9401 \
  -e mantisbtpage=0.0.0.0:9402 \
  -e sonarpage=0.0.0.0:9403 \
  -e svnpage=0.0.0.0:9404 \
  -e ftppage=0.0.0.0:9405 \
  -e jenkinspage=0.0.0.0:9406 \
  -e nexuspage=0.0.0.0:9407 \
  -e utilspage=0.0.0.0:9408 \
  -e dokuwikipage=0.0.0.0:9409 \
  -e portainerlogin=admin \
  -e portainerpassword=admin \
  -e centreonlogin=admin \
  -e centreonpassword=admin \
  -e mantisbtlogin=admin \
  -e mantisbtpassword=admin \
  -e sonarlogin=admin \
  -e sonarpassword=admin \
  -e svnlogin=admin \
  -e svnpassword=admin \
  -e ftplogin=admin \
  -e ftppassword=admin \
  -e jenkinslogin=admin \
  -e jenkinspassword=admin \
  -e nexuslogin=admin \
  -e nexuspassword=admin \
  -e utilslogin=admin \
  -e utilspassword=admin \
  -e dokuwikilogin=admin \
  -e dokuwikipassword=admin \
  -e nagioslogin=nagiosadmin \
  -e nagiospassword=admin \
  -e nagvislogin=admin \
  -e nagvispassword=admin \  
  -p 80:80 \
  -p 9411:5666 \
  paperinik/rpi-nagios
