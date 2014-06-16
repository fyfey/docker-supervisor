FROM ubuntu:latest

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get -f install -y git openssh-server apache2 supervisor curl php5 php5-curl php5-xdebug php5-mysql php5-mcrypt && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin && mv /usr/local/bin/composer.phar /usr/local/bin/composer
RUN mkdir /root/.composer
ENV COMPOSER_HOME "/root/.composer"
RUN composer global require phpunit/phpunit 4.1.* && composer global require phpmd/phpmd 1.4.* && composer global require squizlabs/php_codesniffer=* && composer global require fabpot/php-cs-fixer @stable

RUN touch /root/.bash_profile && echo "export PATH=/root/.composer/vendor/bin:$PATH" >> /root/.bash_profile
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

RUN mkdir /root/.ssh
RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa
RUN touch /root/.ssh/authorized_keys
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
RUN chown -R root:root /root/.ssh
RUN chmod -R 600 /root/.ssh

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22 80
CMD ["/start.sh"]
