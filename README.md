# Terraform AWS Foundation IaC

## Overview
This project demonstrates a production-style Infrastructure as Code setup using Terraform on AWS.

## Features
- Remote state in S3
- State locking via use_lockfile = true
- Multi-environment structure (dev/prod)
- Reusable modules
- GitHub Actions CI/CD

## Architecture
- GitHub → CI/CD → Terraform → AWS
- S3 backend for state management

## Structure
- envs/: environment-specific configurations
- modules/: reusable infrastructure components

## Usage

cd envs/dev
terraform init
terraform plan
terraform apply

## Notes
- Do not commit tfstate or tfvars files
- Backend S3 bucket must exist before init
