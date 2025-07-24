#!/bin/bash
yum update -y
yum install -y docker
systemctl enable docker
systemctl start docker
# Pull and run your app container (replace with your image)
# docker run -d -p 80:80 your-app-image