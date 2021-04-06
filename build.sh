#!/bin/sh
NODE_VERSION=1.25.1
MONITOR_VERSION=1.0.0
HASURA_VERSION=4.0.0
GRAPHQL_VERSION=4.0.0

#build node
docker build ./node -t naviocean/cardano-node:${NODE_VERSION}
docker image tag naviocean/cardano-node:${NODE_VERSION} naviocean/cardano-node:latest

#build monitor
docker build ./monitor -t naviocean/cardano-monitor:${MONITOR_VERSION}
docker image tag naviocean/cardano-monitor:${MONITOR_VERSION} naviocean/cardano-monitor:latest

#build hasura
docker build ./hasura -t naviocean/cardano-graphql-hasura:${HASURA_VERSION}
docker image tag naviocean/cardano-graphql-hasura:${HASURA_VERSION} naviocean/cardano-graphql-hasura:latest

#build graphql
docker build ./graphql -t naviocean/cardano-graphql:${GRAPHQL_VERSION}
docker image tag naviocean/cardano-graphql:${GRAPHQL_VERSION} naviocean/cardano-graphql:latest
