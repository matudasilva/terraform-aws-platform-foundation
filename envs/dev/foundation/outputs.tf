output "bucket_name" {
  value = module.app_bucket.bucket_name
}

output "bucket_arn" {
  value = module.app_bucket.bucket_arn
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_ci_plan.arn
}
