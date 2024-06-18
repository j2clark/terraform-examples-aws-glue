data "aws_iam_policy_document" "codebuild_policy_document" {
  statement {
    sid = "GetIAMRole"
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:PassRole"
    ]
    resources = [
      aws_iam_role.execution_role.arn
    ]
  }

  statement {
    sid = "Logs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*"
    ]
  }

  statement {
    sid = "CodeBuild"
    effect = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      "arn:aws:codebuild:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:report-group/${local.name_prefix}*"
    ]
  }

  statement {
    sid = "S3WriteAccessArtifacts"
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:PutObject*",
      "s3:GetObject*",
      "s3:DeleteObject*",
      "s3:GetBucket*"
    ]
    resources = [
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*",
#       "${aws_s3_bucket.artifacts.arn}/${var.branch}",
#       "${aws_s3_bucket.artifacts.arn}/${var.branch}/*"
    ]
  }

  statement {
    sid = "ManageGlueJobs"
    effect = "Allow"
    actions = [
      "glue:GetJob",
      "glue:GetTags",
      "glue:CreateJob",
      "glue:UpdateJob",
      "glue:DeleteJob"
    ]
    resources = [
      "arn:aws:glue:${data.aws_region.current.id}:${data.aws_caller_identity.current.id}:job/${local.project_name}*"
    ]
  }

  statement {
    sid = "ManageCloudwatchAlarm"
    effect = "Allow"
    actions = [
      "cloudwatch:DescribeAlarms",
      "cloudwatch:ListTagsForResource",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:PutMetricAlarm",
    ]
    resources = [
      "arn:aws:cloudwatch:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:alarm:${local.project_name}*"
    ]
  }

  statement {
    sid = "ManageSNS"
    effect = "Allow"
    actions = [
      "SNS:CreateTopic",
      "SNS:GetTopicAttributes",
      "SNS:ListTagsForResource",
      "SNS:SetTopicAttributes",
      "SNS:DeleteTopic",
    ]
    resources = [
      "arn:aws:sns:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:${local.project_name}*"
    ]
  }
}

resource "aws_iam_policy" "codebuild_policy" {
  name = "${local.name_prefix}-codebuild"
  policy = data.aws_iam_policy_document.codebuild_policy_document.json
}


resource "aws_iam_role_policy_attachment" "codebuild-role-policy-attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}