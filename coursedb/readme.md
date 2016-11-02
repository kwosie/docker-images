
to build

```
$ docker build -t edc4it/coursedb:1.0 .
```

to run

```
$ docker run -p 5432:5432 -Pd --name coursedb edc4it/coursedb:1.0

```
