# Volumes

Volumes are the way in which a container can share information with the host.
They can be used to share the contents of a folder in the host with the container and viceversa.

## Conventional Approach

Typically, in the `docker-compose.yml` you can define volumes with absolute paths in the host.
For example,
```
...
    volumes:
      - ./volumes/data:/data
      - ./volumes/log:/log
...
```

This would map a local folder located at `./volumes/data` (relative to the `docker-compose.yml` path) with a volume that will be mounted at `/data/`.
Thus, the contents located at the folder can be accessed from both, the container and the host.

## Production ready

However, most of the times using folders which are located within the code directory is not desired so as to avoid accidental writing operations.
Using relative paths can also bring some problems when the container is being deployed in different systems and with different host OS.
To do so, `volumes` can be used so as to tell `docker-compose` that the contents mapped within the container should be expected at a docker-controlled location.

```
services:
  main_service:
    ...
    volumes:
      - data_vol:/data
      - log_vol:/log

volumes:
  data_vol:
    driver: local
  log_vol:
    driver: local
```

By defining them with strings, we delegate into `docker` the management of the location.

## Automatic Creation of Volumes

Note that, if needed, it is heavily recommended to use different volumes for each deployment.
That is why the aforementioned example is modified onto a more flexible approach using the strings defined in the `.env` file as explained in the [`./ENVIRONMENT_VARIABLES.md`](./ENVIRONMENT_VARIABLES.md) file:

```
services
    main_service"::
    ...
    volumes:
      - data_vol:/data
      - log_vol:/log
      - ./config/${ENVIRONMENT:-dev}/cron.d:/etc/cron.d

volumes:
  data_vol:
    name: ${ENVIRONMENT:-dev}_data_vol
    driver: local
  log_vol:
    name: ${ENVIRONMENT:-dev}_log_vol
    driver: local
```

With `ENVIRONMENT=pro`, this is equivalent to:

```
services
    main_service"::
    ...
    volumes:
      - data_vol:/data
      - log_vol:/log
      - ./config/${ENVIRONMENT:-dev}/cron.d:/etc/cron.d
volumes:
  data_vol:
    name: pro_data_vol
    driver: local
  log_vol:
    name: pro_log_vol
    driver: local
```

This is good because different environments can be used safely in a single machine without mixing others.
Of course, additional volumes can be added depending on the needs.

The only exception as shown above is the example of the configuration of how the `/etc/cron.d/` is mapped from the host.
This information is grabbed from the `./config/${ENVIRONMENT}/cron.d` folder meaning that the scheduled tasks can be mapped at deployment time.
