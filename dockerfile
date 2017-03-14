##################################################################################### 
#                                                                                   #
#    This is the docker file to install following components on centos 6            #
#    Python 2.7                                                                     #
#    MongoDB                                                                        #
#    Apache Tomacat 7                                                               #
#####################################################################################

FROM centos:centos6							# FROM command chooses os image from dockers online repo

MAINTAINER Poonam Davari <poonam.davari.atwork@gmail.com>   		# who is maintainer of this file and whom to mail for changes or issues

RUN echo "Installing Python 2.7"    					# RUN command is used to execute command inside os image
RUN yum install sudo gcc wget make tar -y   				# this command install first prerequsites in the centos 6 plain image
RUN cd /usr/src								# change directory location to /usr/src
RUN wget https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tgz  	# download python tar
RUN tar xzf Python-2.7.12.tgz						# untar python tar
RUN cd Python-2.7.12 && ./configure && make altinstall			# configure python
RUN python2.7 -V							# check python version

RUN echo "Installing MongoDB"
COPY mongodb.repo /etc/yum.repos.d/					# copy provided mongodb repo inside centos image
RUN yum repolist							# check yum repolist to see if mongodb repo added properly
RUN yum install mongo-10gen mongo-10gen-server -y --enablerepo=mongodb	# install mongodb
CMD mongod start							# start mongodb
RUN chkconfig mongod on							# enable mongodb at boot time
CMD mongod status							# check mongodb status on centos image

########### Installing Java ####################

ADD jdk-7u72-linux-x64.tar.gz /opt					# ADD command untars and copy provided java tar in destination folder here its /opt
WORKDIR /opt/jdk1.7.0_72							# WORKDIR command changes working directory		
RUN alternatives --install /usr/bin/java java /opt/jdk1.7.0_72/bin/java 1	# These are commands to install java which i found online
RUN alternatives --install /usr/bin/jar jar /opt/jdk1.7.0_72/bin/jar 1
RUN alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_72/bin/javac 1
RUN echo "JAVA_HOME=/opt/jdk1.7.0_72" >> /etc/environment			# this command sets java home
 
######## Installing Tomcat ##########################
 
ADD apache-tomcat-7.0.73.tar.gz /usr/share				# ADD command untars and copy provided tomcat tar in destination folder here its /usr/share
WORKDIR /usr/share/							# WORKDIR command changes working directory
RUN mv  apache-tomcat-7.0.73 tomcat7					# rename tomcat untared file to tomcat7
RUN echo "JAVA_HOME=/opt/jdk1.7.0_72/" >> /etc/default/tomcat7		# sets java home in tomcat settings
RUN groupadd tomcat							# add tomcat group
RUN useradd -s /bin/bash -g tomcat tomcat				# add user tomcat and assign shell /bin/bash and group tomcat	
RUN chown -Rf tomcat.tomcat /usr/share/tomcat7				# change ownership of /usr/share/tomcat7 directory and its contents to tomcat user and group
EXPOSE 8080 								# open port 8080 inside centos image
