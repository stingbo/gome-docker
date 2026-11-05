#!/bin/sh
set -eu

if [ -z "${GOME_CONFIG:-}" ]; then
    umask 077
    GOME_CONFIG=$(mktemp /tmp/gome-config.XXXXXX)
    export GOME_CONFIG
    jq -n \
        --arg grpc_host "${GOME_GRPC_HOST:-0.0.0.0}" \
        --arg mq_user "${RABBITMQ_DEFAULT_USER:?RabbitMQ username is required}" \
        --arg mq_password "${RABBITMQ_DEFAULT_PASS:?RabbitMQ password is required}" \
        '{
            grpc: {host: $grpc_host, port: "8088"},
            redis: {host: "redis", port: "6379"},
            rabbitmq: {host: "rabbitmq", port: "5672", username: $mq_user, password: $mq_password},
            gome: {accuracy: 8}
        }' > "$GOME_CONFIG"
fi

exec "$@"
