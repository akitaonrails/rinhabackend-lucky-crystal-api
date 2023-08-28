# rinhabackend_crystal

This is a project written using [Lucky](https://luckyframework.org), with the language Crystal.

The goal was to fulfill the requirements of the ["Rinha Backend - API Challenge"](https://github.com/zanfranceschi/rinha-de-backend-2023-q3/blob/main/INSTRUCOES.md).

The idea was to create a very simple set of API endpoints and run against a Gatling scenario stress-test, as per the instructions above.

You can use the "docker-compose.yml" provided to spin up the environment with the resource restrictions from the challenge and run the Gatling script against it.

### Setting up the project

1. [Install required dependencies](https://luckyframework.org/guides/getting-started/installing#install-required-dependencies)
1. Update database settings in `config/database.cr`
1. Run `script/setup`
1. Run `lucky dev` to start the app

### Using Docker for development

1. [Install Docker](https://docs.docker.com/engine/install/)
1. Run `docker compose up -f dev-docker-compose.yml`

The Docker container will boot all of the necessary components needed to run your Lucky application.
To configure the container, update the `docker-compose.yml` file, and the `docker/development.dockerfile` file.


### Learning Lucky

Lucky uses the [Crystal](https://crystal-lang.org) programming language. You can learn about Lucky from the [Lucky Guides](https://luckyframework.org/guides/getting-started/why-lucky).
