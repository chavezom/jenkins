# docker build -t chavezom/jenkins:0.0.6 .
# docker push chavezom/jenkins:0.0.6

FROM jenkins:2.0
USER root

ENV GITHUB_URL="https://github.com"
ENV GITHUB_API_URL="https://api.github.com"
ENV GITHUB_CLIENT_ID="532dffc450d30c81d532"
ENV GITHUB_CLIENT_SECRET="c392f9a6ed973d750d4dcaca63c9686d8403487c"
ENV GITHUB_ADMIN_USER_NAMES="chavezom"
ENV GITHUB_ORGANIZATION_NAMES="devops-dojo"

RUN apt-get update \
      && apt-get install -y sudo \
      && rm -rf /var/lib/apt/lists/*

# RUN apt-get update \
#       && apt-get install -y sudo curl build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev libcurl3 libcurl3-gnutls autoconf libtool zlib1g-dev\
#       && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
USER jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

COPY github-authorization.groovy /usr/share/jenkins/ref/init.groovy.d/github-authorization.groovy
COPY github-authentication.groovy /usr/share/jenkins/ref/init.groovy.d/github-authentication.groovy

RUN curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

RUN chmod +x /usr/local/bin/docker-compose

EXPOSE 8080
EXPOSE 50000
