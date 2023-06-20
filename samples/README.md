# samples

build: 

```shell
docker build -f samples/Dockerfile.simple -t grunner-simple .
```

run: 

```shell
docker run --rm -it --entrypoint /bin/bash docker.io/library/grunner-simple
```