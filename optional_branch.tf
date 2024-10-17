# Resource to set branch protection rules for the GitHub repository
resource "github_branch_protection" "this" {
  count         = var.create_branch ? 1 : 0
  pattern       = var.branch
  repository_id = data.github_repository.repo.node_id

  enforce_admins = var.enforce_admins

  required_status_checks {
    strict   = var.strict
    contexts = var.contexts
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = var.dismiss_stale_reviews
    require_code_owner_reviews      = var.require_code_owner_reviews
    required_approving_review_count = var.required_approving_review_count
  }
}

