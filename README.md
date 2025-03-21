*********************************************************************************************************
#  TL;DR: 

# DevOps Home Lab 
Objective: Build a DevOps/DevSecOps-focused environment for learning and practice.

## Flow Summary
- **vCenter Server**
  - Manages → **ESXi Host**
    - Runs → **Control VM**
      - VM Hosts → **Docker**
        - Container CICD → **Jenkins**
          - Container IaC → **Ansible**
            - Triggered by webhooks from → **GitHub**
              - Triggers pipelines to → **AWS S3**/**Dev**/**Prod**
                - Jenkins deploys to AWS/Local NAS for application storage or configuration updates



## Key Components:

1. vCenter Server & ESXi Host →  Manage virtual machines.  
2. Control Machine (Ubuntu) →  Centralized automation node.  
3. Jenkins in Docker →  CI/CD pipelines.  
4. GitHub →  Version control and Jenkins integration.  

Next Goals:

✔️ Deploy Kubernetes for container orchestration.  

Progress:

✅ vCenter Server and ESXi Host deployed.  
✅ Control machine (Ubuntu) operational.  
✅ Jenkins linked to GitHub.  
✅ Docker setup for containers running jenkins/ansible.  
✅ Pipelines and deployments in progress.  
❌ Deploy Kubernetes for container orchestration.  

*********************************************************************************************************

# LONG;

# Home Lab Setup

This repository documents the components and configuration of my home lab environment for DevOps/DevSecOps.

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
- Also using VaultWarden running in a container on my NAS locally.
- No hardcoded secrets anywhere, i hope! :)
- All webpages protected by Lets Encrypt SSL Certificates.

## Goals
- Deploy a full DevOps lifecycle in the home lab.
- Practice automation and CI/CD workflows.
- Learn and experiment with infrastructure as code tools.
- Learn/ practice containers(docker) and orchestration (kubernetes)

## Current Progress
- ✅ Set up vCenter Server and ESXi Host.  
- ✅ Created control VM with Ubuntu Server.  
- ✅ Installed Jenkins and linked to GitHub.  
- ✅ Deploy pipelines for automated builds and deployments.  
- ✅ Deploy Jenkins in containers.  
- ✅ Deploy Ansible in containers.  
- ✅ Deploy infra with Ansible.  
- ✅ Integrate Jenkins with Synology NAS to deploy webpages.    

## Future Steps
✔️ Configure additional virtual machines for staging and production environments.  
✔️ Set up infrastructure as code with Terraform and Ansible.  
✔️ Automate application deployments using Jenkins pipelines.  
✔️ Deploy more containers and orchestrate them using Kubernetes  
