# Resource to set branch protection rules for the GitHub repository
resource "github_branch" "branch" {
  for_each   = tomap({ for environment in var.environments : environment.name => environment.deployment_branch_policy.branch if environment.deployment_branch_policy.create_branch })
  repository = data.github_repository.repo.name
  branch     = each.value
}

resource "github_branch_protection" "this" {
  for_each      = tomap({ for environment in var.environments : environment.name => environment.deployment_branch_policy if environment.deployment_branch_policy.branch != null })
  pattern       = github_branch.branch[0].branch
  repository_id = data.github_repository.repo.node_id

  enforce_admins = each.value.deployment_branch_policy.enforce_admins

  dynamic "required_status_checks" {
    for_each = toset([for environment in var.environments : each.value.deployment_branch_policy if each.value.deployment_branch_policy.required_status_checks != null])
    content {
      strict   = required_status_checks.value.strict
      contexts = required_status_checks.value.contexts
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = toset([for environment in var.environments : each.value.deployment_branch_policy])
    content {
      dismiss_stale_reviews           = required_pull_request_reviews.value.dismiss_stale_reviews
      require_code_owner_reviews      = required_pull_request_reviews.value.require_code_owner_reviews
      required_approving_review_count = required_pull_request_reviews.value.required_approving_review_count
    }
  }
}

