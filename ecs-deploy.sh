#!/bin/bash
set -x
#Constants
PATH=$PATH:/usr/local/bin; export PATH
REGION=ap-south-1
REPOSITORY_NAME=demo
CLUSTER=flask-signup-cluster
FAMILY=`sed -n 's/.*"family": "\(.*\)",/\1/p' taskdef.json`
NAME=`sed -n 's/.*"name": "\(.*\)",/\1/p' taskdef.json`
SERVICE_NAME=${NAME}-service
#DESIRED_COUNT="1"
env
aws configure list
echo $HOME
#Store the repositoryUri as a variable
REPOSITORY_URI=`aws ecr describe-repositories --repository-names ${REPOSITORY_NAME} --region ${REGION} | jq .repositories[].repositoryUri | tr -d '"'`
#Replace the build number and respository URI placeholders with the constants above
sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" -e "s;%REPOSITORY_URI%;${REPOSITORY_URI};g" taskdef.json > ${NAME}-v_${BUILD_NUMBER}.json
#Register the task definition in the repository
aws ecs register-task-definition --family ${FAMILY} --cli-input-json file:///root/.jenkins/workspace/Node_js/${NAME}-v_${BUILD_NUMBER}.json --region ${REGION}
#Get latest revision
#REVISION=`aws ecs describe-task-definition --task-definition v1-taskDefintion | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
REVISION=`aws ecs describe-task-definition --task-definition v1-taskDefintion | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//' | cut -d ","  -f 1`
#FAILURECHECK
#SERVICES=`aws ecs describe-services  --service ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq.failures[]`
#DESIRED COUNT CHECK
#DESIRED_COUNT=`aws ecs describe-services  --service ${SERVICE_NAME} --cluster ${CLUSTER} --region REGION | jq .services[].desiredCount`
#Create and update service
#if["SERVICES"=="];then
echo"entering to existing service"
#DESIRED COUNT CHECK
DESIRED_COUNT=`aws ecs describe-services  --service ${SERVICE_NAME} --cluster ${CLUSTER} --region ${REGION} | jq .services[].desiredCount`
#aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${FAMILY}:${REVISION} --desired-count ${DESIRED_COUNT}
aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --force-new-deployment --task-definition ${FAMILY}:${REVISION} --desired-count ${DESIRED_COUNT}
