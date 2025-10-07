pipeline {
  agent {
    docker {
      image 'node:18-alpine'
      args '--user root'
    }
  }
  
  options {
    timestamps()
    timeout(time: 30, unit: 'MINUTES')
  }

  environment {
    BUILD_DIR = 'dist'
    CI = 'true'
    npm_config_cache = 'npm-cache'
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
        sh '''
          echo "Node.js version: $(node --version)"
          echo "npm version: $(npm --version)"
          echo "Working directory: $(pwd)"
          ls -la
        '''
      }
    }

    stage('Install Dependencies') {
      steps {
        echo '📦 Installing dependencies...'
        sh '''
          # Create npm cache directory
          mkdir -p ${npm_config_cache}
          
          # Install dependencies
          npm ci --cache ${npm_config_cache}
          
          echo "✅ Dependencies installed successfully"
        '''
      }
    }

    stage('Lint Code') {
      steps {
        echo '🔍 Running ESLint...'
        sh 'npm run lint'
      }
    }

    stage('Build React App') {
      steps {
        echo '🏗️ Building React application...'
        sh '''
          npm run build
          echo "✅ Build completed successfully!"
          echo "📂 Build output:"
          ls -la ${BUILD_DIR}/
          echo "📊 Build size:"
          du -sh ${BUILD_DIR}/
        '''
        
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
        sh '''
          echo "🎯 NovaStore React App - Production Build Ready!"
          echo "📦 Total build size: $(du -sh ${BUILD_DIR}/ | cut -f1)"
          echo "📁 Main files in build:"
          find ${BUILD_DIR} -name "*.html" -o -name "*.js" -o -name "*.css" | head -10
          echo "✨ Build artifacts are ready for deployment!"
        '''
      }
    }
  }

  post {
    always {
      echo '🧹 Cleaning up...'
      sh '''
        # Clean npm cache
        rm -rf ${npm_config_cache}
        echo "Cache cleaned"
      '''
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
