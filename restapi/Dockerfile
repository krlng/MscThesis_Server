FROM    centos:centos6
MAINTAINER Nico Kreiling<nico.kreiling@gmail.com>

# Enable EPEL for Node.js
RUN     rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
# Install Node.js and npm
RUN     yum -y install git
RUN     yum install -y npm
RUN 	npm install -g bower

# Bundle app source
COPY . /src

# Install app dependencies
WORKDIR /src
RUN pwd
RUN npm install
RUN bower --allow-root install
RUN ls
RUN chmod 0755 setup.sh
RUN ./setup.sh

EXPOSE  8080
CMD ["node", "index.js"]
