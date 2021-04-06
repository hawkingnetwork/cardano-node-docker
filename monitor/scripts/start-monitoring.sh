#!/bin/bash
WEB_PORT=${WEB_PORT:-'9090'}
sed -i '' -e "s/127.0.0.1:12798/cardano-node:12798/g"  /cardano/config/prometheus.yml
node_exporter &
sleep 3
prometheus --config.file=/cardano/config/prometheus.yml --web.listen-address=:${WEB_PORT}