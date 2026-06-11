# iam_role

Reusable IAM role module with managed policy attachments and an EC2 instance profile.

## Inputs

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `role_name` | `string` | Name of the IAM role and instance profile. | n/a |
| `assume_role_policy` | `string` | JSON assume role policy document. | n/a |
| `policy_arns` | `list(string)` | List of managed policy ARNs to attach to the role. | `[]` |
| `tags` | `map(string)` | Tags to apply to all supported resources. Must include the project mandatory tags. | n/a |

## Outputs

| Name | Description |
|------|-------------|
| `role_arn` | ARN of the IAM role. |
| `role_name` | Name of the IAM role. |
| `instance_profile_name` | Name of the IAM instance profile. |
| `instance_profile_arn` | ARN of the IAM instance profile. |

## Example

```hcl
module "ec2_role" {
  source = "../../modules/iam_role"

  role_name = "ec2-ssm-role-dev"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  tags = {
    project     = "terraform-aws-platform-foundation"
    environment = "dev"
    managed_by  = "terraform"
    owner       = "matudasilva"
    component   = "compute"
    repository  = "matudasilva/terraform-aws-platform-foundation"
  }
}
```
