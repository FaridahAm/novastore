pipeline {
  agent any
  options { timestamps() }
  environment {
    SITE_DIR   = 'site'
    BUILD_DIR  = 'build'
    DEPLOY_DIR = '/var/www/site'
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Validate') {
      steps {
        sh '''
          set -euo 
          echo "No linters configured yet; skipping."
        '''
      }
    }
    stage('Package') {
      steps {
        sh '''
          set -euo 
          rm -rf "${BUILD_DIR}"
          mkdir -p "${BUILD_DIR}"
          cp -r "${SITE_DIR}/." "${BUILD_DIR}/"
        '''
        archiveArtifacts artifacts: "${BUILD_DIR}/**", fingerprint: true
      }
    }
    stage('Deploy to Nginx') {
      steps {
        sh '''
          set -euo 
          mkdir -p "${DEPLOY_DIR}"
          rm -rf "${DEPLOY_DIR:?}/"*
          cp -r "${BUILD_DIR}/." "${DEPLOY_DIR}/"
        '''
      }
    }
  }
  post {
    success {
      echo 'Deployed. Open http://localhost:8081'
    }
  }
}