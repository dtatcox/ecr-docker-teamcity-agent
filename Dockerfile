FROM jetbrains/teamcity-minimal-agent:latest

MAINTAINER Darrell Turner <Darrell.Turner@homenetauto.com>

ENV PACKER_VERSION=0.12.2

LABEL dockerImage.teamcity.version="latest" \
      dockerImage.teamcity.buildNumber="latest"
	  
RUN apt-get update && \
	apt-get -y --no-install-recommends install curl apt-transport-https ca-certificates software-properties-common

RUN curl -fsSL https://apt.dockerproject.org/gpg | apt-key add - && \
	add-apt-repository "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main" && \
	add-apt-repository ppa:openjdk-r/ppa

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		awscli \
		docker-engine=1.12.6-0~ubuntu-$(lsb_release -cs) \
		git \
		jq \
		openjdk-8-jdk
		
# Setup docker-credential-ecr-login
COPY config.json /root/.docker/config.json
RUN chmod 0644 /root/.docker/config.json

COPY config.json /home/buildagent/.docker/config.json
RUN chmod 0644 /home/buildagent/.docker/config.json

COPY bin/docker-credential-ecr-login /usr/bin/docker-credential-ecr-login
RUN chmod 0755 /usr/bin/docker-credential-ecr-login
    
RUN usermod -aG docker buildagent

