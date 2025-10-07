# Jenkins Setup Instructions for NovaStore

## Issue Resolution: Node.js Not Found

The Jenkins build was failing because Node.js wasn't installed on the Jenkins agent. Here are the solutions:

## Solution 1: Docker-based Pipeline (Recommended) ✅

The current `Jenkinsfile` uses a Docker-based approach that automatically provides Node.js 18 in an Alpine Linux container. This is the most reliable solution.

### Requirements:
- Jenkins with Docker support
- Docker installed on Jenkins agent
- Docker Pipeline plugin

### Benefits:
- ✅ Consistent Node.js environment
- ✅ No manual Node.js installation needed
- ✅ Isolated build environment
- ✅ Faster builds with caching

## Solution 2: Install Node.js on Jenkins Agent

If Docker isn't available, install Node.js directly on your Jenkins agent:

### For Linux (Ubuntu/Debian):
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### For Linux (CentOS/RHEL):
```bash
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs npm
```

### For Windows:
1. Download Node.js 18+ from https://nodejs.org/
2. Install using the MSI installer
3. Restart Jenkins service

## Solution 3: Jenkins NodeJS Plugin

1. Install the "NodeJS Plugin" in Jenkins
2. Go to Manage Jenkins → Global Tool Configuration
3. Add NodeJS installation:
   - Name: `NodeJS-18`
   - Version: `Node.js 18.x.x`
4. Use the alternative `Jenkinsfile.nodejs` (if provided)

## Current Pipeline Features

The Docker-based pipeline includes:

- 🔧 **Automatic Node.js 18 setup**
- 📦 **Dependency installation with caching**
- 🔍 **Code linting with ESLint**
- 🏗️ **Production build generation**
- 📊 **Build size reporting**
- 📁 **Artifact archiving**
- 🚀 **Deployment preparation**
- 🧹 **Automatic cleanup**

## Troubleshooting

### If Docker is not available:
```error
ERROR: docker: not found
```
**Solution**: Install Docker on Jenkins agent or use Solution 2/3 above.

### If Node.js version conflicts:
```error
Node.js version not supported
```
**Solution**: The pipeline uses Node.js 18, which supports all modern React features.

### Build still fails:
1. Check Jenkins logs for specific error messages
2. Verify Docker is running: `docker --version`
3. Test locally: `npm run build`
4. Check network connectivity for npm registry

## Files in this Project

- `Jenkinsfile` - Main Docker-based pipeline
- `Jenkinsfile.docker` - Alternative Docker pipeline
- `.jenkinsignore` - Files to exclude from Jenkins builds
- `test-pipeline.bat` - Windows testing script
- `test-pipeline.sh` - Linux testing script

## Expected Build Output

A successful build will:
1. ✅ Checkout code from GitHub
2. ✅ Setup Node.js 18 environment  
3. ✅ Install npm dependencies
4. ✅ Run ESLint code quality checks
5. ✅ Build React app to `dist/` folder
6. ✅ Archive build artifacts
7. ✅ Prepare for deployment

**Total build time**: ~2-3 minutes for typical React app

## Next Steps

After successful build:
1. Deploy `dist/` folder to web server
2. Configure web server (Nginx/Apache) for React SPA
3. Set up production environment variables
4. Configure domain and SSL certificates

---

🚀 **NovaStore is ready for production deployment!**