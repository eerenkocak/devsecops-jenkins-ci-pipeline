#!/bin/bash
set -euo pipefail

dnf update -y
dnf install -y git wget jq docker --allowerasing
systemctl enable --now docker

# Install Jenkins & Java 21
JENKINS_REPO="pkg.jenkins.io/redhat-stable"
wget -O /etc/yum.repos.d/jenkins.repo "https://${JENKINS_REPO}/jenkins.repo"
rpm --import "https://${JENKINS_REPO}/jenkins.io-2023.key"
dnf install -y java-21-amazon-corretto jenkins
usermod -aG docker jenkins
systemctl enable --now jenkins

# Pre-pull official Trivy container image for DevSecOps scanning
docker pull aquasec/trivy:latest
systemctl restart jenkins
