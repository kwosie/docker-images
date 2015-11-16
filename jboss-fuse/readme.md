# FUSE Docker image

This project builds a Docker image for [JBoss Fuse](http://www.jboss.org/products/fuse/overview/).

Based on https://github.com/jboss-fuse/jboss-fuse-docker

## Usage

### without local nexus

You can then run a Fuse server with the following command:

    docker run -Pd --name fuse --link nexus  rparree/jboss-fuse-full-admin

I have enabled the admin=admin user

### With local nexus
When running a nexus container (https://github.com/sonatype/docker-nexus):

Start nexus (e.g, using the volume container approach for persistence)

    docker run -it --name nexus-data sonatype/nexus echo "data-only container for Nexus"
    docker run -d -p 8081:8081 --name nexus --volumes-from nexus-data sonatype/nexus

Then run fuse:

    docker run -Pd --name fuse --link nexus  rparree/jboss-fuse-full-admin

## Using the image


The administration console should be available at [http://localhost:8181/hawtio](http://localhost:8181/hawtio)

ssh access to karaf console at `ssh -p <port> admin@localhost`

## Ports Opened by Fuse

You may need to map ports opened by the Fuse container to host ports if you need to access it's services.
Those ports are:

* 8181 - Web access (also hosts the Fuse admin console).
* 8101 - SSH Karaf console access
* 61616 - AMQ Openwire port.

## Image internals

This image extends the [`jboss/base-jdk:8`](https://github.com/JBoss-Dockerfiles/base-jdk/tree/jdk8) image which adds the OpenJDK distribution on top of the [`jboss/base`](https://github.com/JBoss-Dockerfiles/base) image. Please refer to the README.md for selected images for more info.

The server is run as the `jboss` user which has the uid/gid set to `1000`.

Fuse is installed in the `/opt/jboss/jboss-fuse` directory.
