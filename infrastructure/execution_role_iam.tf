data "aws_iam_policy_document" "assumes_role_document" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = [
        "glue.amazonaws.com",
      ]
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

#resource "aws_iam_role" "execution_role" {
#  name = "${local.project_name}-${var.branch}-execution"
#  assume_role_policy = data.aws_iam_policy_document.codebuild_role_document.json
#}

resource "aws_iam_role" "execution_role" {
  name = "${local.name_prefix}-execution"
  assume_role_policy = data.aws_iam_policy_document.assumes_role_document.json
}

