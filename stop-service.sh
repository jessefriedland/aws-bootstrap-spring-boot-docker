#!/bin/bash -xe
source /home/ec2-user/.bash_profile
pid_file_name=pid.file
[ -d "/home/ec2-user/app/release" ] && \
cd /home/ec2-user/app/release && \
[ -f "$pid_file_name" ] && kill $(cat ./$pid_file_name)
#docker stop aws-bootstrap-spring-boot-docker
