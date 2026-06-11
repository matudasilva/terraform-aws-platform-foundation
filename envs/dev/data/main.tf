data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket  = "tf-platform-foundation-state-dev-938472"
    key     = "envs/dev/network/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-lab"
  }
}

locals {
  tags = {
    project     = "terraform-aws-platform-foundation"
    environment = "dev"
    managed_by  = "terraform"
    owner       = "matudasilva"
    component   = "data"
    repository  = "matudasilva/terraform-aws-platform-foundation"
  }
}

module "app_bucket" {
  source = "../../../modules/s3_bucket"

  bucket_name = "tf-platform-foundation-app-data-dev"
  tags        = local.tags
}

resource "aws_dynamodb_table" "app" {
  name         = "platform-foundation-app-dev"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = merge(local.tags, { Name = "platform-foundation-app-dev" })
}
