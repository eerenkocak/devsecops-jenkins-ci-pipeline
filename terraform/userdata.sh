#!/bin/bash
set -euo pipefail

# System update & resolve curl-minimal conflict on Amazon Linux 2023
dnf update -y
dnf install -y git wget jq docker --allowerasing
systemctl enable --now docker

# Install Jenkins & Java 21 (Required by modern Jenkins LTS)
JENKINS_REPO="pkg.jenkins.io/redhat-stable"
wget -O /etc/yum.repos.d/jenkins.repo "https://${JENKINS_REPO}/jenkins.repo"
rpm --import "https://${JENKINS_REPO}/jenkins.io-2023.key"
dnf install -y java-21-amazon-corretto jenkins

# Grant Jenkins user Docker execution privileges
usermod -aG docker jenkins
systemctl enable --now jenkins

# Pre-pull official Trivy container image for DevSecOps CVE scanning
docker pull aquasec/trivy:latest
systemctl restart jenkins
