DOCKER_IMAGE_NAME=rparree/jboss-fuse-full-admin
DOCKER_IMAGE_VERSION=latest

docker rmi --force=true ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}
docker build --force-rm=true --rm -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} .
echo =========================================================================
echo Docker image is ready.  Try it out by running:
echo     docker run --rm -ti -P ${DOCKER_IMAGE_NAME}
echo =========================================================================
