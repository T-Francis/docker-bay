FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y locales \
    && locale-gen fr_FR.UTF-8

ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:en
ENV LC_ALL fr_FR.UTF-8

RUN apt-get update \
    && apt-get install -y nginx sudo curl wget zip unzip git vim software-properties-common supervisor sqlite3 \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php7.1-fpm php7.1-cli php7.1-mcrypt php7.1-gd php7.1-mysql \
       php7.1-pgsql php7.1-imap php-memcached php7.1-mbstring php7.1-xml php7.1-curl \
       php7.1-imagick php7.1-zip php7.1-bcmath php7.1-sqlite3 php7.1-xdebug php7.1-mongodb php7.1-soap\
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer \
    && mkdir /run/php \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY default /etc/nginx/sites-available/default
COPY php-fpm.conf /etc/php/7.1/fpm/php-fpm.conf
COPY xdebug.ini /etc/php/7.1/mods-available/xdebug.ini

COPY start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

# create a user for permissions facilities with johndev as name & password and with 1000 as UID
# just adjust name and UID to fit with yours
RUN useradd -m johndev && echo "johndev:johndev" | chpasswd && adduser johndev sudo
RUN usermod -u 1000 johndev
RUN chown -R 1000:1000 /var/www/

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /var/www/

CMD ["start-container"]