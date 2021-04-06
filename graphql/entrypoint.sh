#!/bin/sh

export METADATA_SERVER_URI=${METADATA_SERVER_URI-:"https://tokens.cardano.org"}
export NETWORK=${NETWORK:-testnet}
export HASURA_GRAPHQL_ENABLE_TELEMETRY=${HASURA_GRAPHQL_ENABLE_TELEMETRY:-false}
export HASURA_URI=${HASURA_URI:-"http://hasura:8080"}
export GENESIS_FILE_BYRON=/configs/${NETWORK}/${NETWORK}-byron-genesis.json
export GENESIS_FILE_SHELLEY=/configs/${NETWORK}/${NETWORK}-shelley-genesis.json
export CARDANO_NODE_CONFIG_PATH=/configs/${NETWORK}/${NETWORK}-config.json

node index.js