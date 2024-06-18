resource "aws_kms_key" "kms" {
   description = "SNS Envryption/Decription for ${local.project_name}"
   tags = local.common_tags
}

resource "aws_kms_alias" "a" {
  name          = "alias/${local.project_name}"
  target_key_id = aws_kms_key.kms.key_id
}

resource "aws_kms_key_policy" "example" {
  key_id = aws_kms_key.kms.id
  policy = data.aws_iam_policy_document.kms_policy.json
}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:*",
    ]
    resources = ["*"]
  }
}

resource "aws_sns_topic" "glue_failures" {
  name = "${local.project_name}-job-failures"
  kms_master_key_id = aws_kms_key.kms.id
}

resource "aws_sns_topic_policy" "glue_failures_policy" {
  arn    = aws_sns_topic.glue_failures.arn
  policy = data.aws_iam_policy_document.glue_failures_policy.json
}

data "aws_iam_policy_document" "glue_failures_policy" {
  statement {
    sid = "SNSManage"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "SNS:Publish",
      "SNS:RemovePermission",
      "SNS:SetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:AddPermission",
      "SNS:Subscribe"
    ]
    resources = [
      aws_sns_topic.glue_failures.arn
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values = [
        local.account_id
      ]
    }
  }

  statement {
    sid = "SNSPublish"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "SNS:Publish"
    ]
    resources = [
      aws_sns_topic.glue_failures.arn
    ]
  }

  statement {
    sid = "SNSSubscribe"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "SNS:Subscribe"
    ]
    resources = [
      aws_sns_topic.glue_failures.arn
    ]
  }
}