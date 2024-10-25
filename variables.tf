variable "secrets" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "Github Action Secrets"
  validation {
    condition     = length(var.secrets) >= 0
    error_message = "Secrets must be a list of objects with name and value."
  }
}

variable "vars" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "Github Action Vars"
  validation {
    condition     = length(var.vars) >= 0
    error_message = "Vars must be a list of objects with name and value."
  }
}

variable "composite_action_repos" {
  type = object({
    checkout        = optional(string, "gh-actions-checkout@v4")
    aws_auth        = optional(string, "aws-auth@main")
    setup_terraform = optional(string, "gh-actions-terraform@v1")
    terraform_init  = optional(string, "terraform-init@main")
    terraform_plan  = optional(string, "terraform-plan@main")
    terraform_apply = optional(string, "terraform-apply@main")
    gh_auth         = optional(string, "gh-auth@main")
  })
  default = {
    checkout        = "gh-actions-checkout@v4"
    aws_auth        = "aws-auth@main"
    setup_terraform = "gh-actions-terraform@v1"
    terraform_init  = "terraform-init@main"
    terraform_plan  = "terraform-plan@main"
    terraform_apply = "terraform-apply@main"
    gh_auth         = "gh-auth@main"
  }
  validation {
    condition     = length(var.composite_action_repos) >= 0
    error_message = "Repos map must not be empty."
  }
}

variable "repo_name" {
  type        = string
  description = "The name of the repository"
  validation {
    condition     = length(var.repo_name) > 0
    error_message = "Repository name must not be empty."
  }
}

variable "repo_org" {
  type        = string
  description = "The organization of the repository"
  validation {
    condition     = length(var.repo_org) > 0
    error_message = "Repository organization must not be empty."
  }
}

variable "environments" {
  type = list(object({
    name = string
    reviewers = optional(object({
      users = list(string)
      teams = list(string)
      }), {
      users = []
      teams = []
    })
    deployment_branch_policy = optional(object({
      branch                 = string
      create_branch          = bool
      protected_branches     = bool
      custom_branch_policies = bool
      enforce_admins         = optional(bool, false)
      required_status_checks = optional(object({
        strict   = optional(bool, true)
        contexts = list(string)
        }), {
        strict   = false
        contexts = []
      })
      required_pull_request_reviews = optional(object({
        dismiss_stale_reviews           = optional(bool, true)
        require_code_owner_reviews      = optional(bool, true)
        required_approving_review_count = optional(number, 1)
        }), {
        dismiss_stale_reviews           = true
        require_code_owner_reviews      = true
        required_approving_review_count = 1
      })
      }), {
      branch                 = "main"
      create_branch          = false
      protected_branches     = false
      custom_branch_policies = false
    })
    state_config = optional(object({
      bucket         = optional(string, "inf-tfstate-us-gov-west-1-229685449397")
      key            = optional(string, "terraform.tfstate")
      region         = optional(string, "us-gov-west-1")
      dynamodb_table = optional(string, "tf_remote_state")
      set_backend    = optional(bool, false)
      }), {
      bucket         = "inf-tfstate-us-gov-west-1-229685449397"
      key            = "terraform.tfstate"
      region         = "us-gov-west-1"
      dynamodb_table = "tf_remote_state"
      set_backend    = false
    })
    secrets = optional(list(object({
      name  = string
      value = string
    })), [])
    vars = optional(list(object({
      name  = string
      value = string
    })), [])
  }))
  description = "List of environments with their configurations"
  validation {
    condition     = length(var.environments) > 0
    error_message = "Environments list must not be empty."
  }
}

variable "protected_branches" {
  type        = bool
  description = "Flag to protect branches"
  default     = true
  validation {
    condition     = var.protected_branches == true || var.protected_branches == false
    error_message = "Protected branches must be a boolean."
  }
}

variable "reviewers" {
  type        = string
  description = "Number of reviewers required for deployment"
  validation {
    condition     = can(regex("^[0-9]+$", var.reviewers))
    error_message = "Reviewers must be a valid number."
  }
}

variable "reviewers_teams" {
  type        = list(string)
  description = "List of reviewer teams"
  default     = []
  validation {
    condition     = length(var.reviewers_teams) >= 0
    error_message = "Reviewer teams must be a list of strings."
  }
}

variable "reviewers_users" {
  type        = list(string)
  description = "List of reviewer users"
  default     = []
  validation {
    condition     = length(var.reviewers_users) >= 0
    error_message = "Reviewer users must be a list of strings."
  }
}

variable "custom_branch_policies" {
  type        = bool
  description = "Flag to enable custom branch policies"
  default     = false
  validation {
    condition     = var.custom_branch_policies == true || var.custom_branch_policies == false
    error_message = "Custom branch policies must be a boolean."
  }
}

variable "branch_pattern" {
  type        = string
  description = "The branch pattern"
  default     = "main"
  validation {
    condition     = length(var.branch_pattern) > 0
    error_message = "Branch pattern must not be empty."
  }
}

variable "runner_group" {
  type        = string
  description = "The runner group name"
  validation {
    condition     = length(var.runner_group) > 0
    error_message = "Runner group name must not be empty."
  }
}

variable "state_config" {
  type = object({
    bucket         = optional(string, "inf-tfstate-us-gov-west-1-229685449397")
    key            = optional(string, "terraform.tfstate")
    region         = optional(string, "us-gov-west-1")
    dynamodb_table = optional(string, "tf_remote_state")
    set_backend    = optional(bool, false)
  })
  description = "Configuration for Terraform state storage"

  default = {}

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.state_config.bucket))
    error_message = "Bucket name must be between 3 and 63 characters, and can contain only lowercase letters, numbers, dots, and hyphens."
  }
  validation {
    condition     = can(regex("^(us|eu|ap|sa|ca|af|me|us-gov)-(north|south|east|west|central|northeast|southeast|southwest|northwest|central)-[0-9]$", var.state_config.region))
    error_message = "Region must be a valid AWS region, e.g., us-east-1, eu-west-3, us-gov-west-1."
  }
  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{3,255}$", var.state_config.dynamodb_table))
    error_message = "DynamoDB table name must be between 3 and 255 characters, and can contain only letters, numbers, underscores, dots, and hyphens."
  }
}
