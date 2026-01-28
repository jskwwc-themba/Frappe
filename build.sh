#!/bin/bash
# =============================================================================
# Build Custom Frappe Image with All Apps
# =============================================================================
# This script builds a custom Docker image with all Frappe apps baked in.
# Run this on your server (not locally) where Docker is available.
#
# Usage:
#   chmod +x build.sh
#   ./build.sh
# =============================================================================

set -e

# Configuration
IMAGE_NAME="${IMAGE_NAME:-frappe-apps}"
IMAGE_TAG="${IMAGE_TAG:-v15}"
FULL_IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"

echo "========================================="
echo "Building Frappe Custom Image"
echo "Image: ${FULL_IMAGE}"
echo "========================================="

# Check if apps.json exists
if [ ! -f "apps.json" ]; then
    echo "ERROR: apps.json not found!"
    exit 1
fi

# Encode apps.json to base64
echo "Encoding apps.json..."
APPS_JSON_BASE64=$(base64 -w 0 apps.json)

# Build the image
echo "Building Docker image..."
echo "This will take 20-40 minutes depending on your server..."
echo ""

docker build \
    --file Containerfile \
    --build-arg APPS_JSON_BASE64="${APPS_JSON_BASE64}" \
    --build-arg FRAPPE_VERSION="v15" \
    --tag "${FULL_IMAGE}" \
    --progress=plain \
    .

echo ""
echo "========================================="
echo "BUILD COMPLETE!"
echo "========================================="
echo "Image: ${FULL_IMAGE}"
echo ""
echo "Next steps:"
echo "1. Update docker-compose.yml to use this image"
echo "2. Set CUSTOM_IMAGE=${IMAGE_NAME} and CUSTOM_TAG=${IMAGE_TAG}"
echo "3. Set PULL_POLICY=never (use local image)"
echo "4. Redeploy your stack"
echo "========================================="
