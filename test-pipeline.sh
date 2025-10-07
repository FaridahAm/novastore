#!/bin/bash
# Jenkins Pipeline Test Script
# This script mimics what Jenkins will do

echo "🧪 Testing Jenkins Pipeline Steps Locally"
echo "=========================================="

# Check Node.js and npm versions
echo "📋 Checking Node.js and npm versions..."
node --version
npm --version

# Install dependencies
echo "📦 Installing dependencies..."
npm ci

# Run linting
echo "🔍 Running ESLint..."
npm run lint

# Build the application
echo "🏗️ Building React application..."
npm run build

# Check if build directory exists
if [ -d "dist" ]; then
    echo "✅ Build successful! Output directory 'dist' exists."
    echo "📂 Build contents:"
    ls -la dist/
else
    echo "❌ Build failed! Output directory 'dist' not found."
    exit 1
fi

echo "🎉 All pipeline steps completed successfully!"
echo "📦 Your NovaStore app is ready for deployment!"