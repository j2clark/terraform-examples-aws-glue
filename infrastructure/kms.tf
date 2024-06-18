# resource "aws_kms_key" "kms" {
#    description = "SNS Envryption/Decription for ${local.name_prefix}"
#    tags = local.common_tags
# }
#
# resource "aws_kms_alias" "a" {
#   name          = "alias/${local.name_prefix}"
#   target_key_id = aws_kms_key.kms.key_id
# }
#
# resource "aws_kms_key_policy" "example" {
#   key_id = aws_kms_key.kms.id
#   policy = data.aws_iam_policy_document.kms_policy.json
# }
#
# data "aws_iam_policy_document" "kms_policy" {
#   statement {
#     effect  = "Allow"
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#     actions = [
#       "kms:*",
#     ]
#     resources = ["*"]
#   }
# }