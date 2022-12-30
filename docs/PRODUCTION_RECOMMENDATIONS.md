# Moving-to-Production Recommendations

So as to move to a production-ready environment, some recommendations are defined below after cloning the project from the Git repository.

## Setting the First Production Environment

This will bring a default installation WITHOUT production variables.

1. Set the `ENVIRONMENT` variable in the `.env` to `pre`, `pro` or whatever other environment you are using. This will create the volumens for the environment automatically when launching  `docker-compose`.
2. Create or update the `config/<ENVIRONMENT>/variables.env`, depending on the `ENVIRONMENT` value used in the `.env` file. Note that if the environment variable does not exist (which will happen if you have not copied it from the template), `docker` will complain.

```
$ docker compose up
ERROR: Couldn't find env file: /tmp/<project-folder>/config/pre/variables.env
```

3. Build the image and start the service:

```
$ docker compose up
```

Consider using similar approaches for any other new services deployed in the `docker-compose.yml` file.

## Bring Patches and Upgrading

In serious projects, you will ship patches and features from time to time.
Bringing this patches onto the project is easier now that production environment variables are shipped apart.

After shutting down the server (`docker compose down`), you can now bring your patches:

```
$ git pull
```

This will bring the code patches to your local deployment.
However, as both, data and environment variables are kept apart from the code, you will just need to build the new container locally in your host.

This can be done as stated in the main [`./README.md`](../README.md):

```
$ docker compose up --build
```

Note that it is strongly recommended to have this in mind when shipping upgrades and bug fixes: devops teams might be expecting to work in this way when shipping upgrades, so keeping environment-things documented and separated is desired.

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
main_service_1  | [INFO] tempered-iron @ 2022-04-05 15:45:00,779 | Checking the public IP…
main_service_1  | [DEBUG] tempered-iron @ 2022-04-05 15:45:00,781 | Starting new HTTPS connection (1): ifconfig.me:443
main_service_1  | [DEBUG] tempered-iron @ 2022-04-05 15:45:01,040 | https://ifconfig.me:443 "GET / HTTP/1.1" 200 14
...
main_service_1  | [DEBUG] tempered-iron @ 2022-04-05 15:52:00,738 | Starting new HTTPS connection (1): ifconfig.me:443
main_service_1  | [DEBUG] tempered-iron @ 2022-04-05 15:52:00,962 | https://ifconfig.me:443 "GET / HTTP/1.1" 200 14
main_service_1  | [INFO] tempered-iron @ 2022-04-05 15:52:00,964 | My public IP is: XX.XX.XX.XX
main_service_1  | [INFO] tempered-iron @ 2022-04-05 15:52:00,964 | Closing the application…
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
/app # whoami
root
/app # ls
run.py
```
