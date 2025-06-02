#!/bin/bash

echo "🚀 R3E Network Organization README Setup"
echo "========================================"

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo "Install it from: https://cli.github.com/"
    echo "Or follow the manual steps in SETUP.md"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Please authenticate with GitHub first:"
    echo "Run: gh auth login"
    exit 1
fi

echo "📝 Creating .github repository..."

# Create the .github repository
gh repo create r3e-network/.github --public --description "Organization profile and community health files"

if [ $? -eq 0 ]; then
    echo "✅ Repository created successfully"
else
    echo "⚠️  Repository might already exist, continuing..."
fi

echo "📁 Cloning repository..."
git clone https://github.com/r3e-network/.github.git temp-github-repo

cd temp-github-repo

echo "📄 Creating profile directory and README..."
mkdir -p profile

# Copy the README content
cp ../profile/README.md profile/README.md

echo "🔧 Committing changes..."
git add profile/README.md
git commit -m "Add organization README

- Add comprehensive organization profile
- Showcase R3E Labs mission and projects
- Include all 4 key projects with descriptions
- Add architecture overview and getting started guides"

echo "🚀 Pushing to GitHub..."
git push origin main

cd ..
rm -rf temp-github-repo

echo ""
echo "✅ Setup Complete!"
echo "🔗 Visit https://github.com/r3e-network to see your new organization README"
echo "⏰ It may take a few minutes for GitHub to display the changes"
echo ""
echo "🔍 Troubleshooting:"
echo "   - Ensure the .github repository is public"
echo "   - Check that profile/README.md exists in the repository"
echo "   - Wait up to 10 minutes for GitHub to process the changes" 