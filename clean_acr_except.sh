#!/bin/bash

# This script deletes images from an Azure Container Registry (ACR) except for the passed tag prefix.
# It takes two arguments:
#   1. The name of the ACR registry.
#   2. The prefix of the image tag prefixes not to be deleted.
#
# Usage:
#   ./script_name.sh registry_name tag_prefix tag_prefix
#
# Example:
#   ./script_name.sh youracrname dev123 prod

# Uncomment the following line to debug the script
# set -x

# The registry name is passed as the first argument to the script
registryName=$1
echo $registryName

shift

# List your repositories
repositories=('repo-1' 'repo-2' 'repo-n')

# Loop over repositories
for repositoryName in "${repositories[@]}"; do
  echo $repositoryName
  # Get all tags
  tags=$(az acr repository show-tags --name $registryName --repository $repositoryName --output tsv)
  # Loop over tags
  for tag in $tags; do
    # Check if tag does not start with any of the passed-in parameters
    match=0
    for arg in "$@"; do
      if [[ $tag == "$arg"* ]]; then
        match=1
        break
      fi
    done
    if [[ $match -eq 0 ]]; then
      echo "Deleting:"
      echo $repositoryName
      echo $tag
      clean_tag=$(echo $tag | tr -d '\r')
      # Delete the image with the tag
      az acr repository delete --name $registryName --image $repositoryName:$clean_tag --yes
    fi
  done
done
