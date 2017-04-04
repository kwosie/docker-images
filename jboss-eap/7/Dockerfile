FROM jboss/base-jdk:8

MAINTAINER Raphael Parree <rparree@edc4it.com>

USER root

RUN yum -y update;yum clean all

ENV JBOSS_VERSION 7.0.0
ENV JBOSS_HOME /opt/jboss/jboss-eap-7.0/

ADD distribution /tmp/distribution

RUN cd /opt/jboss/ \
    && unzip /tmp/distribution/jboss-eap-$JBOSS_VERSION.zip \
    && rm /tmp/distribution/jboss-eap-$JBOSS_VERSION.zip

RUN /opt/jboss/jboss-eap-7.0/bin/add-user.sh admin jboss#1! --silent

ENV LAUNCH_JBOSS_IN_BACKGROUND true

EXPOSE 8080 9990 9999

VOLUME $JBOSS_HOME/standalone/deployments

CMD ["/opt/jboss/jboss-eap-7.0/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
