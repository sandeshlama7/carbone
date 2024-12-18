module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.0"

  repository_name                 = local.ecr.repository_name
  repository_force_delete         = true
  repository_image_tag_mutability = "MUTABLE"

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

resource "null_resource" "image_push_ecr" {
  depends_on = [module.ecr]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
    aws ecr get-login-password --region ${local.region} | docker login --username AWS --password-stdin ${local.ecr_repo}
    docker pull carbone/carbone-ee
    docker tag carbone/carbone-ee ${module.ecr.repository_url}:latest
    docker push ${module.ecr.repository_url}:latest
    EOT

  }
}
