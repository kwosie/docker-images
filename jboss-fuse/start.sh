echo "removing previous fuse container (if any)"
docker rm -f fuse
echo "Starting"
docker run -Pd -p 8101:8101 -p 61616:61616 \
  --name fuse --link nexus3 \
    kwosie/jboss-fuse
docker port fuse
