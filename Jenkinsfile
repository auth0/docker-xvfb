pipeline {
  agent {
    label 'crew-brokkr'
  }

  options {
    buildDiscarder(logRotator(numToKeepStr:'5'))
    timeout(time: 30, unit: 'MINUTES')
  }

  parameters {
    string(name: 'NODE_VERSION', defaultValue: '4.8.4', description: 'NodeJS version to generate a new image')
  }

  stages {
    stage('Build') {
      steps {
        sh "docker build . -t auth0brokkr/node-xvfb:${params.NODE_VERSION} --build-arg NODE_VERSION=${params.NODE_VERSION}"
      }
    }

    stage('Push') {
      environment {
        DOCKER_USER = credentials('docker-hub-user')
        DOCKER_PASSWORD = credentials('docker-hub-password')
      }
      steps {
        sh "docker login -u ${env.DOCKER_USER} -p ${env.DOCKER_PASSWORD}"
        sh "docker push auth0brokkr/node-xvfb:${params.NODE_VERSION}"
      }
    }

    stage('Clean') {
      steps {
        sh "docker rmi auth0brokkr/node-xvfb:${params.NODE_VERSION}"
      }
    }
  }

  post {
    always {
      deleteDir()
    }
  }
}
