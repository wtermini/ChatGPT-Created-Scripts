#!/bin/bash

# Get a list of all repository names
repositories=$(aws ecr describe-repositories --query 'repositories[*].repositoryName' --output text)

# Loop through the repository names
while read -r repository_name; do
  # Get a list of images for the current repository
  images=$(aws ecr describe-images --repository-name "$repository_name" --query 'imageDetails[*].{imageDigest: imageDigest, imageTags: imageTags[0]}')

  # Loop through the images
  while read -r image; do
    image_digest=$(echo $image | jq -r '.imageDigest')
    image_tag=$(echo $image | jq -r '.imageTags')
    image_arn="arn:aws:ecr:$(aws configure get region):$(aws sts get-caller-identity --query 'Account' --output text):repository/$repository_name:$image_tag@$image_digest"
    echo "$repository_name, $image_tag, $image_arn"
  done <<< "$images"
done <<< "$repositories"
