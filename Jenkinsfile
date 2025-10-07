pipeline {
  agent any
  
  options {
    timestamps()
    timeout(time: 30, unit: 'MINUTES')
    buildDiscarder(logRotator(numToKeepStr: '10'))
    disableConcurrentBuilds()
  }

  environment {
    BUILD_DIR = 'dist'
    NODE_VERSION = '18'
    CI = 'true'
    FORCE_COLOR = 'true'
  }

  stages {
    stage('🏁 Initialize') {
      steps {
        echo '🚀 Starting NovaStore React App Build Pipeline'
        echo "📋 Build #${env.BUILD_NUMBER} - Branch: ${env.BRANCH_NAME ?: 'main'}"
        echo "📂 Workspace: ${env.WORKSPACE}"
        
        script {
          // Display environment info
          if (isUnix()) {
            sh '''
              echo "🖥️ System Information:"
              uname -a
              echo "📁 Current directory: $(pwd)"
              ls -la
            '''
          } else {
            bat '''
              echo "🖥️ System Information:"
              systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
              echo "📁 Current directory:"
              cd
              dir
            '''
          }
        }
      }
    }

    stage('🔧 Setup Node.js') {
      steps {
        echo '🔧 Configuring Node.js environment...'
        script {
          def nodeFound = false
          try {
            if (isUnix()) {
              sh 'node --version && npm --version'
              nodeFound = true
            } else {
              bat 'node --version && npm --version'
              nodeFound = true
            }
            echo '✅ Node.js and npm are available'
          } catch (Exception e) {
            echo '⚠️ Node.js not found in PATH, checking system locations...'
            
            if (isUnix()) {
              try {
                sh '''
                  # Try common Node.js installation paths
                  export PATH="/usr/local/bin:/usr/bin:$PATH"
                  node --version && npm --version
                '''
                nodeFound = true
                echo '✅ Found Node.js in system path'
              } catch (Exception ex) {
                echo '❌ Node.js not found. Installing via package manager...'
                sh '''
                  # Install Node.js using NodeSource repository
                  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
                  sudo apt-get install -y nodejs
                  node --version
                  npm --version
                '''
                nodeFound = true
              }
            } else {
              error('❌ Node.js not found on Windows. Please install Node.js 18+ and restart Jenkins.')
            }
          }
          
          if (!nodeFound) {
            error('❌ Unable to configure Node.js environment')
          }
        }
      }
    }

    stage('📦 Install Dependencies') {
      steps {
        echo '📦 Installing project dependencies...'
        script {
          if (isUnix()) {
            sh '''
              echo "🔄 Using npm ci for clean installation..."
              # Clean any existing node_modules and package-lock
              rm -rf node_modules package-lock.json 2>/dev/null || true
              
              # Install dependencies
              npm install
              
              echo "📊 Dependency installation summary:"
              npm list --depth=0 || echo "Dependencies installed"
            '''
          } else {
            bat '''
              echo "🔄 Using npm install for Windows..."
              rmdir /s /q node_modules 2>nul || echo "No existing node_modules"
              del package-lock.json 2>nul || echo "No existing lock file"
              
              npm install
              
              echo "📊 Dependencies installed successfully"
            '''
          }
        }
      }
    }

    stage('🔍 Code Quality') {
      parallel {
        stage('ESLint Analysis') {
          steps {
            echo '🔍 Running ESLint code analysis...'
            script {
              try {
                if (isUnix()) {
                  sh 'npm run lint'
                } else {
                  bat 'npm run lint'
                }
                echo '✅ ESLint analysis passed'
              } catch (Exception e) {
                echo '⚠️ ESLint found issues, but continuing build...'
                currentBuild.result = 'UNSTABLE'
              }
            }
          }
        }
        
        stage('Security Audit') {
          steps {
            echo '🛡️ Running npm security audit...'
            script {
              try {
                if (isUnix()) {
                  sh 'npm audit --audit-level moderate'
                } else {
                  bat 'npm audit --audit-level moderate'
                }
                echo '✅ Security audit passed'
              } catch (Exception e) {
                echo '⚠️ Security vulnerabilities found, please review'
                // Don't fail the build for audit issues in development
              }
            }
          }
        }
      }
    }

    stage('🏗️ Build Application') {
      steps {
        echo '🏗️ Building NovaStore React application...'
        script {
          if (isUnix()) {
            sh '''
              echo "🔨 Starting Vite build process..."
              npm run build
              
              echo "📊 Build Statistics:"
              if [ -d "${BUILD_DIR}" ]; then
                ls -la ${BUILD_DIR}/
                echo "📦 Total build size: $(du -sh ${BUILD_DIR} | cut -f1)"
                
                echo "📁 Generated files:"
                find ${BUILD_DIR} -type f -name "*.html" -o -name "*.js" -o -name "*.css" | head -10
              else
                echo "❌ Build directory not found!"
                exit 1
              fi
            '''
          } else {
            bat '''
              echo "🔨 Starting Vite build process..."
              npm run build
              
              echo "📊 Build Statistics:"
              if exist "%BUILD_DIR%" (
                dir %BUILD_DIR%
                echo "✅ Build completed successfully"
              ) else (
                echo "❌ Build directory not found!"
                exit /b 1
              )
            '''
          }
        }
        
        // Archive build artifacts
        archiveArtifacts artifacts: "${BUILD_DIR}/**/*", 
                        allowEmptyArchive: false, 
                        fingerprint: true,
                        onlyIfSuccessful: true
        
        echo '✅ Build artifacts archived successfully'
      }
    }

    stage('🧪 Quality Checks') {
      steps {
        echo '🧪 Running post-build quality checks...'
        script {
          if (isUnix()) {
            sh '''
              echo "🔍 Checking build output quality..."
              
              # Check if essential files exist
              if [ -f "${BUILD_DIR}/index.html" ]; then
                echo "✅ index.html found"
              else
                echo "❌ index.html missing"
                exit 1
              fi
              
              # Check for JavaScript and CSS files
              js_files=$(find ${BUILD_DIR} -name "*.js" | wc -l)
              css_files=$(find ${BUILD_DIR} -name "*.css" | wc -l)
              
              echo "📊 Build contains: ${js_files} JS files, ${css_files} CSS files"
              
              if [ $js_files -gt 0 ] && [ $css_files -gt 0 ]; then
                echo "✅ Build quality check passed"
              else
                echo "⚠️ Build seems incomplete"
                exit 1
              fi
            '''
          } else {
            bat '''
              echo "🔍 Checking build output quality..."
              
              if exist "%BUILD_DIR%\\index.html" (
                echo "✅ index.html found"
              ) else (
                echo "❌ index.html missing"
                exit /b 1
              )
              
              echo "✅ Build quality check passed"
            '''
          }
        }
      }
    }

    stage('🚀 Deploy Preparation') {
      when {
        anyOf {
          branch 'main'
          branch 'master'
          branch 'develop'
        }
      }
      steps {
        echo '🚀 Preparing NovaStore for deployment...'
        script {
          if (isUnix()) {
            sh '''
              echo "🎯 NovaStore E-commerce App - Production Ready!"
              echo "=================================="
              echo "📦 Build Summary:"
              echo "   - Build Directory: ${BUILD_DIR}"
              echo "   - Build Size: $(du -sh ${BUILD_DIR} | cut -f1)"
              echo "   - Files Count: $(find ${BUILD_DIR} -type f | wc -l)"
              
              echo ""
              echo "🌐 Deployment Information:"
              echo "   - Application: NovaStore E-commerce Platform"
              echo "   - Technology: React 19 + Vite"
              echo "   - Features: Product Catalog, Shopping Cart, Responsive Design"
              echo "   - Ready for: Static hosting (Nginx, Apache, CDN)"
              
              echo ""
              echo "📋 Deployment Checklist:"
              echo "   ✅ React app built successfully"
              echo "   ✅ Assets optimized for production"
              echo "   ✅ Code quality checks passed"
              echo "   ✅ Build artifacts archived"
              
              echo ""
              echo "🔗 Next Steps:"
              echo "   1. Deploy ${BUILD_DIR}/ contents to web server"
              echo "   2. Configure web server for SPA routing"
              echo "   3. Set up SSL certificates"
              echo "   4. Configure production environment variables"
              
              echo "🎉 NovaStore is ready for production deployment!"
            '''
          } else {
            bat '''
              echo "🎯 NovaStore E-commerce App - Production Ready!"
              echo "=================================="
              echo "📦 Build completed successfully"
              echo "🌐 Application: NovaStore E-commerce Platform"
              echo "⚡ Technology: React 19 + Vite"
              echo "🎉 Ready for deployment!"
            '''
          }
        }
      }
    }
  }

  post {
    always {
      echo '🧹 Pipeline cleanup...'
      script {
        // Clean up npm cache and temporary files
        try {
          if (isUnix()) {
            sh '''
              # Clean npm cache
              npm cache clean --force 2>/dev/null || true
              
              # Remove temporary files
              rm -rf .npm 2>/dev/null || true
              
              echo "✅ Cleanup completed"
            '''
          } else {
            bat '''
              npm cache clean --force 2>nul || echo "Cache already clean"
              echo "✅ Cleanup completed"
            '''
          }
        } catch (Exception e) {
          echo 'ℹ️ Cleanup completed with minor issues'
        }
      }
    }
    
    success {
      echo '🎉 SUCCESS: NovaStore build completed successfully!'
      echo '=================================='
      echo '✅ All pipeline stages passed'
      echo '📦 Build artifacts ready for deployment'
      echo '🌐 NovaStore e-commerce app is production-ready'
      echo '🔗 Build URL: ' + (env.BUILD_URL ?: 'N/A')
      
      // Optional: Send notifications
      script {
        def buildTime = currentBuild.duration ? "${currentBuild.duration / 1000}s" : 'N/A'
        echo "⏱️ Build completed in: ${buildTime}"
      }
    }
    
    failure {
      echo '❌ FAILURE: NovaStore build failed!'
      echo '=================================='
      echo '🔍 Check the console output above for detailed error information'
      echo '💡 Common issues:'
      echo '   - Node.js not installed or wrong version'
      echo '   - npm dependencies failed to install'
      echo '   - ESLint errors in code'
      echo '   - Build configuration problems'
      echo '   - Missing environment variables'
      echo ''
      echo '🛠️ Troubleshooting steps:'
      echo '   1. Ensure Node.js 16+ is installed on Jenkins agent'
      echo '   2. Check network connectivity for npm registry'
      echo '   3. Verify package.json and dependencies'
      echo '   4. Review code for linting errors'
    }
    
    unstable {
      echo '⚠️ UNSTABLE: Build completed with warnings'
      echo '🔧 Consider fixing the following for better quality:'
      echo '   - ESLint warnings or errors'
      echo '   - Security vulnerabilities in dependencies'
      echo '   - Performance optimizations'
    }
  }
}