# Spring-boot-docker
Docker file for executing spring boot

A step by step explanation of each task

### Step 1

Download and create the container of image ubuntu 16:10
```
FROM ubuntu:16.10
```

### Step 2:

Update ubuntu and install java8 and remove all temp and cached fiels

```
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
```

### Step 3:
Create a log directory in the docker to store our application logs

```
RUN mkdir -p /var/log/tomcat
```

### Step 4:
Copy libs directory(Dockerfile and libs folder are stored in the same directory) to one of the directory in docker container. Libs directory has all the spring and 3rd party libraries along with our application specific libraries and application specific spring boot class 

```
COPY . /home/docker/service/
```
### Step 5:
Assign permisssion to the www-data(tomcat) folder where our executables are there

```
RUN chown -R www-data:www-data /home/docker/service/
RUN chmod -R 664 /home/docker/service/
```

### Step 6:
Clean temp and cache

```
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
```

### Step 7:
expose container port, which are going to access from outside of container

```
EXPOSE 9081 
```

### Step 8:
Our Springboot main class is in the abc-1.jar file, We must use ENTRYPONT because, spring boot has internal webserver(tomcat), that will run the boot application

```
ENTRYPOINT ["java","-jar","server.port=9081","/home/docker/service/libs/apbc-1.jar"]
```
