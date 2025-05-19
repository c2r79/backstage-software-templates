#!/bin/bash
set -e

RELEASE_REPO="https://github.com/los-demos/dcipher-demo-releases.git"
APP_NAME="${{ values.app_name }}"
ENV="${{ values.app_env }}"

git config user.email "github-actions@los-demos.com"
git config user.name "GitHub Actions Bot"

git clone $RELEASE_REPO
cp app-template.yaml dcipher-demo-releases/apps/$APP_NAME/$ENV-$APP_NAME.yaml
sed -i "s/__APP_NAME__/${APP_NAME}/g" dcipher-demo-releases/apps/$APP_NAME/$ENV-$APP_NAME.yaml
git -C dcipher-demo-releases add apps/$APP_NAME/$ENV-$APP_NAME.yaml
git -C dcipher-demo-releases commit -m "Add ${APP_NAME} to ${ENV}"
git -C dcipher-demo-releases push
