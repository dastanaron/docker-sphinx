Docker-Sphinx
==========================

This repository is based on Linux (alpine:latest). 

[Container on DockerHub](https://hub.docker.com/r/dastanaron/sphinx)

How it uses
------------------------------------------------
You can pull this container from DockerHub

```bash
docker pull dastanaron/sphinx
```

and start it with default settings, or you can create yourself build with your configuration

```bash
docker run --name sphinx -v /path-to-your-config:/etc/sphinx/ dastanaron/sphinx
```

This path must contains `default.conf` file

How it uses with docker-compose
------------------------------------------------
You can create your own build, based on this, only with your own config, since in the repository I created it as an example, so that I can check the launch

### Example build
```dockerfile
FROM dastanaron/sphinx:3.2.1

COPY ./config/sphinx.conf /etc/sphinx/default.conf
RUN mkdir -p /var/sphinx/dictionary
COPY ./run /usr/local/sphinx/bin/run-sphinx

CMD run-sphinx
```

### Example run-sphinx
```bash
#!/usr/bin/env sh

indexer --all --rotate --config /etc/sphinx/default.conf
searchd --nodetach --config /etc/sphinx/default.conf
```

### Example docker-compose config
```docker-compose
version: '3.7'
services:
  example-service:
    build:
      context: ./path-to-dockerfile/
    ports:
      - '80:8080'
    volumes:
      - /path-to-volume/ /path-to-container-volume/
    depends_on:
      - sphinx
      - pgsql
  pgsql:
    image: postgres:latest
    restart: always
    ports:
      - "5432:5432"
    volumes:
      - ./pgsql:/var/lib/postgresql/data:cached
    environment:
      POSTGRES_PASSWORD: pg
      POSTGRES_USER: pg
      POSTGRES_DB: shared
  sphinx:
    restart: always
    build:
      context: ./path-to-your-build/
    ports:
      - "9306:9306"
      - "9312:9312"
    volumes:
      - ./sphinx:/var/data/sphinx/
    depends_on:
      - pgsql
```

Paths to files in the container
----------------------------------------------------

```bash
/usr/local/sphinx/bin/ #path with sphinx binaries
/var/log/sphinx/       #log path
/etc/sphinx/           #configuration path
/var/data/sphinx/      #Index and dictionary path
```
