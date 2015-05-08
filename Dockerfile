FROM ubuntu:14.10
MAINTAINER Nelson <nazareth{DOT}nelson{AT}gmail.com>

#Install subversion to download OSQA
RUN apt-get install subversion -y



####################################
# Useful for debug purposes.
# You could leave this config. To disable ssh access do not bind port 22 to any host ports during container startup.
# https://docs.docker.com/examples/running_ssh_service/

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'osqa:osqa' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

RUN ls -l /etc/ssh
####################################