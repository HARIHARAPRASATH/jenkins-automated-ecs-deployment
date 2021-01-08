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
stage('Deploy') {
      // Override image field in taskdef file
      sh "sed -i 's|{{image}}|${docker_repo_uri}:${last_commit}|' taskdef.json"
      // sh "docker push ${docker_repo_uri}:"
      // Create a new task definition revision
      sh "aws ecs register-task-definition --execution-role-arn arn:aws:iam::853219876644:role/Jenkins --cli-input-json file://taskdef.json --region ap-south-1"
      // Update service on Fargate
      sh "aws ecs update-service --cluster WebServer --service Docker-ecs-Service --task-definition arn:aws:iam::853219876644:role --region ap-south-1"
  }
}
}
