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
    stage('SharedLibs') {
      steps {
        library identifier: 'auth0-jenkins-pipelines-library@master', retriever: modernSCM(
          [$class: 'GitSCMSource',
          remote: 'git@github.com:auth0/auth0-jenkins-pipelines-library.git',
          credentialsId: 'auth0extensions-ssh-key'])
      }
    }
    stage('Build') {
      steps {
        script {
          def DOCKER_REGISTRY = getDockerRegistry()
          NODE_XVFB_DOCKER_IMAGE="${DOCKER_REGISTRY}/node-xvfb:${params.NODE_VERSION}"
          sh "docker build . --no-cache -t ${NODE_XVFB_DOCKER_IMAGE} --build-arg NODE_VERSION=${params.NODE_VERSION}"

          docker_image = docker.image("${NODE_XVFB_DOCKER_IMAGE}")
        }
      }
    }

    stage('Push') {
      steps {
        dockerPushArtifactory(docker_image.id)
      }
    }

    stage('Clean') {
      steps {
        dockerRemoveImage("${NODE_XVFB_DOCKER_IMAGE}")
      }
    }
  }

  post {
    always {
      deleteDir()
    }
  }
}
