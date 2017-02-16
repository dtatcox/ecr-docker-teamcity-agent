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
		
RUN curl -fsSL https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip > /tmp/packer.zip && \
	unzip /tmp/packer.zip -d /bin && \
	rm -f /tmp/packer.zip
    
RUN usermod -aG docker buildagent

