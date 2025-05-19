#!/bin/bash
set -e

APP_NAME="${{ values.app_name }}"
ENV="${{ values.app_env }}"

git clone $RELEASE_REPO

cd "$REPO_NAME"
git config user.email "github-actions@los-demos.com"
git config user.name "GitHub Actions Bot"
cd ..

mkdir -p "$REPO_NAME/apps/${APP_NAME}"
cp app-template.yaml $REPO_NAME/apps/$APP_NAME/$ENV-$APP_NAME.yaml
sed -i "s/__APP_NAME__/${APP_NAME}/g" $REPO_NAME/apps/$APP_NAME/$ENV-$APP_NAME.yaml
git -C $REPO_NAME add apps/$APP_NAME/$ENV-$APP_NAME.yaml
git -C $REPO_NAME commit -m "Add ArgoCD release for ${APP_NAME}:${ENV}:${COMMIT_ID}"
git -C $REPO_NAME push
