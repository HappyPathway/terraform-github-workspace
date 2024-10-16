
variable "secrets" {
  type = list(object({
    name  = string,
    value = string
  }))
  default     = []
  description = "Github Action Secrets"
}

variable "vars" {
  type = list(object({
    name  = string,
    value = string
  }))
  default     = []
  description = "Github Action Vars"
}


# CSVD/gh-actions-checkout@v4
# CSVD/aws-auth@main
# CSVD/gh-actions-terraform@v1
# CSVD/terraform-init@main
# CSVD/terraform-plan@main
# CSVD/terraform-apply@main
# CSVD/gh-auth@main
variable "repos" {
  type = map(string)
  default = {
    gh_actions_checkout  = "gh-actions-checkout@v4"
    aws_auth             = "aws-auth@main"
    gh_actions_terraform = "gh-actions-terraform@v1"
    terraform_init       = "terraform-init@main"
    terraform_plan       = "terraform-plan@main"
    terraform_apply      = "terraform-apply@main"
    gh_auth              = "gh-auth@main"
  }
}

variable "repo_name" {
  type        = string
  description = "The name of the repository"
}

variable "repo_org" {
  type        = string
  description = "The organization of the repository"
}

variable "environment" {
  type        = string
  description = "The environment name"
}
