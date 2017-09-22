#!/bin/bash
#
# We configure the distro, here before it gets imported into docker
# to reduce the number of UFS layers that are needed for the Docker container.
#

# Adjust the following env vars if needed.
FUSE_ARTIFACT_ID=jboss-fuse-karaf
FUSE_DISTRO_URL=https://repository.jboss.org/nexus/content/groups/ea/org/jboss/fuse/${FUSE_ARTIFACT_ID}/${FUSE_VERSION}/${FUSE_ARTIFACT_ID}-${FUSE_VERSION}.zip

# Lets fail fast if any command in this script does succeed.
set -e

#
# Lets switch to the /opt/jboss dir
#
cd /opt/jboss

# Download and extract the distro

jar -xvf ${FUSE_ARTIFACT_ID}-${FUSE_VERSION}.zip
rm jboss-fuse-karaf-${FUSE_VERSION}.zip
mv jboss-fuse-${FUSE_VERSION} jboss-fuse
chmod a+x jboss-fuse/bin/*
rm jboss-fuse/bin/*.bat jboss-fuse/bin/start jboss-fuse/bin/stop jboss-fuse/bin/status jboss-fuse/bin/patch


# Lets remove some bits of the distro which just add extra weight in a docker image.
rm -rf jboss-fuse/extras
rm -rf jboss-fuse/quickstarts

sed -i -e 's/karaf.name = root/karaf.name = ${docker.hostname}/' jboss-fuse/etc/system.properties

# enable a link to a local nexus container
echo '
export KARAF_OPTS="-Dnexus.addr=${NEXUS_PORT_8081_TCP_ADDR} -Dnexus.port=${NEXUS_PORT_8081_TCP_PORT} -Dnexus.url=${NEXUS_URL} $KARAF_OPTS"
export KARAF_OPTS="-Dpostgres.addr=${POSTGRES_PORT_5432_TCP_ADDR} -Dpostgres.port=${POSTGRES_PORT_5432_TCP_PORT} $KARAF_OPTS"
export KARAF_OPTS="-Ddocker.hostname=${HOSTNAME} $KARAF_OPTS"
'>> jboss-fuse/bin/setenv
# Add the nexus repos (uses the nexus link)
sed -i -e 's/fuseearlyaccess$/&,http:\/\/${nexus.addr}:${nexus.port}\/repository\/maven-releases@id=nexus.release.repo,  http:\/\/${nexus.addr}:${nexus.port}\/repository\/maven-snapshots@id=nexus.snapshot.repo@snapshots,http:\/\/${nexus.addr}:${nexus.port}\/nexus\/content\/repositories\/snapshots@id=nexus2.snapshot.repo@snapshots, http:\/\/${nexus.addr}:${nexus.port}\/nexus\/content\/repositories\/releases@id=nexus2.releases.repo,${nexus.url}/' \
  jboss-fuse/etc/org.ops4j.pax.url.mvn.cfg

#bind AMQ to all IP addresses
sed -i -e 's/activemq.host = localhost/activemq.host = 0.0.0.0/' jboss-fuse/etc/system.properties
mkdir -p /opt/jboss/jboss-fuse/kahadb
sed -i -e 's/${data}\/kahadb/\/opt\/jboss\/jboss-fuse\/kahadb/' jboss-fuse/etc/activemq.xml

# lets remove the karaf.delay.console=true to disable the progress bar
sed -i -e 's/karaf.delay.console=true/karaf.delay.console=false/g' jboss-fuse/etc/config.properties
sed -i -e 's/karaf.delay.console=true/karaf.delay.console=false/' jboss-fuse/etc/custom.properties

#enable the console logger
echo '
# Root logger
log4j.rootLogger=INFO, stdout, osgi:*VmLogAppender
log4j.throwableRenderer=org.apache.log4j.OsgiThrowableRenderer
# CONSOLE appender not used by default
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%d{ABSOLUTE} | %-5.5p | %-16.16t | %-32.32c{1} | %X{bundle.id} - %X{bundle.name} - %X{bundle.version} | %m%n
' > jboss-fuse/etc/org.ops4j.pax.logging.cfg

echo '
bind.address=0.0.0.0
'>> jboss-fuse/etc/system.properties
echo '
admin=admin,admin,manager,viewer,Operator, Maintainer, Deployer, Auditor, Administrator, SuperUser
' >> jboss-fuse/etc/users.properties

# sample of adding public keys to be able to log in via ssh
echo '
jenkins=AAAAB3NzaC1yc2EAAAABJQAAAQEAuZ6o1ePWtPCsTq5CBnokwSDiGU5zZR/f1egu1YoWS/kvoDiQ6iZxm8cMMBge2VJYW97OrPAlI1BprCz63u8LyWMsURLNVOiupOkG20MNKmj1ChXSxEn7awjFaXjzc4FMVns4zvPZS3YanDUFwEfoy4OYvtkXsMDnED3Zf5/GimVBehNNfL2LJw8arl4VDaAS5tQiQPEKNaJYCUS/MRxsmj/qqO/YDesL58yO4HDOwlFZ/19CMRIyLurcEYZMDTQaLzlSRWRS5blBcfBLQXojoW1Oq0K8G9cRZ4NWul8S7jDxX+nz36mx2G45NK+YgJwTC9b4AJe0CyK9e6mFsArkGQ==,_g_:admingroup
sarelj=AAAAB3NzaC1yc2EAAAABJQAAAIEAng1fLqIJYOTRDjCt4qeJZq6O2VD1dNwnJ3hcexpthoWPDmsE21AmI+iRUyNEjWapZN9oiQyk7jQcdWQ37Bw52wIzvd6vvX5bCN0O5HUCmSNL7mHlfWwkUO6gJyUhUsUyLnDaYsFqDbY2QQyetdkqHhdT/PG3LWgUvwaRhuSQCnk=,_g_:admingroup
' >> jboss-fuse/etc/keys.properties


rm /opt/jboss/install.sh
