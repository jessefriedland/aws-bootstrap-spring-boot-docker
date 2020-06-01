#!/bin/bash -xe

exec > /home/ec2-user/app/logs/startup.log 2>&1

source /home/ec2-user/.bash_profile
cd /home/ec2-user/app/release
java -jar target/aws-boostrap-spring-boot-docker-*.jar &
echo $! > ./pid.file
#docker run --publish=8080:8080 aws-bootstrap-spring-boot-docker &
