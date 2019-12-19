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

Getting help
------------

- Report a bug or request a feature on [GitHub](https://github.com/libero/libero/issues/new/choose).
- Ask a question on the [Libero Community Slack](https://libero-community.slack.com/).
- Read the [code of conduct](https://libero.pub/code-of-conduct).
