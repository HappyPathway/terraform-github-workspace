# Data source to fetch the GitHub repository details
data "github_repository" "repo" {
  name = var.repo_name
}

locals {
  environment         = lookup(github_repository_environment.this, var.environment).environment
  staging_environment = lookup(github_repository_environment.this, "${var.environment}-staging").environment
}

# Resource to create a GitHub repository environment
resource "github_repository_environment" "this" {
  for_each = toset([
    var.environment,
    "${var.environment}-staging"
  ])
  environment         = each.value
  repository          = data.github_repository.repo.name
  prevent_self_review = var.prevent_self_review
  reviewers {
    users = var.reviewers
    teams = var.reviewers_teams
  }
  deployment_branch_policy {
    protected_branches     = var.protected_branches
    custom_branch_policies = var.custom_branch_policies
  }
}

resource "github_repository_deployment_branch_policy" "this" {
  count            = var.custom_branch_policies && var.branch != null ? 1 : 0
  repository       = data.github_repository.repo.name
  environment_name = local.environment
  name             = var.branch.name
}

# Resource to create a deployment policy for the GitHub repository environment
resource "github_repository_environment_deployment_policy" "this" {
  count          = var.custom_branch_policies && var.branch_pattern != null ? 1 : 0
  repository     = data.github_repository.repo.name
  environment    = local.environment
  branch_pattern = var.branch_pattern
}
