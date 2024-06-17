data aws_s3_bucket "artifacts" {
  bucket = var.artifacts
}

data "aws_iam_role" "execution_role" {
  name = "${local.name_prefix}-execution"
}