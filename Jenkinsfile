pipeline {
  agent any
  
  options {
    timestamps()
    timeout(time: 30, unit: 'MINUTES')
    skipDefaultCheckout false
  }

  environment {
    BUILD_DIR = 'dist'
    CI = 'true'
    npm_config_cache = 'npm-cache'
    NODE_OPTIONS = '--max-old-space-size=4096'
  }

  stages {
    stage('Checkout') {
      steps {
        echo '📥 Checking out code...'
        checkout scm
      }
    }

    stage('Setup Environment') {
      steps {
        echo '🔧 Setting up Node.js environment...'
        script {
          try {
            if (isUnix()) {
              sh '''
                echo "Node.js version: $(node --version)"
                echo "npm version: $(npm --version)"
                echo "Working directory: $(pwd)"
                ls -la
              '''
            } else {
              bat '''
                echo "Node.js version:"
                node --version
                echo "npm version:"
                npm --version
                echo "Working directory:"
                cd
                dir
              '''
            }
          } catch (Exception e) {
            echo "⚠️ Node.js not found in PATH. Attempting to use system installation..."
            if (isUnix()) {
              sh '''
                # Try to find Node.js in common locations
                if [ -f "/usr/bin/node" ]; then
                  export PATH="/usr/bin:$PATH"
                elif [ -f "/usr/local/bin/node" ]; then
                  export PATH="/usr/local/bin:$PATH"
                fi
                
                echo "Attempting to use system Node.js..."
                node --version || echo "Node.js still not found - please install Node.js 16+ on this Jenkins agent"
                npm --version || echo "npm not found - please install npm on this Jenkins agent"
              '''
            } else {
              error("Node.js not found. Please install Node.js 16+ on this Windows Jenkins agent and restart Jenkins.")
            }
          }
        }
      }
    }

    stage('Install Dependencies') {
      steps {
        echo '📦 Installing dependencies...'
        script {
          if (isUnix()) {
            sh '''
              # Create npm cache directory
              mkdir -p ${npm_config_cache}
              
              # Install dependencies (use npm install as fallback if npm ci fails)
              npm ci --cache ${npm_config_cache} || npm install --cache ${npm_config_cache}
              
              echo "✅ Dependencies installed successfully"
            '''
          } else {
            bat '''
              mkdir %npm_config_cache% 2>nul || echo "Cache directory already exists"
              
              npm ci --cache %npm_config_cache% || npm install --cache %npm_config_cache%
              
              echo "✅ Dependencies installed successfully"
            '''
          }
        }
      }
    }

    stage('Lint Code') {
      steps {
        echo '🔍 Running ESLint...'
        script {
          if (isUnix()) {
            sh 'npm run lint'
          } else {
            bat 'npm run lint'
          }
        }
      }
    }

    stage('Build React App') {
      steps {
        echo '🏗️ Building React application...'
        script {
          if (isUnix()) {
            sh '''
              npm run build
              echo "✅ Build completed successfully!"
              echo "📂 Build output:"
              ls -la ${BUILD_DIR}/
              echo "📊 Build size:"
              du -sh ${BUILD_DIR}/ || echo "Size calculation not available"
            '''
          } else {
            bat '''
              npm run build
              echo "✅ Build completed successfully!"
              echo "📂 Build output:"
              dir %BUILD_DIR%
              echo "📊 Build size calculation complete"
            '''
          }
        }
        
        // Archive the build artifacts
        archiveArtifacts artifacts: "${BUILD_DIR}/**/*", 
                        allowEmptyArchive: false, 
                        fingerprint: true,
                        onlyIfSuccessful: true
      }
    }

    stage('Deploy Preparation') {
      when {
        anyOf {
          branch 'main'
          branch 'master'
        }
      }
      steps {
        echo '🚀 Preparing deployment artifacts...'
        script {
          if (isUnix()) {
            sh '''
              echo "🎯 NovaStore React App - Production Build Ready!"
              echo "📦 Build directory contents:"
              ls -la ${BUILD_DIR}/
              echo "📁 Main files in build:"
              find ${BUILD_DIR} -name "*.html" -o -name "*.js" -o -name "*.css" | head -10 || echo "Files ready for deployment"
              echo "✨ Build artifacts are ready for deployment!"
            '''
          } else {
            bat '''
              echo "🎯 NovaStore React App - Production Build Ready!"
              echo "📦 Build directory contents:"
              dir %BUILD_DIR%
              echo "✨ Build artifacts are ready for deployment!"
            '''
          }
        }
      }
    }
  }

  post {
    always {
      echo '🧹 Cleaning up...'
      script {
        try {
          if (isUnix()) {
            sh '''
              # Clean npm cache if it exists
              rm -rf ${npm_config_cache} || echo "Cache already cleaned"
              echo "Cleanup completed"
            '''
          } else {
            bat '''
              rmdir /s /q %npm_config_cache% 2>nul || echo "Cache already cleaned"
              echo "Cleanup completed"
            '''
          }
        } catch (Exception e) {
          echo "Cleanup completed with minor issues (normal)"
        }
      }
    }
    
    success {
      echo '🎉 SUCCESS: NovaStore React app built successfully!'
      echo '✅ All stages completed without errors'
      echo '📦 Build artifacts have been archived'
      echo '🌐 Your NovaStore e-commerce app is ready for deployment!'
      
      // Send success notification (optional)
      script {
        def buildUrl = env.BUILD_URL ?: 'N/A'
        echo "🔗 Build details: ${buildUrl}"
      }
    }
    
    failure {
      echo '❌ FAILURE: Build failed!'
      echo '🔍 Please check the console output above for error details'
      echo '💡 Common issues: missing dependencies, linting errors, or build configuration problems'
    }
    
    unstable {
      echo '⚠️ UNSTABLE: Build completed with warnings'
      echo '🔧 Consider fixing the warnings for better code quality'
    }
  }
}
