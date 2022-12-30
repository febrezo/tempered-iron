# Lessons Learned

There are a few concepts about Docker containers and volumes, Pip, Python, Cron and basic GNU/Linux tips that you may learn from using this repository.
The following is a non-exhaustive list of concepts that are widely used and that the author thinks that may be useful for those who want to understand the hows and whys about this repository.

## Python and Pip

Typically, dependencies in Python are managed using Pip.
That's why many projects will ask you to install a dependency (e. g., the `requests` package) using something like this:

```
$ pip3 install requests
```

These dependencies are automatically downloaded from Python Package Index (the well-known PyPI) by default.
However, when there are a lot of requirements, a `requirements.txt` file is more appropriate to avoid having to install all dependencies manually.
That's why in many places fixing dependencies will look like this to go through a series of dependencies:

```
$ pip3 install -r requirements.txt
```

There is a minor trick performed in this project regarding the requirements.
The project eases the installation of a package which is stored in Github as a private repository so the building process will need to have read acess to read it.
That's why there is a strange and long line in this file.


Note that this project uses Python 3. 
In fact, since it uses f-strings (check [this](https://docs.python.org/3/tutorial/inputoutput.html) to understand their usage), only Python 3.6+ can be used.

The project also receives configuration variables as OS environment variables.
This is very useful to share configurations between services. 
Note that OS environment variables can be easily grabbed in Python using:

```
import os
my_vars = os.environ
print(my_vars)
```

At the same time, it is recommended to avoid printing logging lines.
The sample project uses a basic logging manager that logs things in a given format and sends the output to a logging file.
Both concepts, environment variables and logging are demo-ed in the `run.py` file under the sample `app` folder.

```
import logging
import os

…

# Grabbing environment variables
LOGGER_NAME = os.environ.get("APP_NAME", "tempered-iron")
LOG_LEVEL = os.environ.get("LOG_LEVEL", "INFO")

logging.basicConfig(
    level=LOG_LEVEL,
    format=f"[%(levelname)s] {LOGGER_NAME} @ %(asctime)s | %(message)s",
    handlers=[
        logging.FileHandler(f'/log/{LOGGER_NAME}.log'),
        logging.StreamHandler()
    ]
)

…

def main():
    logging.info("Checking the public IP…")
…
```

## Docker

One of the problems of managing different environments are dependencies and conflicts between them when being installed in different systems.
That's where Docker (and the `Dockerfile` files) appear.
In a `Dockerfile` we are telling Docker which is the base image to use (e. g., `FROM python:3.10-alpine`, `FROM ubuntu:latest`, etc.).
To that image we will be able to copy (both, `COPY` or `ADD` do basically the same, google it for the differences) the files we want to have in the built image from our host system.
Once everything desired is inside, we can run commands at building time (`RUN pip install -r requirements`) to prepare the image for the deployment.

Building a Docker image is the first step, but after building it we have to start it.
That is where the `docker-compose.yml` file can help a lot.
In a `docker-compose.yml` we can define the services we want to start like our own custom image or one taken from third parties to start a MySQL database, ElasticSearch or Mongo DB amongst many many others using, simply, a YAML syntax.

By default, when launching a `docker-compose.yml` file, `docker-compose` (or `docker compose` in recent versions) will try to locate a hidden `.env` file in the folder.
If found, it will read the variables on it a replace the values in the file with that value.

For example, if the `.env` file contains:

```
APP_NAME=hacking_app
```

And the `docker-compose.yml` contains the following lines:
```
      - APP_NAME=${APP_NAME}
```

This line will be interpreted by Docker as:

```
      - APP_NAME=hacking_app
```

Although this is a way of sharing values between different services, for security reasons, it is commonly not a good practice to share amongst all the services all the variables.
For example, a frontend may not need to have the DB credentials if the read/write operations are performed by some kind of middleware.

The point is that the `docker-compose.yml` file can help us to propagate specific environment variables to the different services using different approaches.
For example:

- Using the `environment:` keyword we can set an environment variable manually.

```
    env_file:
      - ./config/${ENVIRONMENT:-dev}/variables.env
```

- Using the `env_file:` keyword we can read them from a file and propagate them to the services we want.

```
    env_file:
      - ./config/${ENVIRONMENT:-dev}/variables.env
```

### Volumes

Once run, a container builds its OS and lives as a standard GNU/Linux OS with a given particularity: it is ephemeral.
Whenever you stop the container (or use `docker compose down`), things simply get vanished.

Of course, there is a way of persisting things: the volumes.
With a volume, in the `docker-compose.yml` file we can map a local folder in the host system onto a particular path in the `container`.
Take a look at these lines:


Of course, there is a way of persisting things: the volumes.
With a volume, in the `docker-compose.yml` file we can map a local folder in the host system onto a particular path in the `container`.
Take a look at these lines:

```
    volumes:
      - ./volumes/data:/data
      - ./volumes/log:/log
```

They mean that the `/data` and the `/log` folders INSIDE the container will be mapped onto newly created folders in the host under the relative paths `./volumes/data` and `./volumes/log`.
There are other ways to do this (google Docker volumes in production for more info), but this is basically how you can persist data: by making your app write things under these folders.


## Documentation

Documentation files are written in Markdown and they have a `.md` extension.
The names of the files are typically written in capital letters (i. e., `README.md`, `HACKING.md`, etc.).
Most of the reachable documentation folders contain a `README.md` file in their root as a reference file because Github, Gitlab and others will typically render the contents in these files by default when exploring the folder.

If you want to improve the way in which you write documentation in Markdown (bold, italics, links, images, tables, etc.), please refer to the [official docs](https://docs.github.com/es/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) at Github.
