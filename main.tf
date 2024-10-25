# Data source to fetch the GitHub repository details
data "github_repository" "repo" {
  name = var.repo_name
}

# Retrieve information about a GitHub user.
data "github_user" "reviewer" {
  for_each = toset(var.reviewers_users)
  username = each.value
}

data "github_organization_teams" "all" {}

locals {
  reviewers_teams = [for team in data.github_organization_teams.all.teams : team.id if contains(var.reviewers_teams, team.name)]
  reviewers_users = [for reviewer in toset(var.reviewers_users) : lookup(data.github_user.reviewer, reviewer).id]
}

resource "github_repository_environment" "this" {
  for_each            = toset(var.environments)
  environment         = each.value.name
  repository          = data.github_repository.repo.name
  prevent_self_review = null
  dynamic "reviewers" {
    for_each = toset([each.value.reviewers == null ? [] : each.value.reviewers])
    content {
      users = reviewers.value.reviewers.users
      teams = reviewers.value.reviewers.teams
    }
  }
  dynamic "deployment_branch_policy" {
    for_each = toset([each.value.deployment_branch_policy == null ? [] : each.value.deployment_branch_policy])
    content {
      protected_branches     = deployment_branch_policy.value.deployment_branch_policy.protected_branches
      custom_branch_policies = deployment_branch_policy.value.deployment_branch_policy.custom_branch_policies
    }
  }
}

resource "github_repository_deployment_branch_policy" "this" {
  for_each         = toset([for environment in var.environments : environment.deployment_branch_policy if environment.deployment_branch_policy.branch != null])
  repository       = data.github_repository.repo.name
  environment_name = each.value.name
  name             = each.value.deployment_branch_policy.branch
}

# Resource to create a deployment policy for the GitHub repository environment
resource "github_repository_environment_deployment_policy" "this" {
  for_each       = toset([for environment in var.environments : environment.deployment_branch_policy if environment.deployment_branch_policy.branch_pattern != null])
  repository     = data.github_repository.repo.name
  environment    = each.value.name
  branch_pattern = each.value.deployment_branch_policy.branch_pattern
}
