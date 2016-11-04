# httpd with mod_jk image

based off https://hub.docker.com/_/httpd/

## Setup

build the docker image

```bash
$ docker build --tag com.edc4it/httpd-mod_cluster:1.0 .
```
You need to run jboss using a hostname. This hostname must also be known to the docker
container (using `--add-host`)

On the host set a hostname
 ```bash
 # on the host
 $ sudo '172.17.0.1 jboss.localhost' >> /etc/hosts
 ```

### Configure jboss

In the `standalone-ha.xml` change the `mod-cluster-config` configuration,
set  `proxy-list` to `localhost:6666` and  `advertise` to `false`:

```xml
<mod-cluster-config advertise-socket="modcluster"
     proxy-list="localhost:6666"
     advertise="false"
     connector="ajp">
    <dynamic-load-provider>
        <load-metric type="busyness"/>
    </dynamic-load-provider>
</mod-cluster-config>
```

## Run
Then run jboss as follows

```bash
$ ./standalone.sh  -b jboss.localhost  \
      --server-config=standalone-ha.xml \
      -Dorg.jboss.modcluster.USE_HOST_NAME=true
```

to run

```bash
$ docker run -p 7070:80 -p 6666:6666 \
   --rm --name mod_cluster \
   --add-host jboss.localhost:172.17.0.1  \
    com.edc4it/httpd-mod_cluster:1.0
```
