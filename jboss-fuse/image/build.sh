#!/usr/bin/env bash
DOCKER_IMAGE_NAME=rparree/jboss-fuse-full-admin
DOCKER_IMAGE_VERSION=6.3.0_1

#docker rmi --force=true ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}
docker build --force-rm=true --rm -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} \
   -t ${DOCKER_IMAGE_NAME}:latest .

echo =========================================================================
echo Docker image is ready.  Try it out by running:
echo     docker run --rm -ti -P ${DOCKER_IMAGE_NAME}
echo =========================================================================
