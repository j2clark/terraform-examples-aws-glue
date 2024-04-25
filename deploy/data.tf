data aws_s3_bucket "artifacts" {
  bucket = local.project_name
}

data "aws_iam_role" "execution_role" {
  name = "${local.project_name}-execution-role"
}