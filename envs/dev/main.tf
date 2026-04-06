module "app_bucket" {
  source      = "../../modules/s3_bucket"
  bucket_name = var.bucket_name
  tags        = var.tags
}