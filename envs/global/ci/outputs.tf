output "github_actions_role_arn" {
  value = aws_iam_role.ci_terraform_plan.arn
}
