module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.4"

  depends_on   = [null_resource.image_push]
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
      desired_count = 1
      cpu           = 512
      memory        = 1024

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
          # Add mount points for the EFS volume
          mountPoints = [
            {
              sourceVolume  = "efs-volume"
              containerPath = "/mnt" #Path where EFS will be mounted inside the container
              readOnly      = false
            }
          ]
        }
      }

      volume = [
        {
          name = "efs-volume"
          efsVolumeConfiguration = {
            file_system_id     = module.efs.id
            root_directory     = "/"
            transit_encryption = "ENABLED"
            authorization_config = {
              access_point_id = module.efs.access_points.carbone.id
              iam             = "ENABLED"
            }
          }
        }
      ]

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
