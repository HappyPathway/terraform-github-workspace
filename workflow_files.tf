# Resource to create a GitHub repository file for Terraform apply workflow
resource "github_repository_file" "plan" {
  for_each            = tomap({ for env in var.environments : env.name => env })
  repository          = data.github_repository.repo.name
  file                = ".github/workflows/terraform-plan-${each.value.name}.yml"
  overwrite_on_create = true
  content = templatefile(
    "${path.module}/workflow-templates/terraform-plan.yaml",
    {
      repo_name       = data.github_repository.repo.name,
      repo_org        = var.repo_org,
      branch          = each.value.deployment_branch_policy.branch,
      secrets         = var.secrets,
      vars            = var.vars,
      runs_on         = var.runner_group,
      aws_auth        = var.composite_action_repos.aws_auth,
      gh_auth         = var.composite_action_repos.gh_auth,
      setup_terraform = var.composite_action_repos.setup_terraform,
      terraform_init  = var.composite_action_repos.terraform_init,
      terraform_plan  = var.composite_action_repos.terraform_plan,
      terraform_apply = var.composite_action_repos.terraform_apply,
      checkout        = var.composite_action_repos.checkout,
      environment     = lookup(github_repository_environment.this, each.value.name).environment
    }
  )
  branch = data.github_repository.repo.default_branch
  lifecycle {
    ignore_changes = [
      branch,
      content
    ]
  }
}

# Resource to create a GitHub repository file for Terraform apply workflow
resource "github_repository_file" "apply" {
  for_each            = tomap({ for env in var.environments : env.name => env })
  repository          = data.github_repository.repo.name
  file                = ".github/workflows/terraform-apply-${each.value.name}.yml"
  overwrite_on_create = true
  content = templatefile(
    "${path.module}/workflow-templates/terraform-apply.yaml",
    {
      repo_name       = data.github_repository.repo.name,
      repo_org        = var.repo_org,
      branch          = each.value.deployment_branch_policy.branch,
      secrets         = var.secrets,
      vars            = var.vars,
      runs_on         = var.runner_group,
      aws_auth        = var.composite_action_repos.aws_auth,
      gh_auth         = var.composite_action_repos.gh_auth,
      setup_terraform = var.composite_action_repos.setup_terraform,
      terraform_init  = var.composite_action_repos.terraform_init,
      terraform_plan  = var.composite_action_repos.terraform_plan,
      terraform_apply = var.composite_action_repos.terraform_apply,
      checkout        = var.composite_action_repos.checkout,
      environment     = lookup(github_repository_environment.this, each.value.name).environment
    }
  )
  branch = data.github_repository.repo.default_branch
  lifecycle {
    ignore_changes = [
      branch,
      content
    ]
  }
}

# Resource to create a GitHub repository file for Terraform init workflow
resource "github_repository_file" "backend_tf" {
  for_each            = tomap({ for env in var.environments : env.name => env })
  repository          = data.github_repository.repo.name
  file                = "backend-configs/${each.value.name}.tf"
  overwrite_on_create = true
  content = templatefile(
    "${path.module}/workflow-templates/backend.tpl",
    {
      bucket         = each.value.state_config.bucket,
      key            = each.value.state_config.key,
      region         = each.value.state_config.region,
      dynamodb_table = each.value.state_config.dynamodb_table
    }
  )
}
