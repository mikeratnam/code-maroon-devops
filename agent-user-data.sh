#!/bin/bash

set -e

LOG_FILE="/home/ec2-user/agent-versions.txt"

echo "===== AGENT-MAX BOOTSTRAP STARTED ====="

# --------------------------------------------------
# System update
# --------------------------------------------------
dnf update -y

# --------------------------------------------------
# Git
# --------------------------------------------------
dnf install -y git

# --------------------------------------------------
# Java
# --------------------------------------------------
dnf install -y java-21-amazon-corretto

# --------------------------------------------------
# Python + pip
# --------------------------------------------------
dnf install -y python3 python3-pip

# --------------------------------------------------
# Terraform
# --------------------------------------------------
dnf install -y yum-utils
yum-config-manager \
  --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

dnf install -y terraform

# --------------------------------------------------
# Docker
# --------------------------------------------------
dnf install -y docker

systemctl enable docker
systemctl start docker

usermod -aG docker ec2-user

# --------------------------------------------------
# Ansible
# --------------------------------------------------
dnf install -y ansible-core

# --------------------------------------------------
# Version verification
# --------------------------------------------------
cat > "$LOG_FILE" <<EOF
==================================================
        AGENT-MAX SOFTWARE VERSIONS
==================================================

Git:
$(git --version)

Java:
$(java --version 2>&1 | head -1)

Python:
$(python3 --version)

Pip:
$(pip3 --version)

Terraform:
$(terraform --version | head -1)

Docker:
$(docker --version)

Ansible:
$(ansible --version | head -1)

==================================================
        BOOTSTRAP COMPLETE
==================================================
EOF

# Give ec2-user ownership
chown ec2-user:ec2-user "$LOG_FILE"

# Display verification in cloud-init output
cat "$LOG_FILE"

echo "===== AGENT-MAX BOOTSTRAP FINISHED ====="