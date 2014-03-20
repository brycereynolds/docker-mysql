FROM ubuntu:quantal
MAINTAINER Bryce Reynolds <bryce@bloomboard.com>

# Install packages
RUN apt-get update
RUN apt-get -y upgrade
RUN ! DEBIAN_FRONTEND=noninteractive apt-get -qy install supervisor unzip mysql-server pwgen; ls

# Install and setup serf - lets us be auto-aware of other runnning containers
ADD https://dl.bintray.com/mitchellh/serf/0.4.1_linux_amd64.zip serf.zip
RUN unzip serf.zip
RUN rm serf.zip
RUN mv serf /usr/bin/

# Add image configuration and scripts
ADD /start.sh /start.sh
ADD /start-serf.sh /start-serf.sh
ADD /serf-join.sh /serf-join.sh
ADD /run.sh /run.sh
ADD /supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD /my.cnf /etc/mysql/conf.d/my.cnf
ADD /create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD /import_sql.sh /import_sql.sh

RUN chmod 755 /*.sh

EXPOSE 3306
CMD ["/run.sh"]