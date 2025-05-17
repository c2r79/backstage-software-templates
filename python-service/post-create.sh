RELEASE_REPO="git@github.com:los-demos/dcipher-demo-releases.git"
APP_NAME="${{ values.app_name }}"
ENV="${{ values.app_env }}"

git clone $RELEASE_REPO
cp template/app-template.yaml dcipher-demo-releases/apps/$APP_NAME/$ENV-$APP_NAME.yaml
sed -i "s/__APP_NAME__/${APP_NAME}/g" dcipher-demo-releases/apps/$APP_NAME/$ENV-$APP_NAME.yaml
git -C dcipher-demo-releases add apps/$APP_NAME/$ENV-$APP_NAME.yaml
git -C dcipher-demo-releases commit -m "Add ${APP_NAME} to ${ENV}"
git -C dcipher-demo-releases push
