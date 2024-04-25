resource aws_s3_bucket "artifacts" {
  bucket = local.project_name
  force_destroy = true
  tags = local.common_tags
}