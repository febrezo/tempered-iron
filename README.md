# Template Iron: A template for easy-to-deploy dockerized containers

A Docker Compose template container conceived to easily share applications with a smart management of environments.
This project is thought to ease the process of deploying scripts and solutions which need to have some dependencies and environment settings defined in before hand.

The default functionality of the container is limited to trying to logging the public IP address of the container. 
This task is performed, by default, each and every minute as defined in the `crontab` file to illustrate the approach.

## License

This software is licensed using GPLv3. Check the [`COPYING`](COPYING) file for further details.

## Dependencies

Check that you have Docker and Docker Compose installed in your computer.
Specfic instructions to do so in your OS can be found in the official docs for Docker ([here](https://docs.docker.com/get-docker/)) and Docker Compose ([here](https://docs.docker.com/compose/install/)).

Once installed, you can check the versions using the following commands:

```
$ docker --version
Docker version 18.09.0, build 4d60db4
$ docker-compose --version
docker-compose version 1.23.1, build b02f1306
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
$ docker-compose up 
```

Note that if you make changes and you want to see them you will need the `--build` option:

```
$ docker-compose up --build
Building main_service
Step 1/10 : FROM python:3.10-alpine
 ---> 482b8fa3563e
Step 2/10 : RUN apk update
 ---> Using cache
 ---> 39bccfa17f0d
Step 3/10 : COPY config/dev/cron.d/service-crontab /etc/cron.d/service-crontab
 ---> Using cache
 ---> 11b24ce1300a
Step 4/10 : RUN chmod 0644 /etc/cron.d/service-crontab &&    crontab /etc/cron.d/service-crontab
 ---> Using cache
 ---> 5d5a0e2a504c
Step 5/10 : ADD requirements.txt /tmp/requirements.txt
 ---> Using cache
 ---> d8e86d8bba81
Step 6/10 : RUN pip install -r /tmp/requirements.txt
 ---> Using cache
 ---> 2e4742159266
Step 7/10 : RUN mkdir /data
 ---> Using cache
 ---> 40b54851e289
Step 8/10 : ADD app /app
 ---> 93e29a3a9aa6
Step 9/10 : WORKDIR /app
 ---> Running in 08a379190249
Removing intermediate container 08a379190249
 ---> 2c703d06f589
Step 10/10 : ENTRYPOINT ["sh", "-c" , "crond -f"]
 ---> Running in ad51f1e83a7d
Removing intermediate container ad51f1e83a7d
 ---> 425bae76ea02

Successfully built 425bae76ea02
Successfully tagged temperediron_main_service:latest
Recreating temperediron_main_service_1 ... 
Recreating temperediron_main_service_1 ... done
Attaching to temperediron_main_service_1
main_service_1  | [INFO] tempered_iron @ 2022-04-05 15:45:00,779 | Checking the public IP…
main_service_1  | [DEBUG] tempered_iron @ 2022-04-05 15:45:00,781 | Starting new HTTPS connection (1): ifconfig.me:443
main_service_1  | [DEBUG] tempered_iron @ 2022-04-05 15:45:01,040 | https://ifconfig.me:443 "GET / HTTP/1.1" 200 14
main_service_1  | [INFO] tempered_iron @ 2022-04-05 15:45:01,041 | My public IP is: XX.XX.XX.XX
main_service_1  | [INFO] tempered_iron @ 2022-04-05 15:45:01,041 | Closing the application…
```

Once started, the deployed container will start a cron service to run schedule tasks.
In this context, the scheduled task is as simple as grabbing the public IP address and logging it both, in the terminal and in a specific log file under `/log` in the container.

## Additional Docker and Docker Compose Tips

To stop the containers, you can always use `docker-compose down` from the project home.
At the same time, to reraise without building, use `docker-compose up`.
Note that this approach will show the output in the terminal.
However, running this in detached mode can be useful.

```
$ docker-compose up -d
```

To grab the logs of a specifc container set up using `docker-compose` you can use a specific command: `docker-compose logs <service_name>` as follows:

```
$ docker-compose logs
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
However, if you prefer to _follow_ the logs, you can use the `-f` or `--follow` as shown with `docker-compose logs --help` so as to let the application wait for new lines:

```
$ docker-compose logs --help
View output from containers.

Usage: logs [options] [SERVICE...]

Options:
    --no-color          Produce monochrome output.
    -f, --follow        Follow log output.
    -t, --timestamps    Show timestamps.
    --tail="all"        Number of lines to show from the end of the logs
                        for each container.
$ docker-compose logs -f
```

Note that for debugging purposes you might find useful to enter the container using a shell.
This can be done using `docker exec -it` command once you know the name of the container.
In the aformentioned case, you can see in that the ID of the container is `425bae76ea02` from the output.

If you have already run the container, you can check the running ones using `docker ps` to get the ID of the container you want to enter.

```
$ docker ps
CONTAINER ID   IMAGE                       COMMAND                  CREATED         STATUS         PORTS     NAMES
cf5d42a2da7d   temperediron_main_service   "sh -c 'crond -f' sh…"   2 minutes ago   Up 2 minutes             temperediron_main_service_1
```

In this case, entering the container is as simple as entering the container with a shell in interactive mode (`-it`).
Note that the default shell of Alpine containers is `sh`, but use `bash` if it is available in the Docker image you used as a base image.

```
$ docker exec -it cf5d42a2da7d sh
/app # ls
run.py
/app # python3 run.py 
[INFO] tempered_iron @ 2022-04-05 15:49:08,761 | Checking the public IP…
[DEBUG] tempered_iron @ 2022-04-05 15:49:08,763 | Starting new HTTPS connection (1): ifconfig.me:443
[DEBUG] tempered_iron @ 2022-04-05 15:49:08,928 | https://ifconfig.me:443 "GET / HTTP/1.1" 200 14
[INFO] tempered_iron @ 2022-04-05 15:49:08,930 | My public IP is: XX.XX.XX.XX
[INFO] tempered_iron @ 2022-04-05 15:49:08,930 | Closing the application…
/app # cd /log/
/log # ls
tempered_iron.log
/log # tail -n 10 tempered_iron.log 
[INFO] tempered_iron @ 2022-04-05 15:49:00,727 | Checking the public IP…
[DEBUG] tempered_iron @ 2022-04-05 15:49:00,729 | Starting new HTTPS connection (1): ifconfig.me:443
[DEBUG] tempered_iron @ 2022-04-05 15:49:00,940 | https://ifconfig.me:443 "GET / HTTP/1.1" 200 14
[INFO] tempered_iron @ 2022-04-05 15:49:00,942 | My public IP is: XX.XX.XX.XX
[INFO] tempered_iron @ 2022-04-05 15:49:00,942 | Closing the application…
[INFO] tempered_iron @ 2022-04-05 15:49:08,761 | Checking the public IP…
[DEBUG] tempered_iron @ 2022-04-05 15:49:08,763 | Starting new HTTPS connection (1): ifconfig.me:443
[DEBUG] tempered_iron @ 2022-04-05 15:49:08,928 | https://ifconfig.me:443 "GET / HTTP/1.1" 200 14
[INFO] tempered_iron @ 2022-04-05 15:49:08,930 | My public IP is: XX.XX.XX.XX
[INFO] tempered_iron @ 2022-04-05 15:49:08,930 | Closing the application…
```


## Additional Tuning

The environment sets up a default behaviour that automates a scheduled task at different times depending on the environment.
Note that during the build process a service-crontab is added to the `/etc/crontab.d/` folder. 
This file is then mounted in the `docker-compose.yml` file so as to use the provided configuration defined in the `dev`, `pre` or `pro` environment.
This is done by the following lines in the `docker-compose.yml`.
This means that if the frequency is expected to be changed in any of the environments, this has to be set.
Follow the instructions on [`./PRODUCTION_RECOMMENDATIONS.md](./docs/PRODUCTION_RECOMMENDATIONS.md) to set this.

Note that you can find more information about the project in the [`./ENVIRONMENT_VARIABLES`](./docs/ENVIRONMENT_VARIABLES.md) with more information about how to work with environment variables.
At the same time in the [`./VOLUME_MANAGEMENT.md`](./docs/VOLUME_MANAGEMENT.md) you can find more information about how volumes are used.


