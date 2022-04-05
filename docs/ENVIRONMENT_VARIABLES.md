# Environment Variables

Environment variables are a typical way of configuring the different environments.
In this file [we](mailto:felix.brezofernandez@telefonica.com) propose an approach based to set the environment using different environment folders.
These folders in this directory contain the environment variable files for the different services that are being deployed using `docker-compose`. 

## About the Different Environments

There can be defined as many environments as desired under the `config` folder. 
By default, two different environment are included:

- `dev`. Used for quick and fast deployments. Simply  by following the initial instructions, a new local environment can be installed.
- `pro`. Used for production. Note that production-ready variables are deliberately ignored in the folder. Thus, `template` files are used in this folder. Note that to avoid the credential leakage, production environment variables SHOULD be avoided in the platform.

Preferably, for bigger projects, additional environments will be created such as `qa`/`testing`, `security` or `pre`.
Note that `pro/service_variables.env` and `pre/service_variables.env` are ignored in the `.gitignore` file by default But any other environment SHOULD be manually added to the `.gitignore` to be sure that no additional file is being added to Docker by mistake.

## The Usage of the `.env` File

The `.env` file in the main folder is not a standard environment variable file.
Environment variables to be used within a container SHOULD not be defined here, since this file is used natively by `docker-compose` to replace the values of the string within that file.

For example, the `.env` file can be used to tell `docker-compose` which environment variables to use in the `docker-compose.yml` deployment without even changing the `docker-compose.yml` file and the name of the volumes and services that will be created.

The initial contents of this file make reference to the following strings:

- `ENVIRONMENT`. Used to define the configuration to be loaded in the created containers.


```
ENVIRONMENT=dev
```

The `docker-compose.yml` file is already build with this approach in mind as explained in the 

## Details

This section defines the environment variables that are being used in this full dockerised environment.

- `LOGGER_NAME`. Sets the name for the logger.
- `LOG_LEVEL`. Sets the logging level. It SHOULD be one of the following: `DEBUG`, `INFO`, `WARNING` or `ERROR`.

In Python scripts, note that the value of an environment variable named `LOGGER_NAME` can be grabbed as follows:

```
import os
VALUE = os.environ.get("LOGGER_NAME", "Logger")
```

Note that, using `os.environ.get("<ENVIRONMENT_VARIABLE_NAME>", "<DEFAULT_VALUE")` is often prefered to using `os.environ["<ENVIRONMENT_VARIABLE_NAME>"]` to set default values if they are not present and avoid the fact of having to deal with exceptions.