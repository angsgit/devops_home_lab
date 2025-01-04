*********************************************************************************************************
#  TL;DR: 

# DevOps Home Lab 
Objective: Build a DevOps-focused environment for learning and practice.

## Flow Summary
- **vCenter Server**
  - Manages → **ESXi Host**
    - Runs → **Control VM**
      - VM Hosts → **Docker**
        - Container CICD → **Jenkins**
          - Container IaC → **Ansible**
            - Triggered by webhooks from → **GitHub**
              - Triggers pipelines to → **AWS S3**/**Dev**/**Prod**
                - Jenkins deploys to AWS S3 for application storage or configuration updates



## Key Components:

vCenter Server & ESXi Host: Manage virtual machines.
Control Machine (Ubuntu): Centralized automation node.
Jenkins in Docker: CI/CD pipelines.
GitHub: Version control and Jenkins integration.

Next Goals:

✔️ Deploy Kubernetes for container orchestration.

Progress:

✅ vCenter Server and ESXi Host deployed.
✅ Control machine (Ubuntu) operational.
✅ Jenkins linked to GitHub.
✅ Docker setup for containers running jenkins/ansible.
✅ Pipelines and deployments in progress.
❌ Deploy kubernetes for container orchestration.

*********************************************************************************************************

# LONG;

# Home Lab Setup

This repository documents the components and configuration of my home lab environment.

## Overview

The home lab is designed for DevOps practice and includes:
- **vCenter Server**: For virtual machine management.
- **ESXi Host**: Running multiple virtual machines.
- **Control Machine**: Ubuntu Server for automation tasks.
- **Jenkins**: Running in a Docker container for CI/CD pipelines.
- **GitHub**: For version control and pipeline integration.

## Components

- **vCenter Server**: Manages virtualized environments.
- **ESXi Host**: Hosts virtual machines for various purposes.
- **Ubuntu Control Machine**: Serves as the main automation node.
- **Jenkins**: Manages pipelines and automation tasks in the CI/CD lifecycle.
- **Ansible**: Manages new infrastructure deployments ie:VM's
- **Docker**: All tools like jenkins ansible etc running in containers on control machine.
- **GitHub Repositories**: Stores code and integrates with Jenkins for builds.
- **Synology NAS**: For webhosting etc

## Security
- All secrets stored in github secrets / jenkins credential managers / ansible vaults and so on.
- No hardcoded secrets anywhere, i hope! :)
- All webpages protected by Lets Encrypt SSL Certificates.

## Goals
- Deploy a full DevOps lifecycle in the home lab.
- Practice automation and CI/CD workflows.
- Learn and experiment with infrastructure as code tools.
- Learn/ practice containers(docker) and orchestration (kubernetes)

## Current Progress
- [x] Set up vCenter Server and ESXi Host.
- [x] Created control VM with Ubuntu Server.
- [x] Installed Jenkins and linked to GitHub.
- [x] Deploy pipelines for automated builds and deployments.
- [x] Deploy Jenkins in containers.
- [x] Deploy Ansible in containers.
- [x] Deploy infra with Ansible.
- [x] Integrate Jenkins with Synology NAS to deploy webpages

## Future Steps
1. Configure additional virtual machines for staging and production environments.
2. Set up infrastructure as code with Terraform and Ansible.
3. Automate application deployments using Jenkins pipelines.
4. Deploy more containers and orchestrate them using Kubernetes
