#!/bin/bash
export VERSION=6.7.1
docker build . -t jtomasg/grafana:latest
docker tag jtomasg/grafana:latest jtomasg/grafana:${VERSION}
docker push jtomasg/grafana:${VERSION}
docker push jtomasg/grafana:latest
