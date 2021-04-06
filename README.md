<p align="center">
  <big><strong>Cardano GraphQL</strong></big>
</p>

## Build and Run via Docker Compose

1. Build Images

```console
bash build.sh
```

2. Run docker

```console
docker-compose up -d && docker-compose logs -f
```

### Check Cardano DB sync progress

Use the GraphQL Playground in the browser at http://localhost:3100/graphql:

```graphql
{
  cardanoDbMeta {
    initialized
    syncPercentage
  }
}
```

or via command line:

```console
curl \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"query": "{ cardanoDbMeta { initialized syncPercentage }}"}' \
  http://localhost:3100/graphql
```

:information_source: Wait for `initialized` to be `true` to ensure the epoch dataset is complete.

### Query the full dataset

```graphql
{
  cardano {
    tip {
      number
      slotNo
      epoch {
        number
      }
    }
  }
}
```

```console
curl \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"query": "{ cardano { tip { number slotNo epoch { number } } } }"}' http://localhost:3100/graphql
```

### :tada:

```json
{
  "data": {
    "cardano": {
      "tip": {
        "number": 4391749,
        "slotNo": 4393973,
        "epoch": { "number": 203 }
      }
    }
  }
}
```

For more information, have a look at the [Wiki :book:](https://github.com/input-output-hk/cardano-graphql/wiki).

## Documentation

| Link                                                                                        | Audience                                                     |
| ------------------------------------------------------------------------------------------- | ------------------------------------------------------------ |
| [API Documentation](https://input-output-hk.github.io/cardano-graphql)                      | Users of the Cardano GraphQL API                             |
| [Wiki](https://github.com/input-output-hk/cardano-graphql/wiki)                             | Anyone interested in the project and our development process |
| [Example Queries - Cardano DB Hasura](./packages/api-cardano-db-hasura/src/example_queries) | Users of the Cardano DB Hasura API                           |

<hr/>

<p align="center">
  <a href="https://github.com/input-output-hk/cardano-graphql/blob/master/LICENSE"><img src="https://img.shields.io/github/license/input-output-hk/cardano-graphql.svg?style=for-the-badge" /></a>
</p>
