#!/bin/bash

# Variables
GITHUB_USERNAME="vedantchimote"
REPO_NAME="bigleap-helm-chart"
CHART_DIR="./charts/bigleap"
REPO_URL="https://$GITHUB_USERNAME.github.io/$REPO_NAME"
TEMP_DIR="./temp-helm-repo"

# Create temporary directory
mkdir -p $TEMP_DIR

# Package the chart
echo "Packaging Helm chart..."
helm package $CHART_DIR -d $TEMP_DIR

# Create or update the Helm repository index
echo "Creating Helm repository index..."
helm repo index $TEMP_DIR --url $REPO_URL

# Clone the GitHub repository
echo "Cloning GitHub repository..."
git clone https://github.com/$GITHUB_USERNAME/$REPO_NAME.git $TEMP_DIR/repo || (
  mkdir -p $TEMP_DIR/repo
  cd $TEMP_DIR/repo
  git init
  git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
  cd -
)

# Copy files to the repository
echo "Copying files to repository..."
cp $TEMP_DIR/*.tgz $TEMP_DIR/repo/
cp $TEMP_DIR/index.yaml $TEMP_DIR/repo/
cp $CHART_DIR/README.md $TEMP_DIR/repo/ 2>/dev/null || echo "No README.md found"
cp $CHART_DIR/artifacthub-repo.yml $TEMP_DIR/repo/ 2>/dev/null || echo "No artifacthub-repo.yml found"

# Commit and push changes
echo "Committing and pushing changes..."
cd $TEMP_DIR/repo
git add .
git commit -m "Update Helm chart"
git push origin main || git push origin master

echo "Done! Your Helm chart has been published to GitHub."
echo "Make sure GitHub Pages is enabled for your repository."
echo "Your chart will be available at: $REPO_URL"