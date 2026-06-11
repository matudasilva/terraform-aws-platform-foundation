variable "role_name" {
  type        = string
  description = "Name of the IAM role"
}

variable "assume_role_policy" {
  type        = string
  description = "JSON assume role policy document"
}

variable "policy_arns" {
  type        = list(string)
  description = "List of policy ARNs to attach to the role"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"

  validation {
    condition = alltrue([
      contains(keys(var.tags), "project"),
      contains(keys(var.tags), "environment"),
      contains(keys(var.tags), "managed_by"),
      contains(keys(var.tags), "owner"),
      contains(keys(var.tags), "component"),
      contains(keys(var.tags), "repository"),
    ])
    error_message = "tags must include: project, environment, managed_by, owner, component, repository"
  }
}
