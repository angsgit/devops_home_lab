*********************************************************************************************************
#  TL;DR: 

# DevOps Home Lab 
Objective: Build a DevOps-focused environment for learning and practice.

## Flow Summary
vCenter Server manages ESXi Host >>> ESXi Host runs the Control VM >>> The Control VM runs Docker, which hosts Jenkins >>> GitHub triggers Jenkins pipelines via webhooks >>> Jenkins deploys to AWS S3 for application storage or configuration updates.

Key Components:

vCenter Server & ESXi Host: Manage virtual machines.
Control Machine (Ubuntu): Centralized automation node.
Jenkins in Docker: CI/CD pipelines.
GitHub: Version control and Jenkins integration.
Progress:

✅ vCenter Server and ESXi Host deployed.
✅ Control machine (Ubuntu) operational.
✅ Jenkins linked to GitHub.
⬜ Pipelines and deployments in progress.

Next Goals:

Add staging and production VMs.
Configure Terraform/Ansible for automation.
Complete Jenkins pipelines for deployment.

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
- **GitHub Repositories**: Stores code and integrates with Jenkins for builds.

## Secrets
- All secrets stored in github and jenkins credential managers for security
- No hardcoded secrets anywhere :)

## Goals
- Deploy a full DevOps lifecycle in the home lab.
- Practice automation and CI/CD workflows.
- Learn and experiment with infrastructure as code tools.

## Current Progress
- [x] Set up vCenter Server and ESXi Host.
- [x] Created control VM with Ubuntu Server.
- [x] Installed Jenkins and linked to GitHub.
- [x] Deploy pipelines for automated builds and deployments.

## Future Steps
1. Configure additional virtual machines for staging and production environments.
2. Set up infrastructure as code with Terraform and Ansible.
3. Automate application deployments using Jenkins pipelines.
