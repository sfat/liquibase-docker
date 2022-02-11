#!/bin/bash

export DOCKER_USER='sfat'
echo "Logging in Docker. Please enter your password below."
docker login -u "$DOCKER_USER"

docker_base_image="$DOCKER_USER/liquibase"

# take current LIQUIBASE_VERSION from Dockerfile
key_to_search=LIQUIBASE_VERSION

version=$(grep ${key_to_search} Dockerfile | head -n1 | cut -d'=' -f2)

echo "Building and Pushing Liquibase Docker images for version $version"

echo "Building Docker Buildx Starter"
export DOCKER_CLI_EXPERIMENTAL=enabled
docker buildx create --use

echo "Building and Pushing images"

docker buildx build -t "$docker_base_image:latest" -t "$docker_base_image:$version" \
   --platform linux/amd64,linux/arm64 --push .

echo "Built and Pushed Images successfully."
