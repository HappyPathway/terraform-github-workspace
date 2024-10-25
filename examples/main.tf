# main.tf
module "github_actions" {
  source = ".."

  repo_name = "terraform-github-workspace"
  repo_org  = "HappyPathway"

  environments = [
    {
      name = "production"
      reviewers = {
        users = ["user1", "user2"]
        teams = ["team1"]
      }
      deployment_branch_policy = {
        branch                 = "main"
        create_branch          = true
        protected_branches     = true
        custom_branch_policies = true
        enforce_admins         = true
        required_status_checks = {
          strict   = true
          contexts = ["build", "test"]
        }
        required_pull_request_reviews = {
          dismiss_stale_reviews           = true
          require_code_owner_reviews      = true
          required_approving_review_count = 2
        }
      }
      secrets = [
        {
          name  = "SECRET_KEY"
          value = "supersecretvalue"
        }
      ]
      vars = [
        {
          name  = "ENV_VAR"
          value = "production"
        }
      ]
    },
    {
      name = "staging"
      reviewers = {
        users = ["user3", "user4"]
        teams = ["team2"]
      }
      deployment_branch_policy = {
        branch                 = "develop"
        create_branch          = true
        protected_branches     = true
        custom_branch_policies = true
        enforce_admins         = true
        required_status_checks = {
          strict   = true
          contexts = ["build", "test"]
        }
        required_pull_request_reviews = {
          dismiss_stale_reviews           = true
          require_code_owner_reviews      = true
          required_approving_review_count = 1
        }
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

  state_config = {
    bucket         = "my-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-lock-table"
    set_backend    = true
  }

  runner_group = "self-hosted"
}
