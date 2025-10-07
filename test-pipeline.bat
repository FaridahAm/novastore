@echo off
REM Jenkins Pipeline Test Script for Windows
REM This script mimics what Jenkins will do

echo 🧪 Testing Jenkins Pipeline Steps Locally
echo ==========================================

REM Check Node.js and npm versions
echo 📋 Checking Node.js and npm versions...
node --version
npm --version

REM Install dependencies
echo 📦 Installing dependencies...
npm ci

REM Run linting
echo 🔍 Running ESLint...
npm run lint

REM Build the application
echo 🏗️ Building React application...
npm run build

REM Check if build directory exists
if exist "dist" (
    echo ✅ Build successful! Output directory 'dist' exists.
    echo 📂 Build contents:
    dir dist
) else (
    echo ❌ Build failed! Output directory 'dist' not found.
    exit /b 1
)

echo 🎉 All pipeline steps completed successfully!
echo 📦 Your NovaStore app is ready for deployment!