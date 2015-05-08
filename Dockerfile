FROM ubuntu:14.10
MAINTAINER Nelson <nazareth{DOT}nelson{AT}gmail.com>

#Install subversion to download OSQA
RUN apt-get install subversion -y

#Download OSQA source
RUN svn co http://svn.osqa.net/svnroot/osqa/trunk/ /home/osqa/osqa-server
## DEBUG : list to verify
RUN ls -l /home/osqa/osqa-server

#Install Apache webserver.
RUN apt-get install apache2 libapache2-mod-wsgi -y


########################################################################
#need supervisor to run multiple services at startup
RUN apt-get update
RUN apt-get install -y supervisor
####### Add supervisord ############
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
####### start the services ############
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
########################################################################

########################################################################
# Useful for debug purposes.
# You could leave this config. To disable ssh access do not bind port 22 
# to any host ports during container startup.
# https://docs.docker.com/examples/running_ssh_service/

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:osqa' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
## DEBUG : list to verify
RUN ls -l /etc/ssh
########################################################################