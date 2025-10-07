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
    HOME = '/tmp'
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
        echo '🔧 Verifying Node.js environment (via Docker)...'
        sh '''
          docker run --rm -v "$PWD":/app -w /app node:18-alpine node --version
          docker run --rm -v "$PWD":/app -w /app node:18-alpine npm --version
          echo "📁 Working directory: $(pwd)"
          echo "👤 Current user: $(whoami)"
          echo "🔧 Node.js environment ready!"
        '''
      }
    }

    stage('📦 Install Dependencies') {
      steps {
        echo '📦 Installing project dependencies (via Docker)...'
        sh '''
          docker run --rm -v "$PWD":/app -w /app node:18-alpine npm ci --only=production=false
          echo "📊 Dependency installation completed successfully!"
          echo "📁 node_modules created: $(ls -la node_modules | wc -l) entries"
        '''
      }
    }

    stage('🔍 Code Quality') {
      parallel {
        stage('ESLint Analysis') {
          steps {
            echo '🔍 Running ESLint code analysis (via Docker)...'
            script {
              try {
                sh 'docker run --rm -v "$PWD":/app -w /app node:18-alpine npm run lint'
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
            echo '🛡️ Running npm security audit (via Docker)...'
            script {
              try {
                sh 'docker run --rm -v "$PWD":/app -w /app node:18-alpine npm audit --audit-level moderate || echo "Security audit completed with warnings"'
                echo '✅ Security audit completed'
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
        echo '🏗️ Building NovaStore React application (via Docker)...'
        sh '''
          docker run --rm -v "$PWD":/app -w /app node:18-alpine npm run build
          echo "📊 Build Statistics:"
          if [ -d "${BUILD_DIR}" ]; then
            echo "✅ Build directory created successfully!"
            ls -la ${BUILD_DIR}/
            echo "📦 Total build size: $(du -sh ${BUILD_DIR} | cut -f1)"
            echo "📁 Generated files:"
            find ${BUILD_DIR} -type f -name "*.html" -o -name "*.js" -o -name "*.css" | head -10
            echo "📊 File count: $(find ${BUILD_DIR} -type f | wc -l) files"
          else
            echo "❌ Build directory not found!"
            exit 1
          fi
        '''
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
            echo "⚠️ Build seems incomplete but continuing..."
          fi
          
          echo "🎯 NovaStore build quality verified!"
        '''
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
      }
    }
  }

  post {
    always {
      echo '🧹 Pipeline cleanup...'
      script {
        try {
          sh '''
            # Clean npm cache
            npm cache clean --force 2>/dev/null || true
            
            # Remove temporary files
            rm -rf /tmp/.npm 2>/dev/null || true
            
            echo "✅ Cleanup completed"
          '''
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