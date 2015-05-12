FROM ubuntu:14.10
MAINTAINER Nelson <nazareth{DOT}nelson{AT}gmail.com>

#Install subversion to download OSQA
RUN apt-get install subversion -y

########################################################################
#Download OSQA source
RUN svn co http://svn.osqa.net/svnroot/osqa/trunk/ /home/osqa/osqa-server
########################################################################

########################################################################
#Install Apache webserver.
RUN apt-get install apache2 libapache2-mod-wsgi -y
ADD osqa.wsgi /home/osqa/osqa-server/osqa.wsgi

RUN ls -l /etc/apache2/
RUN ls -l /etc/apache2/sites-available/
#RUN rm /etc/apache2/sites-available/default
RUN rm /etc/apache2/sites-available/default-ssl*
RUN rm /etc/apache2/sites-enabled/000-default*
RUN ls -l /etc/apache2/sites-available/

ADD osqa /etc/apache2/sites-available/osqa
RUN ln -s /etc/apache2/sites-available/osqa /etc/apache2/sites-enabled/osqa

EXPOSE 80
########################################################################

########################################################################
# Install python support library
# new versions of ubuntu usuall have python installed. Hence not attempting to install.
RUN apt-get update
RUN apt-get install python-setuptools -y
RUN easy_install South django django-debug-toolbar markdown html5lib python-openid
RUN apt-get install python-pip -y
RUN apt-get install python-mysqldb -y
RUN pip install Django==1.3
RUN pip install Markdown==2.4.1

# local version of settings_local.py has been updated with MySQL config and APP_URL
ADD settings_local.py /home/osqa/osqa-server/settings_local.py

RUN chmod -R g+w /home/osqa/osqa-server/forum/upfiles
RUN chmod -R g+w /home/osqa/osqa-server/log

########################################################################

########################################################################
# config MySQL client.
RUN apt-get install mysql-client -y
########################################################################
	
########################################################################
#need supervisor to run multiple services at startup
RUN apt-get update
RUN apt-get install -y supervisor
####### Add supervisord ############
#RUN mkdir /var/log/supervisor/
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