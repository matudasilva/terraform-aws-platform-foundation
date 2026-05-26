# S3 Bucket Module

## Purpose

Reusable Terraform module to create AWS S3 buckets with standard tagging and encryption. Provides a minimal, focused abstraction for S3 bucket provisioning across environments.

## Inputs

- `bucket_name` (string, required): The name of the S3 bucket. Must be globally unique across AWS.
- `tags` (map(string), optional): Map of tags to apply to the bucket. Defaults to empty map; consumers should pass tags from parent stack.

## Outputs

- `bucket_name` (string): The name of the created S3 bucket.
- `bucket_arn` (string): The ARN of the created S3 bucket, useful for IAM policies and cross-stack references.

## Tags

This module accepts tags as a parameter and applies them directly to the S3 bucket resource. When using this module, the caller should provide tags following the project tagging baseline defined in Governance Baseline v1.

**Tag semantics:**

- **Stack-level tags** (applied by root module consuming this module):
  - `project`: Project identifier
  - `environment`: dev, prod, staging, etc.
  - `managed_by`: terraform
  - `owner`: Team or person responsible for the stack
  - `component`: Name of the stack/component (e.g., "foundation", "storage", "network")
  - `repository`: Source repository name

- **Resource-level tags** (specific to this module's purpose):
  - `component`: Can be set to "s3_bucket" or similar when documenting resource-specific components

Example: a stack consuming this module might pass `component: foundation` at stack level, but the resource itself could be tagged with additional metadata describing its specific role.

## Example

```hcl
module "app_bucket" {
  source      = "../../../modules/s3_bucket"
  bucket_name = var.bucket_name
  tags = {
    project      = "terraform-aws-platform-foundation"
    environment  = "dev"
    managed_by   = "terraform"
    owner        = "matias"
    component    = "foundation"
    repository   = "terraform-aws-platform-foundation"
  }
}

output "bucket_arn" {
  value = module.app_bucket.bucket_arn
}
```

## Implementation Notes

- The module creates an S3 bucket with server-side encryption enabled by default (`aws_s3_bucket` resource).
- The module does NOT configure bucket policies, versioning, or lifecycle policies; these should be configured by consumers if needed.
- Tags are applied directly and inherit all tag semantics from the consuming root module.
