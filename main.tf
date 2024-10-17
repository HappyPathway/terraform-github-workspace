# Data source to fetch the GitHub repository details
data "github_repository" "repo" {
  name = var.repo_name
}

# Resource to create a GitHub repository environment
resource "github_repository_environment" "this" {
  environment         = var.environment
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
  count       = var.custom_branch_policies && var.branch != null ? 1 : 0
  repository  = data.github_repository.repo.name
  environment = github_repository_environment.this.environment
  name        = var.branch
}

# Resource to create a deployment policy for the GitHub repository environment
resource "github_repository_environment_deployment_policy" "this" {
  repository     = data.github_repository.repo.name
  environment    = github_repository_environment.this.environment
  branch_pattern = var.branch_pattern
}

# Resource to create GitHub Actions environment secrets
resource "github_actions_environment_secret" "secret" {
  for_each        = tomap({ for secret in var.secrets : secret.name => secret.value })
  secret_name     = each.key
  plaintext_value = each.value
  environment     = github_repository_environment.this.environment
  repository      = data.github_repository.repo.name
}

# Resource to create GitHub Actions environment variables
resource "github_actions_environment_variable" "variable" {
  for_each      = tomap({ for _var in var.vars : _var.name => _var.value })
  environment   = github_repository_environment.this.environment
  variable_name = each.key
  value         = each.value
  repository    = data.github_repository.repo.name
}

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

# Resource to create a GitHub repository file for Terraform apply workflow
resource "github_repository_file" "apply" {
  repository = data.github_repository.repo.name
  file       = ".github/workflows/terraform-apply.yml"
  content = templatefile(
    "${path.module}/workflow-templates/terraform-apply.yaml",
    {
      repo_name            = data.github_repository.repo.name,
      branch               = var.branch,
      secrets              = var.secrets,
      vars                 = var.vars,
      repos                = var.repos,
      runs_on              = var.runner_group,
      aws_auth             = var.repos.aws_auth,
      gh_auth              = var.repos.gh_auth,
      gh_actions_terraform = var.repos.gh_actions_terraform,
      terraform_init       = var.repos.terraform_init,
      terraform_plan       = var.repos.terraform_plan,
      terraform_apply      = var.repos.terraform_apply,
      checkout             = var.repos.gh_actions_checkout,
      environment          = github_repository_environment.this.environment
    }
  )
  branch = var.branch
}
