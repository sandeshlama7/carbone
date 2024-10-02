module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.4"

  cluster_name = local.ecs.cluster_name
  depends_on   = [module.alb]
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
      enable_execute_command             = true
      wait_until_steady_state            = true
      wait_until_stable                  = true
      deployment_minimum_healthy_percent = 100
      desired_count                      = 1
      cpu                                = 1024
      memory                             = 2048
      network_mode                       = "awsvpc" #By default it is awsvpc

      container_definitions = {
        carbone-api = {
          essential                = true
          readonly_root_filesystem = false
          cpu                      = 1024
          memory                   = 2048
          image                    = "${local.ecr_uri}:latest"
          port_mappings = [
            {
              name          = "carbone-api"
              containerPort = 4000
              hostPort      = 4000
              protocol      = "tcp"
            }
          ]
          environment = [
            {
              "name" : "CARBONE_EE_STUDIO",
              "value" : true
            }
          ]
          mount_points = [
            {
              sourceVolume  = local.efs.name
              containerPath = "/app/template" #Path where EFS will be mounted inside the container
              readOnly      = false
            },
            {
              sourceVolume  = local.efs.name
              containerPath = "/app/render"
              readOnly      = false
            }
          ]
        }
      }

      volume = {
        (local.efs.name) = {
          efs_volume_configuration = {
            file_system_id     = module.efs.id
            root_directory     = "/"
            transit_encryption = "ENABLED"
            authorization_config = {
              access_point_id = module.efs.access_points.carbone.id
              iam             = "ENABLED"
            }
          }
        }
      }

      load_balancer = {
        service = {
          target_group_arn = module.alb.target_groups["carbone"].arn
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
