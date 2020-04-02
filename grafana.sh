#!/bin/bash
oc new-project grafana --display-name="Monitoring - Grafana Dashboards"
oc new-app -f grafana.yaml --param VOLUME_CAPACITY=4Gi --param IMAGE_GRAFANA=jtomasg/grafana:6.7.1
