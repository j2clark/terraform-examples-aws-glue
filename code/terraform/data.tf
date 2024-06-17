data aws_s3_bucket "artifacts" {
  bucket = var.artifacts
}



data "aws_iam_role" "execution_role" {
  name = "${var.project_name}-execution"
}

#data "aws_kms_alias" "kms" {
#  name = "alias/kms-name"
#}
