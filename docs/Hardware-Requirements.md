# Hardware Requirements

The HW requirements for the default Docker images are low and current commodity hardware will be able to run the software nicely. If in doubt, use following HW configuration.

## Hardware Platforms

Following hardware platforms are supported by PowerAuth Docker images:
- amd64 (also known as x86_64)
- s390x
- ppc64le

Note that running the Docker images on ARM platforms (including Apple Silicon) is currently not supported. We will update the Docker images once Open9J Java gets ported to this platform.

## Hardware Requirements of Basic Docker Images for PowerAuth Server and Push Server

- 2GB free RAM for Docker
- 16GB free disk space
- CPU 4×core, 2.0GHz

## Hardware Requirements for Whole PowerAuth Stack Including Web Flow

- 4GB free RAM for Docker
- 16GB free disk space
- CPU 4×core, 2.0GHz

## Database Storage

The free disk space mentioned above does not include storage required for the database. The required database space greatly depends on the number of transactions that will be authorized via the system.

Since the data stored in the database may be needed to provide and authorization prove for given transaction, the data should not be deleted (and should be archived). As a result, practical requirement for the database is an "infinite growth" - the storage allocated for the database has to be large enough.

Note that while we include PostgreSQL Docker images in the distribution, you should always use externally mapped database for production.
