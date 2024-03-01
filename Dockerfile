FROM python:3.9-alpine3.13
# alpine is a lightweight version of linux
LABEL maintainer="londonappdeveloper.com"
# who will maintain the website

ENV PYTHONUNBUFFERED 1
# tells python not to buffer env 

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000
# copy requirements.txt from local copy to docker image "/tmp/requirements.txt" to have it avail in build phase
# where commands to be run from
# expose port 8000 to container

ARG DEV=false
# by default do not run in DEV mode
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # above is a shell script to run shell if statement
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user
# runs this commend on docker image
# remove tmp directory to keep it lightweight as possible
# add user to docker container for security purposes of not using root user

ENV PATH="/py/bin:$PATH"
# add this path to system path to specify where full path of virtual env

USER django-user
#user that we are switching to (instead of root user); containers made out of this image will use last user 