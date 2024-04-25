data "aws_iam_policy_document" "execution_policy_document" {
  statement {
    sid = "Logs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      #     job names are not part of log resource
      "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:/aws-glue/python-jobs/*"
    ]
  }

  statement {
    sid = "GlueScriptAccess"
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:GetObject*",
    ]
    resources = [
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*"
#      TODO: test "${aws_s3_bucket.artifacts.arn}/scripts/*",
#      TODO: test "${aws_s3_bucket.artifacts.arn}/wheels/*"
    ]
  }
}

resource "aws_iam_policy" "execution_policy" {
  name = "${local.project_name}-execution-policy"
  policy = data.aws_iam_policy_document.execution_policy_document.json
}


resource "aws_iam_role_policy_attachment" "execution-role-policy-attachment" {
  role       = aws_iam_role.execution_role.name
  policy_arn = aws_iam_policy.execution_policy.arn
}