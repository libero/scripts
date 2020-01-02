#!/bin/bash
set -e

# should do nothing on PR builds
GITHUB_REF=refs/pull/12/merge \
IMAGE_TAG=12345678 \
github/push-image.sh my-dummy-project
