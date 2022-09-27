#!/bin/bash

set -e

echo "Setting environment variables..."
export TOR_ADDRESS=$(yq e '.tor-address' /lndhub-data/start9/config.yaml)
export REDIS_PASS="password"
export PORT="3000"
export TOR_URL="$TOR_ADDRESS"
export LND_CERT_FILE="/mnt/lnd/tls.cert"
export LND_ADMIN_MACAROON_FILE="/mnt/lnd/admin.macaroon"
export CONFIG='{ "redis": { "port": 6379, "host": "localhost", "family": 4, "password": "password", "db": 0 }, "lnd": { "url": "lnd.embassy:10009", "password": ""}}'
cp $LND_CERT_FILE /lndhub/ && cp $LND_ADMIN_MACAROON_FILE /lndhub/ 

echo "Starting Redis server..."
redis-server --requirepass $REDIS_PASS &

echo 'Starting lndhub...'
exec tini npm start 
