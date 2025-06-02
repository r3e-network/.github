#!/bin/bash

# R3E Network Icon Conversion Script
# This script helps convert the provided logo images to favicon formats

echo "🎨 R3E Network Favicon Generator"
echo "================================"

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "❌ ImageMagick not found. Please install it first:"
    echo "   macOS: brew install imagemagick"
    echo "   Ubuntu: sudo apt-get install imagemagick"
    echo "   Windows: Download from https://imagemagick.org/"
    exit 1
fi

# Check if source image is provided
if [ $# -eq 0 ]; then
    echo "📝 Usage: ./convert-icons.sh <source-image>"
    echo "   Example: ./convert-icons.sh r3e-logo.png"
    echo ""
    echo "💡 Tip: Use the R3E Network logo for best results"
    echo "   Make sure the source image is high resolution (at least 512x512)"
    exit 1
fi

SOURCE_IMAGE="$1"

if [ ! -f "$SOURCE_IMAGE" ]; then
    echo "❌ Source image '$SOURCE_IMAGE' not found"
    exit 1
fi

echo "📁 Source image: $SOURCE_IMAGE"
echo "🔄 Converting to favicon formats..."

# Create favicon.ico (multi-size ICO file)
echo "   → favicon.ico"
convert "$SOURCE_IMAGE" -resize 16x16 -resize 32x32 -resize 48x48 favicon.ico

# Create PNG favicons
echo "   → favicon-16x16.png"
convert "$SOURCE_IMAGE" -resize 16x16 favicon-16x16.png

echo "   → favicon-32x32.png"
convert "$SOURCE_IMAGE" -resize 32x32 favicon-32x32.png

# Create Apple touch icon
echo "   → apple-touch-icon.png"
convert "$SOURCE_IMAGE" -resize 180x180 apple-touch-icon.png

# Create Android Chrome icons
echo "   → android-chrome-192x192.png"
convert "$SOURCE_IMAGE" -resize 192x192 android-chrome-192x192.png

echo "   → android-chrome-512x512.png"
convert "$SOURCE_IMAGE" -resize 512x512 android-chrome-512x512.png

echo ""
echo "✅ Favicon conversion complete!"
echo "📁 Generated files:"
ls -la *.ico *.png 2>/dev/null | grep -E '\.(ico|png)$' || echo "   No files generated (check for errors above)"

echo ""
echo "🚀 Next steps:"
echo "   1. Review the generated icons"
echo "   2. Test favicon.ico at small sizes (16x16)"
echo "   3. The website will automatically use these icons"
echo "   4. Commit the changes to git"

echo ""
echo "💡 Pro tip: For best results, use a square image with clear contrast"
echo "   The R3E geometric symbol works great at small sizes!" 