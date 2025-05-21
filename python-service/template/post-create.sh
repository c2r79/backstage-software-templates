#!/bin/bash
set -e

# === Validate required environment variables ===
if [[ -z "${APP_NAME}" || -z "${APP_ENV}" || -z "${RELEASE_TOKEN}" ]]; then
  echo "Missing required environment variables."
  echo "APP_NAME=${APP_NAME}"
  echo "APP_ENV=${APP_ENV}"
  echo "RELEASE_TOKEN=${RELEASE_TOKEN:0:4}****"
  exit 1
fi

REPO_NAME="dcipher-demo-releases"
RELEASE_REPO_URL="https://x-access-token:${RELEASE_TOKEN}@github.com/los-demos/${REPO_NAME}.git"

echo "Cloning ${REPO_NAME} using token..."
git clone "$RELEASE_REPO_URL" "$REPO_NAME"

# Set Git identity for the commit
cd "$REPO_NAME"
git config user.email "github-actions@los-demos.com"
git config user.name "GitHub Actions Bot"
cd ..

# Create target app directory if it doesn't exist
mkdir -p "$REPO_NAME/apps/${APP_NAME}"

# Copy and customize the ArgoCD app manifest
cp app-template.yaml "$REPO_NAME/apps/$APP_NAME/$APP_ENV-$APP_NAME.yaml"
sed -i "s/__APP_NAME__/${APP_NAME}/g" "$REPO_NAME/apps/$APP_NAME/$APP_ENV-$APP_NAME.yaml"

# Commit and push to release repo
cd "$REPO_NAME"
git add "apps/$APP_NAME/$APP_ENV-$APP_NAME.yaml"
git commit -m "Add ArgoCD release for ${APP_NAME}:${APP_ENV}:${COMMIT_ID}" || echo "Nothing to commit"
git push

# Optional: empty commit to trigger org secrets usage
git commit --allow-empty -m "Trigger org secrets availability"
git push

# #!/bin/bash
# set -e

# # Read values passed by GitHub Actions as environment variables
# APP_NAME="${APP_NAME}"
# ENV="${APP_ENV}"
# REPO_NAME="dcipher-demo-releases"

# # Clone the target release repo
# git clone "$RELEASE_REPO"

# # Set Git identity for the commit
# cd "$REPO_NAME"
# git config user.email "github-actions@los-demos.com"
# git config user.name "GitHub Actions Bot"
# cd ..

# # Create target app directory if it doesn't exist
# mkdir -p "$REPO_NAME/apps/${APP_NAME}"

# # Copy and customize the ArgoCD app manifest
# cp app-template.yaml "$REPO_NAME/apps/$APP_NAME/$ENV-$APP_NAME.yaml"
# sed -i "s/__APP_NAME__/${APP_NAME}/g" "$REPO_NAME/apps/$APP_NAME/$ENV-$APP_NAME.yaml"

# # Commit and push to release repo
# git -C "$REPO_NAME" add "apps/$APP_NAME/$ENV-$APP_NAME.yaml"
# git -C "$REPO_NAME" commit -m "Add ArgoCD release for ${APP_NAME}:${ENV}:${COMMIT_ID}"
# git -C "$REPO_NAME" push

# # Trigger follow-up workflow run with org secrets by forcing a no-op commit
# cd "$REPO_NAME"
# git commit --allow-empty -m "Trigger org secrets availability"
# git push