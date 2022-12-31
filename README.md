# Template Iron: A template for easy-to-deploy dockerized containers

A Docker Compose template container conceived to easily share applications with a smart management of environments.
This project is thought to ease the process of deploying scripts and solutions which need to have some dependencies and environment settings defined in before hand.

The default functionality of the container is limited to trying to logging the public IP address of the container. 
This task is performed, by default, each and every minute as defined in the `crontab` file to illustrate the approach.

## License

This software is licensed using GPLv3. Check the [`COPYING`](COPYING) file for further details.

## Dependencies

Check that you have Docker installed in your computer.
Specfic instructions to do so in your OS can be found in the official docs for Docker ([here](https://docs.docker.com/get-docker/)). 
Note that old versions of Docker will not install Docker Compose as part of Docker.
This means that any reference to `docker compose` (being `compose` a subcommand of `docker`) will have to be substituted by `docker-compose`. 
The ouptut will typically look like this:

```
$ docker compose up
docker: 'compose' is not a docker command.
See 'docker --help'
```

In those cases, install Docker Compose as shown [here](https://docs.docker.com/compose/install/) and check the installation like this:

```
$ docker --version
Docker version 18.09.0, build 4d60db4
$ docker compose --version
docker compose version 1.23.1, build b02f1306
```

For convenience, the `Dockerfile` will deal with the Python dependencies at building time using `pip`, but any other additional dependencies and images can be used here.
In this case, it is a simple as installing the dependencies set in the `requirements.txt` file.
Add in this file any other dependencies that you may need.

## Quick Start

First of all, clone the repository and then, fill in the `.env` file with the environment variables pointing the environment variables files to the appropriate `config/pro/` folder or the `config/dev` one depending on your current environment.
By default, the `config/dev` samples will be loaded.
Note that some files in the config folder are deliberately not copied in the Git repository.

To start everything, use:

```
$ docker compose up 
```

Note that if you make changes and you want to see them you will need the `--build` option:

```
$ docker compose up --build
Building main_service
Sending build context to Docker daemon  221.2kB
Step 1/9 : FROM python:3.10-alpine
 ---> 2527f31628e7
Step 2/9 : COPY ./docker-entrypoint.sh /
 ---> Using cache
 ---> 19f8ffddb714
Step 3/9 : ADD requirements.txt /tmp/requirements.txt
 ---> Using cache
 ---> 38eee3cce847
Step 4/9 : RUN pip install -r /tmp/requirements.txt
 ---> Using cache
 ---> d872ee4d3ed0
Step 5/9 : RUN mkdir /data
 ---> Using cache
 ---> acf1704e22e1
Step 6/9 : RUN mkdir /log
 ---> Using cache
 ---> a0e82b187ff7
Step 7/9 : ADD app /app
 ---> Using cache
 ---> 72f63d819973
Step 8/9 : WORKDIR /app
 ---> Using cache
 ---> b0fd5ba999a3
Step 9/9 : ENTRYPOINT ["/docker-entrypoint.sh"]
 ---> Using cache
 ---> 2453fe7bcf18
Successfully built 2453fe7bcf18
Successfully tagged tempered-iron_main_service:latest
Starting tempered-iron_main_service_1 ... done
Attaching to tempered-iron_main_service_1
main_service_1  | [*] Verifying permissions of the service crontab at '/etc/cron.d/service-crontab'…
main_service_1  | /docker-entrypoint.sh: line 4: /etc/cron.d/service-crontab: Permission denied
main_service_1  | [*] Installing crontab from …
main_service_1  | [*] Showing installed cron jobs…
main_service_1  | * * * * * python3 /app/run.py
main_service_1  | 
main_service_1  | 
main_service_1  | [*] Starting cron daemon…
```

Once started, the deployed container will start a cron service to run schedule tasks.
In this context, the scheduled task is as simple as grabbing the public IP address and logging it both, in the terminal and in a specific log file under `/log` in the container.

## Additional Docker and Docker Compose Tips

To stop the containers, you can always use `docker compose down` from the project home.
At the same time, to reraise without building, use `docker compose up`.
Note that this approach will show the output in the terminal.
However, running this in detached mode can be useful.

```
$ docker compose up -d
```

To grab the logs of a specifc container set up using `docker-compose` you can use a specific command: `docker compose logs <service_name>` as follows:

```
$ docker compose logs
Attaching to temperediron_main_service_1
main_service_1  | [INFO] tempered_iron @ 2022-04-05 15:45:00,779 | Checking the public IP…
main_service_1  | [DEBUG] tempered_iron @ 2022-04-05 15:45:00,781 | Starting new HTTPS connection (1): ifconfig.me:443
main_service_1  | [DEBUG] tempered_iron @ 2022-04-05 15:45:01,040 | https://ifconfig.me:443 "GET / HTTP/1.1" 200 14
...
main_service_1  | [DEBUG] tempered_iron @ 2022-04-05 15:52:00,738 | Starting new HTTPS connection (1): ifconfig.me:443
main_service_1  | [DEBUG] tempered_iron @ 2022-04-05 15:52:00,962 | https://ifconfig.me:443 "GET / HTTP/1.1" 200 14
main_service_1  | [INFO] tempered_iron @ 2022-04-05 15:52:00,964 | My public IP is: XX.XX.XX.XX
main_service_1  | [INFO] tempered_iron @ 2022-04-05 15:52:00,964 | Closing the application…
```

With this approach, the application will end a return to the prompt.
However, if you prefer to _follow_ the logs, you can use the `-f` or `--follow` as shown with `docker compose logs --help` so as to let the application wait for new lines:

```
$ docker compose logs --help
View output from containers.

Usage: logs [options] [SERVICE...]

Options:
    --no-color          Produce monochrome output.
    -f, --follow        Follow log output.
    -t, --timestamps    Show timestamps.
    --tail="all"        Number of lines to show from the end of the logs
                        for each container.
$ docker compose logs -f
```

Once started, the deployed container will start a cron service to run scheduled tasks as stated in the `/etc/cron.d/servuce-crontab` file within the container.
In this context, the scheduled task is as simple as grabbing the public IP address and logging it both, in the terminal and in a specific log file under `/log` in the container and in a volume mounted in the host.

### Basic debugging

Note that when developing the application things may crash.
This WILL happen.
You can enter the container and run manually the application by listing the containers and opening a shell on it.
To do so:

1. List the containers being run (YOU SHOULD HAVE NOT STOPPED THE CONTAINER BY YOURSELF!):

```
$ docker ps
CONTAINER ID   IMAGE                            COMMAND                  CREATED          STATUS              PORTS     NAMES
3efb87232dd4   tempered-iron_main_service   "/docker-entrypoint.…"   2 minutes ago   Up 10 seconds             tempered-iron_main_service_1
```

2. Identify the `CONTAINER ID`. In this case, `3efb87232dd4`.

3. Logging into the container:

```
$ docker exec -it 29a49899accb sh
/app # whoami
root
/app # ls
run.py
/app # 
```

You are now in the container! Have fun!

## Additional Tuning

The environment sets up a default behaviour that automates a scheduled task at different times depending on the environment.
Note that during the build process a service-crontab is added to the `/etc/crontab.d/` folder. 
This file is then mounted in the `docker-compose.yml` file so as to use the provided configuration defined in the `dev`, `pre` or `pro` environment.
This is done by the following lines in the `docker-compose.yml`.
This means that if the frequency is expected to be changed in any of the environments, this has to be set.
Follow the instructions on [`./PRODUCTION_RECOMMENDATIONS.md`](./docs/PRODUCTION_RECOMMENDATIONS.md) to set this.

Note that you can find more information about the project in the [`./ENVIRONMENT_VARIABLES`](./docs/ENVIRONMENT_VARIABLES.md) with more information about how to work with environment variables.
At the same time in the [`./VOLUME_MANAGEMENT.md`](./docs/VOLUME_MANAGEMENT.md) you can find more information about how volumes are used.

