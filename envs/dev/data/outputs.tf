output "app_bucket_name" {
  value = module.app_bucket.bucket_name
}

output "app_bucket_arn" {
  value = module.app_bucket.bucket_arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.app.name
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.app.arn
}
