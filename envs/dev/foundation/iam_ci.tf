data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "ci_terraform_plan" {
  name = "ci-terraform-plan"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:matudasilva/terraform-aws-platform-foundation:*"
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    project     = "terraform-aws-platform-foundation"
    environment = "dev"
    managed_by  = "terraform"
    owner       = "matudasilva"
    component   = "ci"
    repository  = "matudasilva/terraform-aws-platform-foundation"
  }
}

resource "aws_iam_role_policy" "ci_terraform_plan_policy" {
  name = "ci-terraform-plan-policy"
  role = aws_iam_role.ci_terraform_plan.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3BackendRead"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::tf-platform-foundation-state-dev-938472",
          "arn:aws:s3:::tf-platform-foundation-state-dev-938472/*"
        ]
      },
      {
        Sid    = "DynamoDBLockRead"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:DescribeTable"
        ]
        Resource = "arn:aws:dynamodb:us-east-1:342946498391:table/*"
      },
      {
        Sid    = "TerraformPlanReadOnly"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:GetBucketVersioning",
          "s3:GetBucketAcl",
          "s3:GetBucketLogging",
          "s3:GetBucketPolicy",
          "s3:GetEncryptionConfiguration",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetBucketTagging",
          "s3:GetLifecycleConfiguration",
          "kms:DescribeKey",
          "kms:GetKeyPolicy",
          "kms:GetKeyRotationStatus",
          "kms:ListResourceTags"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowOidcProviderRead"
        Effect = "Allow"
        Action = [
          "iam:ListOpenIDConnectProviders",
          "iam:GetOpenIDConnectProvider"
        ]
        Resource = "*"
      }
    ]
  })
}
