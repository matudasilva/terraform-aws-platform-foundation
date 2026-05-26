# Backend configuration for prod environment
#
# This stack requires an S3 bucket to be created for state management.
# The backend bucket should be separate from dev, or use the same bucket with different key.
#
# Configuration is deferred: this file is a template for future prod enablement.
# To enable prod deployment, update the bucket and key values below and ensure
# the S3 bucket exists with proper encryption and versioning.
#
# Example:
# terraform {
#   backend "s3" {
#     bucket       = "tf-platform-foundation-state-prod-xxxxx"
#     key          = "envs/prod/foundation/terraform.tfstate"
#     region       = "us-east-1"
#     encrypt      = true
#     use_lockfile = true
#   }
# }
