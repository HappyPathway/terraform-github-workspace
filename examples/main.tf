# main.tf
module "github_actions" {
  source    = "./.." # Path to the root of the module
  repo_name = "terraform-github-workspace"
  repo_org  = "HappyPathway"

  environments = [
    {
      name = "production"
      reviewers = {
        enforce_reviewers = true
        teams             = ["terrform-reviewers"]
      }
      #   state_config = {
      #     bucket         = "my-terraform-state-bucket"
      #     key_prefix     = "terraform/production/terraform-github-workspace"
      #     region         = "us-west-2"
      #     dynamodb_table = "terraform-lock-table"
      #     set_backend    = true
      #   }
      deployment_branch_policy = {
        restrict_branches = false
      }
      secrets = [
        {
          name  = "SECRET_KEY"
          value = "stagingsecretvalue"
        }
      ]
      vars = [
        {
          name  = "ENV_VAR"
          value = "staging"
        }
      ]
    }
  ]

  composite_action_repos = {
    checkout        = "actions/checkout@v4"
    aws_auth        = "aws-actions/configure-aws-credentials@v1"
    setup_terraform = "hashicorp/setup-terraform@v1"
    terraform_init  = "hashicorp/terraform-init@v1"
    terraform_plan  = "hashicorp/terraform-plan@v1"
    terraform_apply = "hashicorp/terraform-apply@v1"
    gh_auth         = "actions/github-script@v4"
  }
  runner_group = "self-hosted"
}
