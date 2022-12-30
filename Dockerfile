FROM python:3.10-alpine

# Installing a blank crontab for the user 'root' in the service
RUN touch /etc/crontabs/root
# Setting permissions to make the file writable only by the owner
RUN chmod 0644 /etc/crontabs/root

# Fixing Python deps
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Adding the app itself
RUN mkdir /data
ADD app /app
WORKDIR /app
ENTRYPOINT ["sh", "-c" , "crond -f"]
