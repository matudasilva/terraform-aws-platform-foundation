variable "aws_region" {
  description = "AWS region for the lab"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {
    project     = "terraform-aws-platform-foundation"
    environment = "dev"
    managed_by  = "terraform"
    owner       = "matias"
    component   = "foundation"
    repository  = "terraform-aws-platform-foundation"
  }
}

variable "github_repository" {
  description = "GitHub repository in owner/repo format allowed to assume the OIDC role"
  type        = string
  default     = "matudasilva/terraform-aws-platform-foundation"
}

variable "allowed_branches" {
  description = "Git branches allowed to assume the OIDC role"
  type        = list(string)
  default     = ["main", "develop"]
}

variable "oidc_audience" {
  description = "OIDC audience expected by AWS STS"
  type        = string
  default     = "sts.amazonaws.com"
}
