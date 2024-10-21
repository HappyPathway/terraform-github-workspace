# Data source to fetch the GitHub repository details
data "github_repository" "repo" {
  name = var.repo_name
}

locals {
  # The main environment for deployment
  environment = lookup(github_repository_environment.this, var.environment).environment

  # The staging environment for running plans with the same data but without actual deployment
  # this environment has a copy of the main environment's settings. 
  # applies are bound to an environment. the envrironment is protected and requires an approval 
  # in order to be deployed to. This staging-envrironment does not need approval and has the same data. 
  staging_environment = lookup(github_repository_environment.this, "${var.environment}-staging").environment
}

# Resource to create a GitHub repository environment

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
  for_each = toset([
    var.environment,
    "${var.environment}-staging"
  ])
  environment         = each.value
  repository          = data.github_repository.repo.name
  prevent_self_review = null
  reviewers {
    users = local.reviewers_users
    teams = local.reviewers_teams
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
