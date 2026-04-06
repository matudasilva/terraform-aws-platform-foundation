terraform {
  backend "s3" {
    bucket       = "tf-platform-foundation-state-dev-938472"
    key          = "envs/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}