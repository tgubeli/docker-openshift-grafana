FROM docker.io/centos:7
LABEL maintainer="Tomás Gübeli <jtomasg@gmail.com>"
ARG GRAFANA_VERSION=6.7.1

LABEL name="Grafana" \
      io.k8s.display-name="Grafana" \
      io.k8s.description="Grafana Dashboard" \
      io.openshift.expose-services="3000" \
      io.openshift.tags="grafana" \
      build-date="2020-03-20" \
      version=$GRAFANA_VERSION \
      release="1"

# User grafana gets added by RPM
ENV USERNAME=grafana

RUN yum -y update && yum -y upgrade && \
    yum -y install epel-release && \
    yum -y install git unzip nss_wrapper && \
    curl -L -o /tmp/grafana.rpm https://dl.grafana.com/oss/release/grafana-$GRAFANA_VERSION-1.x86_64.rpm && \
    yum -y localinstall /tmp/grafana.rpm && \
    yum -y clean all && \
    rm -rf /var/cache/yum \
    rm /tmp/grafana.rpm

COPY ./root /
RUN /usr/bin/fix-permissions /var/log/grafana && \
    /usr/bin/fix-permissions /etc/grafana && \
    /usr/bin/fix-permissions /usr/share/grafana && \
    /usr/bin/fix-permissions /usr/sbin/grafana-server

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

# Plugins
RUN curl -L -o /tmp/grafana-worldmap-panel.zip https://grafana.com/api/plugins/grafana-worldmap-panel/versions/0.2.1/download && \
    unzip /tmp/grafana-worldmap-panel.zip -d /var/lib/grafana/plugins && \
    curl -L -o /tmp/simPod-grafana-json-datasource-v0.1.7-0.zip https://grafana.com/api/plugins/simpod-json-datasource/versions/0.1.7/download && \
    unzip /tmp/simPod-grafana-json-datasource-v0.1.7-0.zip -d /var/lib/grafana/plugins && \
    rm /tmp/simPod-grafana-json-datasource-v0.1.7-0.zip && \
    rm /tmp/grafana-worldmap-panel.zip

EXPOSE 3000

ENTRYPOINT ["/usr/bin/rungrafana"]
