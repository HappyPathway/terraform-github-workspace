# Resource to create a GitHub repository file for Terraform apply workflow
resource "github_repository_file" "plan" {
  for_each            = tomap({ for env in var.environments : env.name => env })
  repository          = local.repo.name
  file                = ".github/workflows/terraform-plan-${each.value.name}.yml"
  overwrite_on_create = true
  content = templatefile(
    "${path.module}/workflow-templates/terraform-plan.yaml",
    {
      repo_name       = local.repo.name,
      repo_org        = var.repo.repo_org,
      branch          = compact([each.value.deployment_branch_policy.branch, local.repo.default_branch])[0],
      secrets         = var.secrets,
      vars            = var.vars,
      runs_on         = each.value.runner_group,
      aws_auth        = var.composite_action_repos.aws_auth,
      gh_auth         = var.composite_action_repos.gh_auth,
      setup_terraform = var.composite_action_repos.setup_terraform,
      terraform_init  = var.composite_action_repos.terraform_init,
      terraform_plan  = var.composite_action_repos.terraform_plan,
      terraform_apply = var.composite_action_repos.terraform_apply,
      checkout        = var.composite_action_repos.checkout,
      environment     = lookup(github_repository_environment.this, each.value.name).environment
      backend_config  = each.value.state_config.set_backend ? "backend-configs/${each.key}.tf" : "backend.tf"
    }
  )
  branch = local.repo.default_branch
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
  repository          = local.repo.name
  file                = ".github/workflows/terraform-apply-${each.value.name}.yml"
  overwrite_on_create = true
  content = templatefile(
    "${path.module}/workflow-templates/terraform-apply.yaml",
    {
      repo_name       = local.repo.name,
      repo_org        = var.repo.repo_org,
      branch          = compact([each.value.deployment_branch_policy.branch, local.repo.default_branch])[0],
      secrets         = var.secrets,
      vars            = var.vars,
      runs_on         = each.value.runner_group,
      aws_auth        = var.composite_action_repos.aws_auth,
      gh_auth         = var.composite_action_repos.gh_auth,
      setup_terraform = var.composite_action_repos.setup_terraform,
      terraform_init  = var.composite_action_repos.terraform_init,
      terraform_plan  = var.composite_action_repos.terraform_plan,
      terraform_apply = var.composite_action_repos.terraform_apply,
      checkout        = var.composite_action_repos.checkout,
      environment     = lookup(github_repository_environment.this, each.value.name).environment
      backend_config  = each.value.state_config.set_backend ? "backend-configs/${each.key}.tf" : "backend.tf"
    }
  )
  branch = local.repo.default_branch
  lifecycle {
    ignore_changes = [
      branch,
      content
    ]
  }
}
locals {
  # Create a map of environment-specific backend configurations
  environment_specific_backend_configs = {
    for env in var.environments : env.name => merge(
      env.state_config,
      {
        path = "backend-configs/${env.name}.tf",
        key  = "${env.state_config.key_prefix}/${env.name}.tfstate",
      }
    )
    if env.state_config.set_backend
  }

  # Global backend configuration
  global_backend_config = merge(
    var.state_config,
    {
      path = "backend.tf",
      key  = "${var.state_config.key_prefix}/terraform.tfstate",
    }
  )

  # Merge environment-specific and global backend configurations
  backend_configs = merge(
    local.environment_specific_backend_configs,
    var.state_config.set_backend ? { "global" = local.global_backend_config } : {}
  )
}

# Resource to create a GitHub repository file for Terraform init workflow
resource "github_repository_file" "backend_tf" {
  for_each            = tomap(local.backend_configs)
  repository          = local.repo.name
  file                = each.value.path
  overwrite_on_create = true
  content = templatefile(
    "${path.module}/workflow-templates/backend.tpl",
    {
      bucket         = each.value.bucket,
      key            = each.value.key,
      region         = each.value.region,
      dynamodb_table = each.value.dynamodb_table
    }
  )
}

resource "github_repository_file" "varfiles" {
  for_each            = tomap({ for environment in var.environments : environment.name => environment })
  repository          = local.repo.name
  file                = "varfiles/${var.repo.name}-${each.value.name}.tfvars"
  overwrite_on_create = true
  content = "# Add Terraform Variables here"
}
