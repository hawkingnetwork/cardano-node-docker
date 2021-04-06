FROM hasura/graphql-engine:v1.3.3.cli-migrations-v2 as base

FROM python:3.7-slim-stretch

RUN apt-get -y update \
    && apt-get install -y --no-install-recommends libpq-dev jq \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/doc/ \
    && rm -rf /usr/share/man/ \
    && rm -rf /usr/share/locale/

# copy hausra binary from base container
COPY --from=base /bin/graphql-engine /bin/graphql-engine

COPY entrypoint.sh /entrypoint.sh

ENV \
  POSTGRES_HOST=postgres \
  POSTGRES_PORT=5432 \
  POSTGRES_DB_FILE=/run/secrets/postgres_db \
  POSTGRES_PASSWORD_FILE=/run/secrets/postgres_password \
  POSTGRES_USER_FILE=/run/secrets/postgres_user \
  HASURA_GRAPHQL_ENABLED_LOG_TYPES="startup, http-log, webhook-log, websocket-log" \
  HASURA_GRAPHQL_ENABLE_TELEMETRY=false

RUN chmod +x /entrypoint.sh
EXPOSE 8080

CMD ["/entrypoint.sh"]



