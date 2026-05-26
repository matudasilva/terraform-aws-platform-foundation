locals {
  github_oidc_subjects = [
    for branch in var.allowed_branches :
    "repo:${var.github_repository}:ref:refs/heads/${branch}"
  ]
  foundation_bucket_arn = "arn:aws:s3:::${var.bucket_name}"
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = [var.oidc_audience]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
  ]
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    sid     = "GitHubActionsOIDCTrust"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = [var.oidc_audience]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.github_oidc_subjects
    }
  }
}

resource "aws_iam_role" "github_actions_ci_plan" {
  name               = "ci-terraform-plan"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}

data "aws_iam_policy_document" "github_actions_ci_plan" {
  statement {
    sid    = "AllowCallerIdentity"
    effect = "Allow"
    actions = [
      "sts:GetCallerIdentity"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowS3ReadMetadataForPlan"
    effect = "Allow"
    # s3:ListAllMyBuckets does not support resource-level permissions.
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowFoundationBucketReadForPlan"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketPolicyStatus",
      "s3:ListBucket"
    ]
    resources = [local.foundation_bucket_arn]
  }
}

resource "aws_iam_policy" "github_actions_ci_plan" {
  name   = "ci-terraform-plan-minimal"
  policy = data.aws_iam_policy_document.github_actions_ci_plan.json
}

resource "aws_iam_role_policy_attachment" "github_actions_ci_plan" {
  role       = aws_iam_role.github_actions_ci_plan.name
  policy_arn = aws_iam_policy.github_actions_ci_plan.arn
}
