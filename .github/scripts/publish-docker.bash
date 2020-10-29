#!/bin/bash

# A script to decide what version to upload

# Set current repository variable
REPOSITORY=paveloom-j/PDFHighlights.jl

# Get last published version
LAST_VERSION=$(curl --silent "https://api.github.com/repos/$REPOSITORY/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Check if there is some tag
if [ ! -z "$LAST_VERSION" ]; then

     # Get current tag
     CURRENT_TAG=$(echo ${GITHUB_REF#refs/*/})

     # Print info
     echo -e "\n\e[1;36mLast version: $LAST_VERSION\e[0m"
     echo -e "\e[1;36mCurrent tag:  $CURRENT_TAG\e[0m\n"

     # Check if the tag is a semantic version
     if echo "$CURRENT_TAG" | grep -E "^v[0-9]+\.[0-9]+\.[0-9]+$"; then

          # Print information
          echo -e "\e[1;36mCurrent tag is a semantic version. Tagged image will be published.\e[0m\n"

          # Set environment variable
          echo "RELEASE_VERSION=$(echo ${CURRENT_TAG} | sed 's/v//')" >> $GITHUB_ENV

          # Publish tagged image
          echo "PUBLISH_RELEASE_VERSION=true" >> $GITHUB_ENV

     else

          # Print information
          echo -e "\e[1;36mCurrent tag is not a semantic version. Tagged image will not be published.\e[0m\n"

          # Don't publish tagged image
          echo "PUBLISH_RELEASE_VERSION=false" >> $GITHUB_ENV

     fi

else

     # Print information
     echo -e "\n\e[1;36mNo release has been found, tagged version will not be published.\e[0m\n"

     # Don't publish tagged image
     echo "PUBLISH_RELEASE_VERSION=false" >> $GITHUB_ENV

fi