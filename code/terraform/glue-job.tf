data "aws_s3_object" "framework_wheel" {
    bucket = data.aws_s3_bucket.artifacts.bucket
    key = "${var.branch}/wheels/pyshell_framework-1.0-py3-none-any.whl"
}

data "aws_s3_object" "script" {
    bucket = data.aws_s3_bucket.artifacts.bucket
    key = "${var.branch}/scripts/glue-script.py"
}

data "aws_s3_object" "data" {
    bucket = data.aws_s3_bucket.artifacts.bucket
    key = "${var.branch}/input/example.data.txt"
}

resource "aws_glue_job" "framework_job" {
    name        = "${local.name_prefix}-pyshell"
    role_arn    = data.aws_iam_role.execution_role.arn
    command {
        name = "pythonshell"
        python_version = "3.9"
        script_location = "s3://${data.aws_s3_object.script.bucket}/${data.aws_s3_object.script.key}"
    }
    default_arguments = {
        "--extra-py-files": "s3://${data.aws_s3_object.framework_wheel.bucket}/${data.aws_s3_object.framework_wheel.key}"
        "--bucket": data.aws_s3_object.data.bucket
        "--input": data.aws_s3_object.data.key
        "--output": "${var.branch}/output/transformed.txt"
        "--application": var.project_name
        "--branch": var.branch
    }
    execution_property {
        max_concurrent_runs = local.max_concurrent_runs
    }
    max_retries = local.max_retries
    timeout = local.timeout
    tags = local.common_tags
}