Libero common scripts
=====================

[![Build Status](https://github.com/libero/scripts/workflows/CI/badge.svg?branch=master)](https://github.com/libero/scripts/actions?query=branch%3Amaster+workflow%3ACI)

These common scripts are used in Libero projects builds.

Getting started
---------------

To add to a repository, run:

```
git submodule add https://github.com/libero/scripts .scripts
```

and commit the result.

To initialize the submodule in a repository that uses it, run:

```
git submodule init
git submodule update
```

To update the copy of `scripts` used in a repository, run:

```
git submodule update --remote
```

and commit the result.


Developing
----------

If you add a shellscript consider using [bats](https://github.com/bats-core/bats-core) to add tests for it.

To run tests locally:

- install [shellcheck](https://github.com/koalaman/shellcheck#user-content-installing) (`apt/brew/yum install shellcheck`)

```sh
make setup
make test
make teardown
```

NOTE: some tests grep `docker images` output. If in doubt use `docker system prune --all` to ensure a clean test run.

Getting help
------------

- Report a bug or request a feature on [GitHub](https://github.com/libero/libero/issues/new/choose).
- Ask a question on the [Libero Community Slack](https://libero-community.slack.com/).
- Read the [code of conduct](https://libero.pub/code-of-conduct).
