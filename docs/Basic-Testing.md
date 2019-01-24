# Basic Testing

You can test whether the deployment of basic Docker images was correct.

Follow these steps:

1. Follow the [Getting Started instructions](./Getting-Started.md)

2. Access URL: [http://localhost:20010/powerauth-admin/login](http://localhost:20010/powerauth-admin/login)

3. Login with username: `admin`, password: `admin`:

![Preview](./resources/images/pa-admin-login.png)

4. Create a new application, specify a name, e.g. `test`:

![Preview](./resources/images/pa-admin-app-create.png)

The application is created with generated master public key, application key and application secret:

![Preview](./resources/images/pa-admin-app-detail.png)