FROM ubuntu:20.04

RUN apt update \
    && apt install -qy ca-certificates openssh-client openjdk-8-jdk\
    wget curl iptables supervisor \
    && rm -rf /var/lib/apt/list/*

ENV DOCKER_CHANNEL=stable \
	DOCKER_VERSION=19.03.11 \
	DOCKER_COMPOSE_VERSION=1.26.0 \
	DEBUG=false

# Docker installation
RUN set -eux; \
	\
	arch="$(uname --m)"; \
	case "$arch" in \
        # amd64
		x86_64) dockerArch='x86_64' ;; \
        # arm32v6
		armhf) dockerArch='armel' ;; \
        # arm32v7
		armv7) dockerArch='armhf' ;; \
        # arm64v8
		aarch64) dockerArch='aarch64' ;; \
		*) echo >&2 "error: unsupported architecture ($arch)"; exit 1 ;;\
	esac; \
	\
	if ! wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz"; then \
		echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'"; \
		exit 1; \
	fi; \
	\
	tar --extract \
		--file docker.tgz \
		--strip-components 1 \
		--directory /usr/local/bin/ \
	; \
	rm docker.tgz; \
	\
	dockerd --version; \
	docker --version

COPY modprobe startup.sh /usr/local/bin/
COPY init.sh /usr/local/bin/
COPY supervisor/ /etc/supervisor/conf.d/
COPY logger.sh /opt/bash-utils/logger.sh

RUN chmod +x /usr/local/bin/startup.sh /usr/local/bin/modprobe
RUN chmod +x /usr/local/bin/startup.sh /usr/local/bin/init.sh
VOLUME /var/lib/docker

# Docker compose installation
RUN curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose


# Jenkins installation 
RUN useradd -m -s /bin/bash jenkins
RUN echo "jenkins:jenkins" | chpasswd
RUN wget https://get.jenkins.io/war/2.266/jenkins.war 
ENTRYPOINT ["init.sh"] 
CMD tail -f /dev/null

# RUN useradd -m -s /bin/bash jenkins
# RUN echo "jenkins:jenkins" | chpasswd
# RUN wget https://get.jenkins.io/war/2.265/jenkins.war 
# # RUN wget https://get.jenkins.io/war/2.265/jenkins.war -P /home/jenkins
# # USER jenkins






