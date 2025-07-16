
# Variables
$GITHUB_USERNAME = "vedantchimote"
$REPO_NAME = "bigleap-helm-chart"
$CHART_DIR = "./bigleap"  # Changed from "./charts/bigleap" to "./bigleap"
$REPO_URL = "https://$GITHUB_USERNAME.github.io/$REPO_NAME"
$TEMP_DIR = "./temp-helm-repo"

# Create temporary directory
Write-Host "Creating temporary directory..."
if (-not (Test-Path $TEMP_DIR)) {
    New-Item -ItemType Directory -Path $TEMP_DIR | Out-Null
}

# Package the chart
Write-Host "Packaging Helm chart..."
helm package $CHART_DIR -d $TEMP_DIR

# Create or update the Helm repository index
Write-Host "Creating Helm repository index..."
helm repo index $TEMP_DIR --url $REPO_URL

# Clone the GitHub repository or create if it doesn't exist
Write-Host "Cloning GitHub repository..."
if (Test-Path "$TEMP_DIR/repo") {
    Remove-Item -Recurse -Force "$TEMP_DIR/repo"
}

try {
    git clone "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git" "$TEMP_DIR/repo"
} catch {
    Write-Host "Repository not found, creating new repository structure..."
    New-Item -ItemType Directory -Path "$TEMP_DIR/repo" | Out-Null
    Set-Location "$TEMP_DIR/repo"
    git init
    git remote add origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
    Set-Location -Path "../.."
}

# Copy files to the repository
Write-Host "Copying files to repository..."
Copy-Item "$TEMP_DIR/*.tgz" "$TEMP_DIR/repo/" -Force
Copy-Item "$TEMP_DIR/index.yaml" "$TEMP_DIR/repo/" -Force

# Copy README and artifacthub-repo.yml if they exist
if (Test-Path "$CHART_DIR/README.md") {
    Copy-Item "$CHART_DIR/README.md" "$TEMP_DIR/repo/" -Force
} else {
    Write-Host "No README.md found in chart directory, using root README if available"
    if (Test-Path "./README.md") {
        Copy-Item "./README.md" "$TEMP_DIR/repo/" -Force
    } else {
        Write-Host "No README.md found"
    }
}

if (Test-Path "$CHART_DIR/artifacthub-repo.yml") {
    Copy-Item "$CHART_DIR/artifacthub-repo.yml" "$TEMP_DIR/repo/" -Force
} else {
    Write-Host "No artifacthub-repo.yml found"
}

# Commit and push changes
Write-Host "Committing and pushing changes..."
Set-Location "$TEMP_DIR/repo"
git add .
git commit -m "Update Helm chart"

try {
    git push origin main
} catch {
    try {
        git push origin master
    } catch {
        Write-Host "Failed to push to main or master branch. Please check your repository settings."
        exit 1
    }
}

# Return to original directory
Set-Location -Path "../.."

Write-Host "Done! Your Helm chart has been published to GitHub."
Write-Host "Make sure GitHub Pages is enabled for your repository."
Write-Host "Your chart will be available at: $REPO_URL"