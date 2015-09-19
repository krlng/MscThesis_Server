FROM    centos:centos6
MAINTAINER Nico Kreiling<nico.kreiling@gmail.com>

# Enable EPEL for Node.js
RUN     rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
# Install npm, bower and git
RUN     yum update -y
RUN     yum install -y npm
RUN     yum -y install git
RUN 	npm install -g bower
RUN     git config --global url."https://".insteadOf git:// 

# Bundle app source
COPY . /src
VOLUME /src:/restapi

# Install app dependencies
WORKDIR /src
RUN pwd
RUN npm install
RUN bower --allow-root install
RUN ls
RUN chmod 0755 setup.sh
RUN ./setup.sh

RUN echo $(docker-machine env default) > config.js

EXPOSE  8080
