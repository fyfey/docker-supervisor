FROM ubuntu:latest

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y openssh-server apache2 supervisor
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
