pipeline {
  agent any
  
  options {
    timestamps()
    timeout(time: 30, unit: 'MINUTES')
  }

  environment {
    BUILD_DIR = 'dist'
    NODE_VERSION = '18'
  }

  stages {
    stage('Checkout') {
      steps {
        echo 'Checking out code...'
        checkout scm
      }
    }

    stage('Setup Node.js') {
      steps {
        echo 'Checking Node.js and npm versions...'
        script {
          if (isUnix()) {
            sh 'node --version'
            sh 'npm --version'
          } else {
            bat 'node --version'
            bat 'npm --version'
          }
        }
      }
    }

    stage('Install Dependencies') {
      steps {
        echo 'Installing dependencies...'
        script {
          if (isUnix()) {
            sh 'npm ci'
          } else {
            bat 'npm ci'
          }
        }
      }
    }

    stage('Lint & Test') {
      parallel {
        stage('Lint Code') {
          steps {
            echo 'Running ESLint...'
            script {
              if (isUnix()) {
                sh 'npm run lint'
              } else {
                bat 'npm run lint'
              }
            }
          }
        }
      }
    }

    stage('Build React App') {
      steps {
        echo 'Building React application...'
        script {
          if (isUnix()) {
            sh 'npm run build'
          } else {
            bat 'npm run build'
          }
        }
        archiveArtifacts artifacts: "${BUILD_DIR}/**/*", allowEmptyArchive: false, fingerprint: true
      }
    }

    stage('Deploy') {
      when {
        anyOf {
          branch 'main'
          branch 'master'
        }
      }
      steps {
        echo 'Preparing deployment artifacts...'
        script {
          if (isUnix()) {
            sh '''
              echo "🚀 Deploying NovaStore React App..."
              ls -la ${BUILD_DIR}/
              echo "Build artifacts ready for deployment"
            '''
          } else {
            bat '''
              echo "🚀 Deploying NovaStore React App..."
              dir %BUILD_DIR%
              echo "Build artifacts ready for deployment"
            '''
          }
        }
      }
    }
  }

  post {
    always {
      echo 'Cleaning up workspace...'
      cleanWs()
    }
    
    success {
      echo '✅ NovaStore React app built successfully!'
      echo '🎉 Build completed without errors'
      echo '📦 Artifacts archived and ready for deployment'
    }
    
    failure {
      echo '❌ Build failed!'
      echo '🔍 Check the logs above for error details'
    }
    
    unstable {
      echo '⚠️ Build completed with warnings'
    }
  }
}
