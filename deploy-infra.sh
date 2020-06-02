#!/bin/bash

STACK_NAME=spring-boot-docker
REGION=us-east-1
CLI_PROFILE=default

EC2_INSTANCE_TYPE=t2.micro

AWS_ACCOUNT_ID=`aws sts get-caller-identity \
        --profile $CLI_PROFILE \
        --query "Account" --output text`
CODEPIPELINE_BUCKET="$STACK_NAME-$REGION-codepipeline-$AWS_ACCOUNT_ID"

DB_INSTANCE_ID=springbootdocker
DB_NAME=springbootdocker
DB_USER=user
DB_PASSWORD=password

GH_ACCESS_TOKEN=$(cat ~/.github/aws-bootstrap-spring-boot-docker/access-token)
GH_OWNER=$(cat ~/.github/jessefriedland-owner)
GH_REPO=$(cat ~/.github/aws-bootstrap-spring-boot-docker/repo)
GH_BRANCH=master

# Deploys static resources
echo -e "\n\n=========== Deploying setup.yml ==========="
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME-setup \
  --template-file setup.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    CodePipelineBucket=$CODEPIPELINE_BUCKET \

# Deploy the CloudFormation template
echo -e "\n\n=========== Deploying main.yml ==========="
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME \
  --template-file main.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    EC2InstanceType=$EC2_INSTANCE_TYPE \
    GitHubOwner=$GH_OWNER \
    GitHubRepo=$GH_REPO \
    GitHubBranch=$GH_BRANCH \
    GitHubPersonalAccessToken=$GH_ACCESS_TOKEN \
    CodePipelineBucket=$CODEPIPELINE_BUCKET \
    DBInstanceID=$DB_INSTANCE_ID \
    DBName=$DB_NAME \
    DBUser=$DB_USER \
    DBPassword=$DB_PASSWORD \

# If the deploy succeeded, show the DNS name of the created instance
if [ $? -eq 0 ]; then
  aws cloudformation list-exports \
    --profile $CLI_PROFILE \
    --query "Exports[?ends_with(Name,'LBEndpoint')].Value"
  aws cloudformation list-exports \
    --profile $CLI_PROFILE \
    --query "Exports[?Name=='JDBCConnectionString'].Value"
fi
