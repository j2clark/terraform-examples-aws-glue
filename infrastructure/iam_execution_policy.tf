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
      "${aws_s3_bucket.artifacts.arn}/${var.branch}/scripts/*",
      "${aws_s3_bucket.artifacts.arn}/${var.branch}/wheels/*"
    ]
  }

  statement {
    sid = "GlueInputDataReadAccess"
    effect = "Allow"
    actions = [
      "s3:List*",
      "s3:GetObject*",
    ]
    resources = [
      "${aws_s3_bucket.artifacts.arn}/${var.branch}/input/*"
    ]
  }

  statement {
    sid = "GlueOutputDataWriteAccess"
    effect = "Allow"
    actions = [
#       "s3:List*",
      "s3:PutObject*",
    ]
    resources = [
      "${aws_s3_bucket.artifacts.arn}/${var.branch}/output",
      "${aws_s3_bucket.artifacts.arn}/${var.branch}/output/*"
    ]
  }
}

resource "aws_iam_policy" "execution_policy" {
  name = "${local.name_prefix}-execution"
  policy = data.aws_iam_policy_document.execution_policy_document.json
}


resource "aws_iam_role_policy_attachment" "execution-role-policy-attachment" {
  role       = aws_iam_role.execution_role.name
  policy_arn = aws_iam_policy.execution_policy.arn
}