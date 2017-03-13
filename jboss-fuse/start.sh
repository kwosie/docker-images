echo "removing previous fuse container (if any)"
docker rm -f fuse
echo "Starting"
docker run -Pd -p 8101:8101 -p 61616:61616 \
  --name fuse --link nexus3 \
    rparree/jboss-fuse-full-admin
docker port fuse
