# Overview

Docker image to wait on HTTP based services to be up and running before other docker services may come up.

## Example

A web server requires another service to be running before it may run. We would like to run e2e tests against the web server, but only after it and the other service have successfully started.

### `docker-compose.yml`

```yml
version: '3'

services:
  start-dependencies:
    image: andrewcodes/wait-for
    depends_on:
      - some-http-service1
      - another-http-service
    environment:
      SLEEP_LENGTH: 10
      TIMEOUT_LENGTH: 600
    command: "http://localhost:8080 http://localhost"

  some-http-service1:
    image: #...
    ports:
        - 80:80

  another-http-service:
    image: #...
    ports:
        - 8080:8080

  e2e-tests:
    image: cypress/base:10
    command: npx cypress run
```

```shell
docker-compose run --rm start-dependencies
# Will wait until both `http:localhost:8080` and `http://localhost` respond with a non 000 HTTP status code.
docker-compose up e2e-tests
docker-compose down
```
