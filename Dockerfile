FROM python:3.10-alpine

RUN apk update

# Setting a default crontab for the service
COPY config/dev/cron.d/service-crontab /etc/cron.d/service-crontab

RUN chmod 0644 /etc/cron.d/service-crontab &&\
    crontab /etc/cron.d/service-crontab

# Fixing Python deps
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Adding the app itself
RUN mkdir /data
ADD app /app
WORKDIR /app
ENTRYPOINT ["sh", "-c" , "crond -f"]