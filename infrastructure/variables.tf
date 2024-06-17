variable "branch" {
  type = string
  default = "main"
}

locals {
  region       = data.aws_region.current.id
  account_id   = data.aws_caller_identity.current.account_id
  project_name = "examples-aws-glue"
  github_repo  = "j2clark/terraform-examples-aws-glue"
  buildspec    = "code/buildspec.yml"
  name_prefix  = "${local.project_name}-${var.branch}"

  common_tags = {
    ProjectName = "terraform-examples-aws-glue"
    Github = "j2clark/terraform-aws-glue"
    Branch = var.branch
  }
}
