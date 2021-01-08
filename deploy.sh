#!/bin/bash
SERVICE_NAME="Docker-ecs" 
IMAGE_VERSION="v_"${BUILD_NUMBER}"
TASK_FAMILY="v1-taskDefintion"
DESIRED_COUNT="1"

# Create a new task definition for this build
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" taskdef.json > v1-taskDefintion-v_${BUILD_NUMBER}.json
aws ecs register-task-definition --family v1-taskDefintion --region ap-south-1 --cli-input-json file://v1-taskDefintion-v_${BUILD_NUMBER}.json

# Update the service with the new task definition and desired count
TASK_REVISION=`aws ecs describe-task-definition --task-definition v1-taskDefintion --region ap-south-1 | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME} --region ap-south-1 | egrep "desiredCount" | tr "/" " " | awk '{print $2}' | sed 's/,$//'`
#if [ ${DESIRED_COUNT} = "0" ]; then
 #   DESIRED_COUNT="1"
#fi

aws ecs update-service --cluster WebServer  --service Docker-ecs --task-definition  ${TASK_FAMILY}:${TASK_REVISION} --region ap-south-1 --desired-count ${DESIRED_COUNT}
