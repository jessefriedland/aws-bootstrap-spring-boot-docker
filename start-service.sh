#!/bin/bash -xe
source /home/ec2-user/.bash_profile
cd /home/ec2-user/app/release
java -jar aws-boostrap-spring-boot-docker-0.0.1-SNAPSHOT.jar &
echo $! > ./pid.file
#docker run --publish=8080:8080 aws-bootstrap-spring-boot-docker &