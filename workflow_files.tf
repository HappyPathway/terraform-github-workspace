# Resource to create a GitHub repository file for Terraform apply workflow
resource "github_repository_file" "plan" {
  repository = data.github_repository.repo.name
  file       = ".github/workflows/terraform-plan.yml"
  content = templatefile(
    "${path.module}/workflow-templates/terraform-plan.yaml",
    {
      repo_name            = data.github_repository.repo.name,
      repo_org             = var.repo_org,
      branch               = var.branch.name,
      secrets              = var.secrets,
      vars                 = var.vars,
      runs_on              = var.runner_group,
      aws_auth             = var.composite_action_repos.aws_auth,
      gh_auth              = var.composite_action_repos.gh_auth,
      gh_actions_terraform = var.composite_action_repos.setup_terraform,
      terraform_init       = var.composite_action_repos.terraform_init,
      terraform_plan       = var.composite_action_repos.terraform_plan,
      terraform_apply      = var.composite_action_repos.terraform_apply,
      checkout             = var.composite_action_repos.checkout,
      environment          = lookup(github_repository_environment.this, var.environment).environment
      staging_environment  = lookup(github_repository_environment.this, "${var.environment}-staging").environment
    }
  )
  branch = data.github_repository.repo.default_branch
}

# Resource to create a GitHub repository file for Terraform apply workflow
resource "github_repository_file" "apply" {
  repository = data.github_repository.repo.name
  file       = ".github/workflows/terraform-apply.yml"
  content = templatefile(
    "${path.module}/workflow-templates/terraform-apply-${var.environment}.yaml",
    {
      repo_name            = data.github_repository.repo.name,
      repo_org             = var.repo_org,
      branch               = var.branch.name,
      secrets              = var.secrets,
      vars                 = var.vars,
      runs_on              = var.runner_group,
      aws_auth             = var.composite_action_repos.aws_auth,
      gh_auth              = var.composite_action_repos.gh_auth,
      gh_actions_terraform = var.composite_action_repos.setup_terraform,
      terraform_init       = var.composite_action_repos.terraform_init,
      terraform_plan       = var.composite_action_repos.terraform_plan,
      terraform_apply      = var.composite_action_repos.terraform_apply,
      checkout             = var.composite_action_repos.checkout,
      environment          = lookup(github_repository_environment.this, var.environment).environment
      staging_environment  = lookup(github_repository_environment.this, "${var.environment}-staging").environment
    }
  )
  branch = data.github_repository.repo.default_branch
}

# Resource to create a GitHub repository file for Terraform init workflow
resource "github_repository_file" "backend_tf" {
  count      = var.state_config.set_backend == {} ? 0 : 1
  repository = data.github_repository.repo.name
  file       = "backend-configs/${var.environment}.tf"
  content = templatefile(
    "${path.module}/workflow-templates/backend.tpl",
    {
      bucket         = var.state_config.bucket,
      key            = var.state_config.key,
      region         = var.state_config.region,
      dynamodb_table = var.state_config.dynamodb_table
    }
  )
}
