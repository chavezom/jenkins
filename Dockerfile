# docker build --build-arg http_proxy=http://proxy.houston.hpecorp.net:8080 --build-arg https_proxy=http://proxy.houston.hpecorp.net:8080 -t chavezom/jenkins:0.1.5 .
# docker push chavezom/jenkins:0.1.5

FROM jenkins:2.60.1
USER root

ENV GITHUB_URL="https://github.com"
ENV GITHUB_API_URL="https://api.github.com"
ENV GITHUB_CLIENT_ID="5aaeed69984fe38c11ad"
ENV GITHUB_CLIENT_SECRET="f82e113f137ebce2560da9221f46cca710727a2a"
ENV GITHUB_ADMIN_USER_NAMES="chavezom,ojacques"
ENV GITHUB_ORGANIZATION_NAMES="devops-dojo"

RUN apt-get update \
      && apt-get install -y sudo \
      && rm -rf /var/lib/apt/lists/*

# RUN apt-get update \
#       && apt-get install -y sudo curl build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev libcurl3 libcurl3-gnutls autoconf libtool zlib1g-dev\
#       && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN curl -sSL https://get.docker.com/ | sh
RUN usermod -a -G staff jenkins

RUN curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

RUN /usr/local/bin/install-plugins.sh github-oauth

COPY github-authentication.groovy /usr/share/jenkins/ref/init.groovy.d/github-authentication.groovy
COPY github-authorization.groovy /usr/share/jenkins/ref/init.groovy.d/github-authorization.groovy


EXPOSE 8080
EXPOSE 50000
