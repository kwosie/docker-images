FROM httpd:2.4


COPY mod_cluster-1.3.1.Final/ /usr/local/apache2/modules
# RUN sed -e '/^LoadModule proxy_balancer_module/ s/^#*/#/' -i /usr/local/apache2/conf/httpd.conf
COPY mod_cluster.conf /usr/local/apache2/conf/extra/mod_cluster.conf
RUN echo 'Include conf/extra/mod_cluster.conf' >> /usr/local/apache2/conf/httpd.conf


EXPOSE 6666
