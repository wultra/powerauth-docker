![](./assets/powerauth-docker-blue.png)

# Docker Images for PowerAuth 2.0

## Prerequisites

- **Docker.** (version 17.3.1+) Obviously, you need Docker to use our Docker images. :-) Docker is easy to install, follow the [official documentation](https://docs.docker.com/engine/getstarted/step_one/).
- **Docker Compose.** (version 1.11.2+) Compose is an extension to Docker that simplifies container image deployment and configuration management.
- **Unix-based operating system.** While our software can run in Windows as well, we optimized our scripts for Linux / Unix environment. We proudly build all our packages on Mac OS X.

## Step By Step Start

To install PowerAuth 2.0 stack in your Docker instance, perform following steps:

### 1. Download

First, clone the repository with Docker related files:

```sh
$ git clone https://github.com/lime-company/powerauth-docker.git
```

Then, add following files in the cloned repository:

- WAR files with required PowerAuth applications, see `deploy/images/readme.txt` for details.
- JAR files with JDBC drivers required for JPA connectivity, see `deploy/lib/readme.txt` for details.

_Note: While you need to provide Oracle JDBC driver, we do not provide Docker images with Oracle database. Driver file (`ojdbc6.jar`) is mainly required in a real production database, in case applications are configured so that they point to a production Oracle DB._

### 2. Configure

If you don't not do anything with the configuration, everything will just work on your local machine.

Each application has a context XML file (see `deploy/conf` folder), where you can configure properties for your particular instance. See the documentation of the respective applications to learn about the meaning of properties.

In case you would like to run PowerAuth stack with provided MySQL images for Docker, you may also need to customize MySQL init scripts stored in `deploy/data/mysql` (only in case you would like to pre-populate database with data).

Note that by default, MySQL images are mounted to `/var/lib/powerauth/**` path, that does not have to be accessible. To customize MySQL instance in containers (root password, host folder mapping), you can change the related environment variables in `.env` file. You can always override these variables while launching `docker-compose up` command as well, for example (to use volatile `/tmp/powerauth/**` folders):

```sh
POWERAUTH_MYSQL_PATH=/tmp/powerauth/mysql \
POWERAUTH_PUSH_MYSQL_PATH=/tmp/powerauth/mysql-push \
POWERAUTH_WEBFLOW_MYSQL_PATH=/tmp/powerauth/mysql-webflow \
docker-compose up -d
```

Finally, you can edit PowerAuth Admin users by modifying `deploy/data/ldap/ldap-local.ldiff` file.

### 3. Build

Run `build.sh` command from the root of the repository, wait for the images to be built.

```sh
$ sh build.sh
```

### 4. Run

Run Docker Compose in the root folder:

```sh
$ docker-compose up -d
```

See `docker-compose.yml` for the default configuration.

## License

All sources are licensed using Apache 2.0 license, you can use them with no restriction. If you are using PowerAuth 2.0, please let us know. We will be happy to share and promote your project.
