#!/bin/bash

echo "Repository,Image,Tag,ARN"

for repo in $(aws ecr describe-repositories --query 'repositories[].repositoryName' --output text); do
    images=$(aws ecr describe-images --repository-name $repo --query 'sort_by(imageDetails,& imagePushedAt)[].{Image:imageTags, Tag:imageDigest, ARN:registryId}')
    for image in $(echo "${images}" | jq -r '.[] | @base64'); do
        _jq() {
            echo ${image} | base64 --decode | jq -r ${1}
        }
        echo "${repo},$(_jq '.Image'),$(_jq '.Tag'),$(_jq '.ARN')"
    done
done
