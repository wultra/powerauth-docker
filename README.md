# Docker Images for PowerAuth 2.0

## Turbo Start

```sh
$ bash <(curl -fsSL https://raw.githubusercontent.com/lime-company/lime-security-powerauth-docker/master/launch.sh)
```

## Getting Started

To install PowerAuth 2.0 in your Docker instance, perform following steps:

### 0. Install Docker

Obviously, you need Docker to use our Docker images. Docker is easy to install, just follow the [official documentation](https://docs.docker.com/engine/getstarted/step_one/).

### 1. Clone the Repository

```sh
$ git clone https://github.com/lime-company/lime-security-powerauth-docker.git
```

### 2. Configure Build Properties

_(Optional)_

If you don't not do anything with the configuration, everything will just work on your local machine.

Each application has a `conf` folder, where you can configure properties for your particular instance. See the documentation of the respective applications to learn about the meaning of properties:

- [PowerAuth 2.0 Server](https://github.com/lime-company/lime-security-powerauth/wiki/Deploying-PowerAuth-2.0-Server)
- [PowerAuth 2.0 Admin](https://github.com/lime-company/lime-security-powerauth-admin/wiki/Deploying-PowerAuth-2.0-Admin)

### 3. Build Docker Images

Run `build.sh` command from the root of the repository, wait for the images to be built.

```sh
$ cd lime-security-powerauth-docker
$ sh build.sh
```

### 4. Run Images

Run Docker Compose in the root folder:

```sh
$ docker-compose up -d
```

See `docker-compose.yml` for the default configuration.

If you didn't change the default application settings, everything should just work.

Following configuration is used by default:

- MySQL Docker Image
    - New MySQL image will be created, with a default PowerAuth 2.0 DB schema in place.
    - Two users are created: "root"/"root" and "powerauth" with no password.
    - Database files are created in `/tmp/mysql` folder by default.
    - To connect to database from host, use `jdbc:mysql://localhost:3306/powerauth` with `powerauth` user (no password).
    - To connect to database from Docker container, use `jdbc:mysql://powerauth-mysql:3306/powerauth` with `powerauth` user (no password).
- PowerAuth 2.0 Server
    - SOAP / REST service are not be secured by any integration credentials.
    - Database connectivity points to the MySQL instance in the docker image.
    - Default application name "powerauth" and display name "PowerAuth 2.0 Server" will be used.
    - To access the SOAP service WSDL from host, open http://localhost:8080/powerauth-java-server/soap/service.wsdl.
    - To access the SOAP service WSDL from Docker container, use http://powerauth-java-server:8080/powerauth-java-server/soap/service.wsdl.
- PowerAuth 2.0 Admin
    - Admin will point to the PowerAuth 2.0 Server Docker instance.
    - No security credentials will be configured.
    - Admin will be secured using a static LDAP file, with a single "admin"/"admin" user (see `ldap-local.ldiff`).
    - Admin will not accept invalid SSL certificates.
    - You can open the application from host by opening http://localhost:18080/powerauth-admin and using `admin` user with password `admin`.

## License

All sources are licensed using Apache 2.0 license, you can use them with no restriction. If you are using PowerAuth 2.0, please let us know. We will be happy to share and promote your project.
