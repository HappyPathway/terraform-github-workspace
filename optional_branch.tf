# Resource to set branch protection rules for the GitHub repository
resource "github_branch_protection" "this" {
  count         = var.branch.create_branch ? 1 : 0
  pattern       = var.branch.pattern
  repository_id = data.github_repository.repo.node_id

  enforce_admins = var.branch.enforce_admins

  required_status_checks {
    strict   = var.branch.strict
    contexts = var.branch.contexts
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = var.branch.dismiss_stale_reviews
    require_code_owner_reviews      = var.branch.require_code_owner_reviews
    required_approving_review_count = var.branch.required_approving_review_count
  }
}

