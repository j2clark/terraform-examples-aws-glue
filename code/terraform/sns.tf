resource "aws_sns_topic" "glue_failures" {
  name = "${local.name_prefix}-job-failures"
}

resource "aws_sns_topic_policy" "glue_failures_policy" {
  arn    = aws_sns_topic.glue_failures.arn
  policy = data.aws_iam_policy_document.glue_failures_policy.json
}

data "aws_iam_policy_document" "glue_failures_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.glue_failures.arn]
  }
}