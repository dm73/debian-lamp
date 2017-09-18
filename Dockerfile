FROM debian:8.5
MAINTAINER Reda Makhchan <r.makhchan@dm73.net>

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /tmp

# Install utils
RUN \
  apt-get update && \
  apt-get -y install wget && \
  apt-get install -y mysql-server && \

  wget -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add - && \
  echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list && \
  echo "\ndeb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list && \

  apt-get update && \
  apt-get -y install \
                git \
                curl \
                vim \
                supervisor \
                apache2 \
                php7.0 \
                php7.0-mysql \
                php7.0-sqlite3 \
                php7.0-pgsql \
                php7.0-curl \
                php7.0-mcrypt \
                php7.0-intl \
                php7.0-bz2 \
                php7.0-imap \
                php7.0-gd \
                php7.0-json \
                php7.0-xdebug \
                php7.0-mbstring \
                php7.0-ldap \
                php7.0-zip \
                php7.0-xml \
                php7.0-soap \
                libapache2-mod-php && \


# Enabled Rewrite mode for Apache
  a2enmod rewrite && \


# INSTALL COMPOSER
  php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php && \
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
  php -r "unlink('composer-setup.php');"  && \

# Clean
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archive/*.deb

# Adding ressources
ADD ressources/apache-config.conf /etc/apache2/sites-enabled/000-default.conf
COPY ressources/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]


EXPOSE 80 3306