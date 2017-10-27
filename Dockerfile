FROM ubuntu:16.10

MAINTAINER Sateesh H

# Install Java.
RUN apt-get update -y                             && \
    apt-get install software-properties-common -y && \
    add-apt-repository ppa:webupd8team/java -y    && \
    apt-get update -y                             && \
  	echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections 	  && \
  	apt-get install oracle-java8-installer -y	  && \
  	apt-get install oracle-java8-set-default	  && \
  	apt-get install vim	-y						  && \
  	rm -rf /var/lib/apt/lists/* 				  && \
  	rm -rf /var/cache/oracle-jdk8-installer


RUN mkdir -p /var/log/tomcat

RUN mkdir -p /home/docker/uploads

# add (the rest of) our dependecies
COPY . /home/docker/service/

# will have a access to execute this microservices
RUN chown -R www-data:www-data /home/docker/service/
RUN chmod -R 664 /home/docker/service/

# www-data will have a access to execute this microservices
RUN chown -R www-data:www-data /home/docker/uploads/
RUN chmod -R 664 /home/docker/uploads/

# Cleanup to reduce image size
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# I want the web application running in the container to be accessible from
# the outside. We're exposing a REST API to control and monitor the scan worker
EXPOSE 9080

# RUN spring boot service
ENTRYPOINT ["java","-jar","/home/docker/service/libs/abc-1.jar"]
