echo "removing previous fuse container (if any)"
docker rm -f fuse
echo "Starting"
docker run -Pd -p 8101:8101 \
  --name fuse --link nexus \
    rparree/jboss-fuse-full-admin
docker port fuse
