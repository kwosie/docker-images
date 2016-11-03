FROM httpd:2.4


RUN apt-get update && apt-get install -y build-essential

ADD http://apache.trisect.eu/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.42-src.tar.gz tomcat-connectors-1.2.42-src.tar.gz
RUN tar -zxf tomcat-connectors-1.2.42-src.tar.gz

RUN cd tomcat-connectors-1.2.42-src/native && ./configure  --with-apxs=/usr/local/apache2/bin/apxs && make
RUN mkdir /build_modjk

COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./workers.properties /usr/local/apache2/conf/workers.properties
