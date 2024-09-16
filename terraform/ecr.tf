module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.0"

    repository_name = "private-example"

#   repository_read_write_access_arns = 
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 15 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 15
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
} 