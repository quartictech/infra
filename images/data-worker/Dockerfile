FROM ubuntu:latest
MAINTAINER Alex Sparrow "alex@quartic.io"

RUN apt-get update && apt-get install -y osm2pgsql postgis unzip python3 python3-pip python-pip git libffi-dev libpq-dev zip catdoc
RUN pip3 install xlsx2csv
COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt
