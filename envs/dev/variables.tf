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
    ManagedBy   = "Terraform"
    Environment = "dev"
    Project     = "terraform-aws-platform-foundation"
  }
}