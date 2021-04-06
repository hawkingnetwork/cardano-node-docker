FROM debian:stable-slim
LABEL name="cardano-monitor"
LABEL maintainer="https://github.com/hawkingnetwork"

ARG PROMETHEUS_VERSION=2.26.0
ARG NODE_EX_VERSION=1.1.2

# Install base utilities and dependencies
RUN apt-get update
RUN apt-get install -y wget telnet

RUN mkdir -p /cardano/scripts
WORKDIR /cardano

# prometheus
RUN wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
RUN mkdir prometheus
RUN tar zxC prometheus -f prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz --strip-components 1
RUN rm prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

# node_exporter
RUN wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EX_VERSION}/node_exporter-${NODE_EX_VERSION}.linux-amd64.tar.gz
RUN mkdir node_exporter
RUN tar zxC node_exporter -f node_exporter-${NODE_EX_VERSION}.linux-amd64.tar.gz --strip-components 1
RUN rm node_exporter-${NODE_EX_VERSION}.linux-amd64.tar.gz

# Install start script
COPY scripts/start-monitoring.sh /cardano/scripts/start-monitoring.sh
RUN chmod 544 /cardano/scripts/start-monitoring.sh

# Add Prometheus configuration, can be overridden using a 'bind mount' volume
COPY scripts/prometheus.yml /cardano/config/prometheus.yml

# Creating non root user cardano
RUN useradd -m cardano

# Add data store folder
RUN mkdir /cardano/data

# Add permissions
RUN chown -R cardano:cardano /cardano
RUN chmod g+s /cardano

# Export executable path
ENV PATH=/cardano/prometheus:/cardano/node_exporter:/cardano/scripts:$PATH

# Image clean-up
RUN apt-get purge -y wget
RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get autoclean

USER cardano:cardano

EXPOSE 9100

CMD ["start-monitoring.sh"]