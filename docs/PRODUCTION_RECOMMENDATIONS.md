# Moving-to-Production Recommendations

So as to move to a production-ready environment, some recommendations are defined below after cloning the project from the Git repository.

## Setting the First Production Environment

This will bring a default installation WITHOUT production variables.

1. Set the `ENVIRONMENT` variable in the `.env` to `pre`, `pro` or whatever other environment you are using. This will create the volumens for the environment automatically when launching  `docker-compose`.
2. Create or update the `config/<ENVIRONMENT>/service_variables.env`, depending on the `ENVIRONMENT` value used in the `.env` file.
3. Create or update the `config/<ENVIRONMENT>/cron.d/service-crontab`, depending on the `ENVIRONMENT` value used in the `.env` file. This will defined the frequency with which the application will be executed. Note that you may need to create a new crontab file without the `.template` suffix shown in the template.
4. Build the image and start the service:

```
$ docker-compose up --build
```

Consider using similar approaches for any other new services deployed in the `docker-compose.yml` file.

## Bring Patches and Upgrading

In serious projects, you will ship patches and features from time to time.
Bringing this patches onto the project is easier now that production environment variables are shipped apart.

After shutting down the server (`docker-compose down`), you can now bring your patches:

```
$ git pull
```

This will bring the code patches to your local deployment.
However, as both, data and environment variables are kept apart from the code, you will just need to build the new container locally in your host.

This can be done as stated in the main [`./README.md`](../README.md):

```
$ docker-compose up --build
```

Note that it is strongly recommended to have this in mind when shipping upgrades and bug fixes: devops teams might be expecting to work in this way when shipping upgrades, so keeping environment-things documented and separated is desired.
