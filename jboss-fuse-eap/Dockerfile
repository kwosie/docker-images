FROM jboss/base-jdk:8

MAINTAINER Raphael Parree <rparree@edc4it.com>

USER root

RUN yum -y update;yum clean all



ENV JBOSS_HOME /home/jboss/jboss-eap-6.4

ADD distribution /tmp/distribution

RUN unzip /tmp/distribution/jboss-eap-6.4.0.zip -d /home/jboss

RUN $JBOSS_HOME/bin/add-user.sh admin jboss#1! --silent

RUN echo "JAVA_OPTS=\"\$JAVA_OPTS -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0\"" >> $JBOSS_HOME/bin/standalone.conf

RUN java -jar /tmp/distribution/fuse-eap-installer-6.3.0.redhat-187.jar $JBOSS_HOME

RUN chown -R jboss:jboss /home/jboss

EXPOSE 8080 9990 9999

ENTRYPOINT $JBOSS_HOME/bin/standalone.sh -c standalone-full.xml

USER jboss

CMD /bin/bash


