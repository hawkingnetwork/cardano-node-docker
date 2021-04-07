#!/bin/sh

echo "CARDANO_NETWORK=${CARDANO_NETWORK:-testnet}" > .env
echo "GRAPHQL_API_HOST=${GRAPHQL_API_HOST:-cardano-graphql}" >> .env
echo "GRAPHQL_API_PATH=${GRAPHQL_API_PATH:-graphql}" >> .env
echo "GRAPHQL_API_PORT=${GRAPHQL_API_PORT:-3100}" >> .env
echo "GRAPHQL_API_PROTOCOL=${GRAPHQL_API_PROTOCOL:-http}" >> .env

yarn --offline && yarn static:build

yarn static:serve -p ${PORT:-4000}