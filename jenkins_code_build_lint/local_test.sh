#!/bin/bash

set -e

DOCKERFILE_LINTER="hadolint/hadolint:latest"
AWS_LINTER="amazon/aws-cli:2.x"
AWS_BUILD_SPEC_FILE="buildspec.yml"
PIP_INDEX_URL=${PIP_INDEX_URL:-'https://pypi.org/simple'}
PIP_CERT_IGNORE=${PIP_CERT_IGNORE:-'false'}

echo "Linting Dockerfile..."
docker run --rm -i -v "$(pwd):/src" -w "/src" $DOCKERFILE_LINTER hadolint Dockerfile

echo "Linting buildspec.yml..."
pip_cert_option=""
if [ "$PIP_CERT_IGNORE" = "true" ]; then
  pip_cert_option="--trusted-host ${PIP_INDEX_URL}"
fi

docker run --rm -i -v "$(pwd):/src" -w "/src" $AWS_LINTER /bin/sh -c \
  "pip3 install --no-cache-dir --user ${pip_cert_option} -i ${PIP_INDEX_URL} aws-cdk.core aws-cdk.cx-api aws-cdk.aws-codebuild &&
  python3 -m aws_cdk.aws_codebuild._jsii.pythonlint -f ${AWS_BUILD_SPEC_FILE}"

echo "Building Docker image..."
docker build -t my-image:local .

echo "All steps completed successfully."
