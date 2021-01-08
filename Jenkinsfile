#!/usr/bin/env groovy

node {
  //def last_commit= sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()

  stage 'Checkout'
  
  git 'https://github.com/HARIHARAPRASATH/jenkins-automated-ecs-deployment.git'
  stage 'Docker build'
  docker.build('demo')

  stage 'Docker push'
  sh("eval \$(aws ecr get-login --no-include-email --region ap-south-1)")
  //docker.withRegistry('https://634677623658.dkr.ecr.ap-south-1.amazonaws.com', 'ecr.ap-south-1:demo-ecr-credentials') {
    //docker.image('demo').push('latest')
    sh 'docker tag demo:latest 634677623658.dkr.ecr.ap-south-1.amazonaws.com/demo:latest'
    sh 'docker push 634677623658.dkr.ecr.ap-south-1.amazonaws.com/demo:latest'
    }   
  
      stage('Deploy') {
      sh "deploy"
  }


