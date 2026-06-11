module "vpc" {
  source = "../../../modules/vpc"

  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    project     = "terraform-aws-platform-foundation"
    environment = "dev"
    managed_by  = "terraform"
    owner       = "matudasilva"
    component   = "network"
    repository  = "matudasilva/terraform-aws-platform-foundation"
  }
}
