FROM python:3.10-alpine

COPY ./docker-entrypoint.sh /

# Fixing Python deps
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Creating folders for the volumes
RUN mkdir /data
RUN mkdir /log

# Adding the app itself
ADD app /app
WORKDIR /app
ENTRYPOINT ["/docker-entrypoint.sh"]
