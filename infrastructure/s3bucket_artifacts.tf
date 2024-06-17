resource aws_s3_bucket "artifacts" {
  bucket = local.name_prefix
  force_destroy = true
  tags = local.common_tags
}