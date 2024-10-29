locals {
  custom_branch_policies               = var.environment.deployment_branch_policy.custom_branch_policies
  restrict_branches                    = var.environment.deployment_branch_policy.restrict_branches
  branch_specified                     = var.environment.deployment_branch_policy.branch != null
  deployment_branch_policy_is_set      = var.environment.deployment_branch_policy != null
  branch_pattern_specified             = var.environment.deployment_branch_policy.branch_pattern != null
  create_deployment_branch_policy      = local.deployment_branch_policy_is_set && local.custom_branch_policies && local.restrict_branches && local.branch_specified
  create_environment_deployment_policy = local.deployment_branch_policy_is_set && local.custom_branch_policies && local.restrict_branches && local.branch_pattern_specified
  _create_branch_protection            = var.environment.deployment_branch_policy.create_branch_protection
  create_branch_protection_pattern     = local.branch_pattern_specified && local._create_branch_protection
  create_branch_protection_branch      = local.branch_specified && local._create_branch_protection
  required_status_checks_set           = var.environment.deployment_branch_policy.required_status_checks != null
  required_status_checks               = var.environment.deployment_branch_policy.required_status_checks
  required_pull_request_reviews_set    = var.environment.deployment_branch_policy.required_pull_request_reviews != null
  required_pull_request_reviews        = var.environment.deployment_branch_policy.required_pull_request_reviews
}
