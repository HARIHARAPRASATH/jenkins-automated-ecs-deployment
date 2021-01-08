#!/usr/bin/env groovy

node {
  def last_commit= sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()

  stage 'Checkout'
  git 'git 'https://github.com/HARIHARAPRASATH/jenkins-automated-ecs-deployment.git''
 
  stage 'Docker build'
  docker.build('demo')

  stage 'Docker push'
  sh("eval \$(aws ecr get-login --no-include-email --region ap-south-1)"){
    docker.image('demo').push("${last_commit}")
  }
  
  stage('Deploy') {
      // Override image field in taskdef file
      sh "sed -i 's|{{image}}|${docker_repo_uri}:${last_commit}|' taskdef.json"
      // sh "docker push ${docker_repo_uri}:"
      // Create a new task definition revision
      sh "aws ecs register-task-definition --execution-role-arn arn:aws:iam::853219876644:role/Jenkins --cli-input-json file://taskdef.json --region ${region}"
      // Update service on Fargate
      sh "aws ecs update-service --cluster ${cluster} --service v1-WebServer-Service --task-definition ${task_def_arn} --region ${region}"
  }
}
