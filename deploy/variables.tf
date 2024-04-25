variable "branch" {
  type = string
  default = "refactor"
}

locals {
  project_name = "terraform-examples-aws-glue"
  github_repo  = "j2clark/terraform-aws-glue"
  buildspec    = "code/buildspec.yml"

  common_tags = {
    ProjectName = "terraform-examples-aws-glue"
    Github = "j2clark/terraform-aws-glue"
    Branch = var.branch
  }
}
