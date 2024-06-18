# resource "aws_sns_topic" "glue_failures" {
#   name = "${local.name_prefix}-job-failures"
#   kms_master_key_id = aws_kms_key.kms.id
# }
#
# resource "aws_sns_topic_policy" "glue_failures_policy" {
#   arn    = aws_sns_topic.glue_failures.arn
#   policy = data.aws_iam_policy_document.glue_failures_policy.json
# }
#
# data "aws_iam_policy_document" "glue_failures_policy" {
#   statement {
#     effect  = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["events.amazonaws.com"]
#     }
#     actions = [
#       "SNS:Publish",
# #       "SNS:Receive",
# #       "SNS:ListSubscriptionsByTopic",
# #       "SNS:GetTopicAttributes",
#     ]
#     resources = [
#       aws_sns_topic.glue_failures.arn
#     ]
#   }
# }
#
