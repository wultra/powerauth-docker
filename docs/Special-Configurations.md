# Special Configurations

During our deployments, we have found that some customers need couple extra configurations that are not really suitable for product extensions. This chapter covers these briefly.

## Logging to both `catalina.out` and `stdout`

By default, logs are printed to `stdout` only. To map them to `catalina.out` as well, change command in the end of the `Dockerfiles` to following one:

```
CMD /usr/local/tomcat/bin/catalina.sh run 2>&1 | tee -a /usr/local/tomcat/logs/catalina.out
```

## Custom timezone for logs

By default, logs are printed in UTC timezone, so that they are timezone independent. However, you can override this by setting the `TZ` environment variable to the container.

In Docker Compose, you can do it like so:

```yaml
services:
    powerauth-XYZ:
        environment:
            - TZ=Europe/Prague
```

In Kubernetes, you can do it like so:

```yaml
spec:
  template:
    spec:
      containers:
        env:
          - name: TZ
            value: Europe/Prague
```

## Random Number Generator (RNG) Performance

Docker images run in a very constrained environment compared to running on a physical machine. As a result, random number generators (RNG) have trouble gathering enough entropy and as a result, startup time of our Docker images can be very slow.

To fix that, you can use [`haveged`](https://github.com/harbur/docker-haveged) image that provides an entropy gathering service:

```sh
# HAVEGED_VERSION=1.7c-1
docker run --privileged -d harbur/haveged:${HAVEGED_VERSION}
```
