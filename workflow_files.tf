# Resource to create a GitHub repository file for Terraform apply workflow
resource "github_repository_file" "plan" {
  repository = data.github_repository.repo.name
  file       = ".github/workflows/terraform-plan.yml"
  content = templatefile(
    "${path.module}/workflow-templates/terraform-plan.yaml",
    {
      repo_name            = data.github_repository.repo.name,
      repo_org             = var.repo_org,
      branch               = var.branch,
      secrets              = var.secrets,
      vars                 = var.vars,
      runs_on              = var.runner_group,
      aws_auth             = var.composite_action_repos.aws_auth,
      gh_auth              = var.composite_action_repos.gh_auth,
      gh_actions_terraform = var.composite_action_repos.gh_actions_terraform,
      terraform_init       = var.composite_action_repos.terraform_init,
      terraform_plan       = var.composite_action_repos.terraform_plan,
      terraform_apply      = var.composite_action_repos.terraform_apply,
      checkout             = var.composite_action_repos.gh_actions_checkout,
      environment          = lookup(github_repository_environment.this, var.environment).environment
      staging_environment  = lookup(github_repository_environment.this, "${var.environment}-staging").environment
    }
  )
  branch = var.branch
}

# Resource to create a GitHub repository file for Terraform apply workflow
resource "github_repository_file" "apply" {
  repository = data.github_repository.repo.name
  file       = ".github/workflows/terraform-apply.yml"
  content = templatefile(
    "${path.module}/workflow-templates/terraform-apply.yaml",
    {
      repo_name            = data.github_repository.repo.name,
      repo_org             = var.repo_org,
      branch               = var.branch,
      secrets              = var.secrets,
      vars                 = var.vars,
      runs_on              = var.runner_group,
      aws_auth             = var.composite_action_repos.aws_auth,
      gh_auth              = var.composite_action_repos.gh_auth,
      gh_actions_terraform = var.composite_action_repos.gh_actions_terraform,
      terraform_init       = var.composite_action_repos.terraform_init,
      terraform_plan       = var.composite_action_repos.terraform_plan,
      terraform_apply      = var.composite_action_repos.terraform_apply,
      checkout             = var.composite_action_repos.gh_actions_checkout,
      environment          = lookup(github_repository_environment.this, var.environment).environment
      staging_environment  = lookup(github_repository_environment.this, "${var.environment}-staging").environment
    }
  )
  branch = var.branch
}

# Resource to create a GitHub repository file for Terraform init workflow
resource "github_repository_file" "backend_tf" {
  repository = data.github_repository.repo.name
  file       = "backend.tf"
  content = templatefile(
    "${path.module}/workflow-templates/backend.tpl",
    {
      bucket         = var.bucket,
      key            = var.key,
      region         = var.region,
      dynamodb_table = var.dynamodb_table
    }
  )
}
