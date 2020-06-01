#!/bin/bash -xe
source /home/ec2-user/.bash_profile
[ -d "/home/ec2-user/app/release" ] && \
cd /home/ec2-user/app/release && \
kill $(cat ./pid.file)
#docker stop aws-bootstrap-spring-boot-docker
