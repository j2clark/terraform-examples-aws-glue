variable "project_name" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "branch" {
  type = string
}

variable "artifacts" {
  type = string
}

locals {
  max_retries = 0
  timeout = 5
  max_concurrent_runs = 1
  name_prefix = "${var.project_name}-${var.branch}"

  common_tags = {
    ProjectName = var.project_name
    Github = var.github_repo
    Branch = var.branch
  }
}
