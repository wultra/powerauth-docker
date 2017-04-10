![](./assets/powerauth-docker-blue.png)

# Docker Images for PowerAuth 2.0

## Prerequisites

- **Docker.** (version 17.3.1+) Obviously, you need Docker to use our Docker images. :-) Docker is easy to install, follow the [official documentation](https://docs.docker.com/engine/getstarted/step_one/).
- **Docker Copose.** (version 1.11.2+) Compose is an extension to Docker that simplifies container image deployment and configuration management.
- **Unix-based operating system.** While our software can run in Windows as well, we optimized our scripts for Linux / Unix environment. We proudly build all our packages on Mac OS X.

## Turbo Start

```sh
$ cd /tmp ; bash <(curl -fsSL https://git.io/vSogp)
```

## Step By Step

To install PowerAuth 2.0 in your Docker instance, perform following steps:

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

## Default Configuration

If you didn't change the default application settings, everything should just work.

### Application Configuration

Following configuration is used by default:

#### MySQL DB for PowerAuth Server

- New MySQL image will be created, with a default PowerAuth 2.0 Server DB schema in place.
- Two users are created: "root"/"root" and "powerauth" with no password.
- Database files are created in `/tmp/mysql-powerauth` folder by default.
- To connect to database from the host:
    - URL: `jdbc:mysql://localhost:23316/powerauth`
    - Username: `powerauth`
    - Password: _no password_
- To connect to database from Docker container:
    - URL: `jdbc:mysql://powerauth-mysql:3306/powerauth`
    - Username: `powerauth`
    - Password: _no password_

#### MySQL DB for Push Server

- New MySQL image will be created, with a default PowerAuth 2.0 Push Server DB schema in place.
- Two users are created: "root"/"root" and "powerauth" with no password.
- Database files are created in `/tmp/mysql-push` folder by default.
- To connect to database from the host:
    - URL: `jdbc:mysql://localhost:23336/powerauth`
    - Username: `powerauth`
    - Password: _no password_
- To connect to database from Docker container:
    - URL: `jdbc:mysql://powerauth-push-mysql:3306/powerauth`
    - Username: `powerauth`
    - Password: _no password_

#### PowerAuth 2.0 Server

- SOAP / REST service are not be secured by any integration credentials.
- Database connectivity points to the MySQL instance in the docker image.
- Default application name "powerauth" and display name "PowerAuth 2.0 Server" will be used.
- Access the SOAP service WSDL from the host here:
    - http://localhost:20010/powerauth-java-server/soap/service.wsdl
    - No credentials are required by default.
- Access the SOAP service WSDL from Docker container here:
    - http://powerauth-java-server:8080/powerauth-java-server/soap/service.wsdl
    - No credentials are required by default.

#### PowerAuth 2.0 Admin

- Admin will point to the PowerAuth 2.0 Server Docker instance.
- No security credentials will be configured.
- Admin will be secured using a static LDAP file, with a single "admin"/"admin" user (see `ldap-local.ldiff`).
- Admin will not accept invalid SSL certificates.
- Access the Admin application from host here:
    - http://localhost:20020/powerauth-admin
    - Use `admin` user with password `admin`

#### PowerAuth 2.0 Push Server

- Push Server will point to the PowerAuth 2.0 Server Docker instance.
- No security credentials will be configured.
- Access the Push Server application from host here:
    - http://localhost:20030/powerauth-push-server

### Default Port Mapping

Following mappings are used when mapping container ports to host ports:

| Application Name          | Application Image Name | Application Port | Database Image Name  | Database Port |
|---------------------------|------------------------|------------------|----------------------|---------------|
| PowerAuth 2.0 Server      | powerauth-java-server  | 20010            | powerauth-mysql      | 23316         |
| PowerAuth 2.0 Admin       | powerauth-admin        | 20020            | -                    | -             |
| PowerAuth 2.0 Push Server | powerauth-push-server  | 20030            | powerauth-push-mysql | 23336         |
| PowerAuth 2.0 RESTful API | powerauth-rest-api     | 18080            | -                    | -             |

## License

All sources are licensed using Apache 2.0 license, you can use them with no restriction. If you are using PowerAuth 2.0, please let us know. We will be happy to share and promote your project.
