#!/bin/bash
#
# We configure the distro, here before it gets imported into docker
# to reduce the number of UFS layers that are needed for the Docker container.
#

# Adjust the following env vars if needed.
FUSE_ARTIFACT_ID=jboss-fuse-karaf-full
FUSE_DISTRO_URL=http://origin-repository.jboss.org/nexus/content/groups/ea/org/jboss/fuse/${FUSE_ARTIFACT_ID}/${FUSE_VERSION}/${FUSE_ARTIFACT_ID}-${FUSE_VERSION}.zip

# Lets fail fast if any command in this script does succeed.
set -e

#
# Lets switch to the /opt/jboss dir
#
cd /opt/jboss

# Download and extract the distro
curl -O ${FUSE_DISTRO_URL}
jar -xvf ${FUSE_ARTIFACT_ID}-${FUSE_VERSION}.zip
rm ${FUSE_ARTIFACT_ID}-${FUSE_VERSION}.zip
mv jboss-fuse-${FUSE_VERSION} jboss-fuse
chmod a+x jboss-fuse/bin/*
rm jboss-fuse/bin/*.bat jboss-fuse/bin/start jboss-fuse/bin/stop jboss-fuse/bin/status jboss-fuse/bin/patch

# Lets remove some bits of the distro which just add extra weight in a docker image.
rm -rf jboss-fuse/extras
rm -rf jboss-fuse/quickstarts

#
# Let the karaf container name/id come from setting the FUSE_KARAF_NAME && FUSE_RUNTIME_ID env vars
# default to using the container hostname.
sed -i -e 's/environment.prefix=FABRIC8_/environment.prefix=FUSE_/' jboss-fuse/etc/system.properties
sed -i -e '/karaf.name = root/d' jboss-fuse/etc/system.properties
sed -i -e '/runtime.id=/d' jboss-fuse/etc/system.properties
echo '
if [ -z "$FUSE_KARAF_NAME" ]; then
  export FUSE_KARAF_NAME="$HOSTNAME"
fi
if [ -z "$FUSE_RUNTIME_ID" ]; then
  export FUSE_RUNTIME_ID="$FUSE_KARAF_NAME"
fi

export KARAF_OPTS="-Dkaraf.name=${FUSE_KARAF_NAME} -Druntime.id=${FUSE_RUNTIME_ID}"
'>> jboss-fuse/bin/setenv

#
# Move the bundle cache and tmp directories outside of the data dir so it's not persisted between container runs
#
mv jboss-fuse/data/tmp jboss-fuse/tmp
echo '
org.osgi.framework.storage=${karaf.base}/tmp/cache
'>> jboss-fuse/etc/config.properties
sed -i -e 's/-Djava.io.tmpdir="$KARAF_DATA\/tmp"/-Djava.io.tmpdir="$KARAF_BASE\/tmp"/' jboss-fuse/bin/karaf
sed -i -e 's/-Djava.io.tmpdir="$KARAF_DATA\/tmp"/-Djava.io.tmpdir="$KARAF_BASE\/tmp"/' jboss-fuse/bin/fuse
sed -i -e 's/-Djava.io.tmpdir="$KARAF_DATA\/tmp"/-Djava.io.tmpdir="$KARAF_BASE\/tmp"/' jboss-fuse/bin/client
sed -i -e 's/-Djava.io.tmpdir="$KARAF_DATA\/tmp"/-Djava.io.tmpdir="$KARAF_BASE\/tmp"/' jboss-fuse/bin/admin
sed -i -e 's/${karaf.data}\/generated-bundles/${karaf.base}\/tmp\/generated-bundles/' jboss-fuse/etc/org.apache.felix.fileinstall-deploy.cfg
sed -i -e 's/activemq.host = localhost/activemq.host = 0.0.0.0/' jboss-fuse/etc/system.properties

echo '
bind.address=0.0.0.0
'>> jboss-fuse/etc/system.properties
echo '
admin=admin,admin,manager,viewer,Operator, Maintainer, Deployer, Auditor, Administrator, SuperUser
' >> jboss-fuse/etc/users.properties

rm /opt/jboss/install.sh
