#!/usr/bin/bash

bash domismp-tests/domismp-docker/images/build-docker-images.sh

SOURCE_IMAGE="edeliverytest/domismp-tomcat-mysql"
IMAGE_ID=$(docker images --format "{{.Repository}} {{.Tag}} {{.ID}}" | grep "^$SOURCE_IMAGE " | sort -k3 -r | head -n1 | awk '{print $3}')

if [ -z "$IMAGE_ID" ]; then
    echo "Error: Could not find the built image for $SOURCE_IMAGE"
    exit 1
fi

VERSION_TAG=$(docker images --format "{{.Repository}} {{.Tag}} {{.ID}}" | grep "$IMAGE_ID" | awk '{print $2}')
echo "Built image: $SOURCE_IMAGE:$VERSION_TAG (ID: $IMAGE_ID)"

TARGET_IMAGE="rig14/harmony-smp-mysql:$VERSION_TAG"
docker tag "$SOURCE_IMAGE:$VERSION_TAG" "$TARGET_IMAGE"
echo "Tagged image as $TARGET_IMAGE"

docker login

docker push "$TARGET_IMAGE"

echo "Docker image $TARGET_IMAGE pushed successfully!"