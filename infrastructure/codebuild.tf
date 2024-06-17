resource "aws_codebuild_project" "codebuild_backend" {
  name         = local.name_prefix
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type            = "GITHUB"
    location        = "https://github.com/${local.github_repo}"
    git_clone_depth = 1
    buildspec       = local.buildspec
  }

  source_version = var.branch

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    # TODO: create custom image in ECR which will never expire, unlike AWS images
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "PROJECT_NAME"
      value = local.project_name
    }

    environment_variable {
      name  = "GITHUB_REPO"
      value = local.github_repo
    }

    environment_variable {
      name  = "BRANCH"
      value = var.branch
    }

    environment_variable {
      name  = "ARTIFACTS"
      value = aws_s3_bucket.artifacts.bucket
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  tags = local.common_tags
#  tags = merge(tomap({
#      Application: "Backend"
#    }),
#    local.common_tags
#  )
}

resource "aws_codebuild_webhook" "codebuild_backend_webhook" {
  project_name = aws_codebuild_project.codebuild_backend.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "^refs/heads/${var.branch}$"
    }
  }
}