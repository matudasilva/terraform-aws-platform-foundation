# VPC Module

Reusable Terraform module to create a tagged AWS VPC with public/private subnets, Internet Gateway, optional NAT Gateways, route tables, and an S3 Gateway Endpoint.

## Inputs

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `vpc_cidr` | `string` | CIDR block for the VPC. | n/a |
| `availability_zones` | `list(string)` | Availability Zones where subnets are created. | n/a |
| `public_subnet_cidrs` | `list(string)` | CIDR blocks for public subnets, aligned by index with `availability_zones`. | n/a |
| `private_subnet_cidrs` | `list(string)` | CIDR blocks for private subnets, aligned by index with `availability_zones`. | n/a |
| `enable_nat_gateway` | `bool` | Whether to create NAT Gateway resources and private default routes. | `true` |
| `single_nat_gateway` | `bool` | Whether to create a single NAT Gateway in the first public subnet instead of one per AZ. | `false` |
| `tags` | `map(string)` | Required project tags. Must include `project`, `environment`, `managed_by`, `owner`, `component`, and `repository`. | n/a |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | ID of the VPC. |
| `public_subnet_ids` | IDs of the public subnets. |
| `private_subnet_ids` | IDs of the private subnets. |
| `vpc_cidr_block` | CIDR block of the VPC. |
| `nat_gateway_ids` | IDs of the NAT Gateways. |

## Example

```hcl
module "vpc" {
  source = "../../../modules/vpc"

  vpc_cidr = "10.0.0.0/16"
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24",
  ]

  enable_nat_gateway = true
  single_nat_gateway = false

  tags = {
    project     = "terraform-aws-platform-foundation"
    environment = "dev"
    managed_by  = "terraform"
    owner       = "matias"
    component   = "network"
    repository  = "terraform-aws-platform-foundation"
  }
}
```
