data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket  = "tf-platform-foundation-state-dev-938472"
    key     = "envs/dev/network/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-lab"
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ec2_role" {
  source = "../../../modules/iam_role"

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

  tags = local.tags
}

resource "aws_security_group" "ec2" {
  name        = "ec2-private-dev"
  description = "Security group for private EC2 instance"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(local.tags, { Name = "ec2-private-dev" })
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = data.terraform_remote_state.network.outputs.private_subnet_ids[0]
  iam_instance_profile   = module.ec2_role.instance_profile_name
  vpc_security_group_ids = [aws_security_group.ec2.id]

  associate_public_ip_address = false

  metadata_options {
    http_tokens = "required"
  }

  tags = merge(local.tags, { Name = "ec2-private-dev" })
}

locals {
  tags = {
    project     = "terraform-aws-platform-foundation"
    environment = "dev"
    managed_by  = "terraform"
    owner       = "matudasilva"
    component   = "compute"
    repository  = "matudasilva/terraform-aws-platform-foundation"
  }
}
