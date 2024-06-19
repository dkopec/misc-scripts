#!/bin/bash

# This script deletes images from an Azure Container Registry (ACR) based on a given tag prefix.
# It takes two arguments:
#   1. The name of the ACR registry.
#   2. The prefix of the image tags to be deleted.
#
# Usage:
#   ./script_name.sh registry_name tag_prefix
#
# Example:
#   ./script_name.sh youracrname dev123
#
# Uncomment the following line to debug the script
# set -x

# The registry name is passed as the first argument to the script
registryName=$1

# Print the registry name
echo $registryName

# List of repositories in the registry
repositories=('repo-1' 'repo-2' 'repo-n')

# Loop over each repository
for repositoryName in "${repositories[@]}"; do
  # Get all tags in the repository
  tags=$(az acr repository show-tags --name $registryName --repository $repositoryName --output tsv)

  # Loop over each tag
  for tag in $tags; do

    # If the tag starts with the prefix passed as the second argument to the script
    if [[ $tag == "${2}"* ]]; then
      # Print the details of the image being deleted
      echo "Deleting:"
      echo $repositoryName
      echo $tag

      # Remove carriage return characters from the tag a know issue with az cli tsv output
      clean_tag=$(echo $tag | tr -d '\r')

      # Delete the image with the tag
      az acr repository delete --name $registryName --image $repositoryName:$clean_tag --yes
    fi
  done
done
