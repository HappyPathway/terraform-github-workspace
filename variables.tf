variable "secrets" {
  type = list(object({
    name  = string,
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
    name  = string,
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
  validation {
    condition     = length(var.repos) > 0
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

variable "environment" {
  type        = string
  description = "The environment name"
  validation {
    condition     = length(var.environment) > 0
    error_message = "Environment name must not be empty."
  }
}

variable "branch" {
  type        = string
  description = "The branch name"
  validation {
    condition     = length(var.branch) > 0
    error_message = "Branch name must not be empty."
  }
}

variable "reviewers" {
  type        = list(string)
  description = "List of reviewers"
  validation {
    condition     = length(var.reviewers) >= 0
    error_message = "Reviewers must be a list of strings."
  }
}

variable "create_branch" {
  type        = bool
  description = "Flag to create a branch"
  validation {
    condition     = var.create_branch == true || var.create_branch == false
    error_message = "Create branch must be a boolean."
  }
}

variable "protected_branches" {
  type        = bool
  description = "Flag to protect branches"
  validation {
    condition     = var.protected_branches == true || var.protected_branches == false
    error_message = "Protected branches must be a boolean."
  }
}

variable "enforce_admins" {
  type        = bool
  description = "Flag to enforce admin rules"
  validation {
    condition     = var.enforce_admins == true || var.enforce_admins == false
    error_message = "Enforce admins must be a boolean."
  }
}

variable "reviewers_teams" {
  type        = list(string)
  description = "List of reviewer teams"
  validation {
    condition     = length(var.reviewers_teams) >= 0
    error_message = "Reviewer teams must be a list of strings."
  }
}

variable "branch_pattern" {
  type        = string
  description = "Branch pattern for deployment policy"
  validation {
    condition     = length(var.branch_pattern) > 0
    error_message = "Branch pattern must not be empty."
  }
}

variable "contexts" {
  type        = list(string)
  description = "List of status check contexts"
  validation {
    condition     = length(var.contexts) >= 0
    error_message = "Contexts must be a list of strings."
  }
}

variable "strict" {
  type        = bool
  description = "Flag to enforce strict status checks"
  validation {
    condition     = var.strict == true || var.strict == false
    error_message = "Strict must be a boolean."
  }
}

variable "restrictions_teams" {
  type        = list(string)
  description = "List of teams with branch restrictions"
  validation {
    condition     = length(var.restrictions_teams) >= 0
    error_message = "Restrictions teams must be a list of strings."
  }
}

variable "required_approving_review_count" {
  type        = number
  description = "Number of required approving reviews"
  validation {
    condition     = var.required_approving_review_count >= 0
    error_message = "Required approving review count must be a non-negative number."
  }
}

variable "dismiss_stale_reviews" {
  type        = bool
  description = "Flag to dismiss stale reviews"
  validation {
    condition     = var.dismiss_stale_reviews == true || var.dismiss_stale_reviews == false
    error_message = "Dismiss stale reviews must be a boolean."
  }
}

variable "restrictions_users" {
  type        = list(string)
  description = "List of users with branch restrictions"
  validation {
    condition     = length(var.restrictions_users) >= 0
    error_message = "Restrictions users must be a list of strings."
  }
}

variable "prevent_self_review" {
  type        = bool
  description = "Flag to prevent self-reviews"
  validation {
    condition     = var.prevent_self_review == true || var.prevent_self_review == false
    error_message = "Prevent self-review must be a boolean."
  }
}

variable "custom_branch_policies" {
  type        = bool
  description = "Flag to enable custom branch policies"
  validation {
    condition     = var.custom_branch_policies == true || var.custom_branch_policies == false
    error_message = "Custom branch policies must be a boolean."
  }
}

variable "require_code_owner_reviews" {
  type        = bool
  description = "Flag to require code owner reviews"
  validation {
    condition     = var.require_code_owner_reviews == true || var.require_code_owner_reviews == false
    error_message = "Require code owner reviews must be a boolean."
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
