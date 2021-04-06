#!/bin/sh

HOSTADDR=${HOSTADDR:-'0.0.0.0'}
NETWORK=${NETWORK:-'mainnet'}
BASE_DIR=/cardano
CONFIG_DIR=${BASE_DIR}/configs/${NETWORK}
CNODE_DB_PATH=${BASE_DIR}/db
CNODE_SOCKET_PATH=${BASE_DIR}/socket/node.socket
CNODE_TOPOLOGY=${CONFIG_DIR}/${NETWORK}-topology.json
CNODE_CONFIG=${CONFIG_DIR}/${NETWORK}-config.json
CNODE_PORT=${CNODE_PORT:-'3000'}
KES=${CONFIG_DIR}/kes.skey
VRF=${CONFIG_DIR}/vrf.skey
CERT=${CONFIG_DIR}/node.cert

_term() {
  echo "Stopping Cardano Producer Node ..."
  kill -INT $PID
}

trap _term TERM INT

echo "Starting Cardano Producer Node ..."
cardano-node run --topology ${CNODE_TOPOLOGY} --database-path ${CNODE_DB_PATH} --socket-path ${CNODE_SOCKET_PATH} --host-addr ${HOSTADDR} --port ${CNODE_PORT} --config ${CNODE_CONFIG} --shelley-kes-key ${KES} --shelley-vrf-key ${VRF} --shelley-operational-certificate ${CERT} +RTS -N4 -RTS &

PID=$!
wait $PID
trap - TERM INT
wait $PID
EXIT_STATUS=$?

echo "Exit Status: ${EXIT_STATUS}"