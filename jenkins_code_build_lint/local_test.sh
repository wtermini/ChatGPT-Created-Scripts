#!/bin/bash

set -e

DOCKERFILE_LINTER="hadolint/hadolint:latest"
PYTHON_IMAGE="python:3.8-slim"
AWS_BUILD_SPEC_FILE="buildspec.yml"

echo "Linting Dockerfile..."
docker run --rm -i -v "$(pwd):/src" -w "/src" $DOCKERFILE_LINTER hadolint Dockerfile

echo "Linting buildspec.yml..."
docker run --rm -i -v "$(pwd):/src" -w "/src" $PYTHON_IMAGE /bin/sh -c \
  "pip3 install --no-cache-dir --user yamllint &&
  yamllint ${AWS_BUILD_SPEC_FILE}"

echo "Building Docker image..."
docker build -t my-image:local .

echo "All steps completed successfully."
