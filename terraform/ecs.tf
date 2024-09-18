module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.4"

  cluster_name = local.ecs.cluster_name

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }

  }

  services = {
    carbone-service = {
      cpu    = 512
      memory = 1024

        container_definitions = {
          carbone-api = {
            readonly_root_filesystem = false
            cpu                      = 512
            memory                   = 1024
            image                    = "${module.ecr.repository_url}:latest"
            port_mappings = [
              {
                name          = "carbone-api"
                containerPort = 4000
                protocol      = "tcp"
              }
            ]
          }
        }
      load_balancer = {
        service = {
          target_group_arn = module.alb.target_group_arns[0]
          container_name   = "carbone-api"
          container_port   = 4000
        }
      }
      create_security_group = local.ecs.create_security_group
      subnet_ids            = local.private_subnets_id
      security_group_ids    = [module.ecs_sg.security_group_id]
      }
    }

}
