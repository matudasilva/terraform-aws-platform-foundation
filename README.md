# Terraform AWS Foundation IaC

## Overview
This project demonstrates a production-style Infrastructure as Code setup using Terraform on AWS.

## Requirements
- Terraform CLI >= 1.10.0

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

cd envs/dev/foundation
terraform init
terraform plan
terraform apply

## Notes
- Do not commit tfstate or tfvars files
- Backend S3 bucket must exist before init
- Local `terraform init` against `envs/dev/foundation` requires Terraform 1.10+ because the S3 backend uses `use_lockfile = true`.
- GitHub OIDC baseline for CI v1.2 requires a bootstrap run outside CI to create the initial OIDC provider + IAM role.
- After bootstrap, set repository variable `AWS_ROLE_ARN` with the Terraform output `github_actions_role_arn`.
