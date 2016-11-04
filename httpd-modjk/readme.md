# httpd with mod_jk image

based off https://hub.docker.com/_/httpd/

It connects to the host (port `172.17.0.1` see `workers.properties`). Make sure the `docker` network is allowed to access 
the AJP port on the host (defaults to `8009`). It currently forwards to the `httpsession-webapp` web context

The `/jkstatus` is mounted to check the status of the worker(s)

Add the AJP connector to JBoss/Tomcat

```xml
   <connector name="ajp" protocol="AJP/1.3" scheme="http" socket-binding="ajp"/>
```

to build the docker image

```bash
$ docker build --tag com.edc4it/httpd-modjk:1.0 .
```

to run 

```bash
$ docker run -p 7070:80 --rm --name mod_jk com.edc4it/httpd-modjk:1.0
```

