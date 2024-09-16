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

#   services = {
#     carbone-service = {
#         cpu = 512
#         memory = 1024

#         container_definitions = {
#             carbone-api = {
#                 cpu = 512
#                 memory = 1024
#                 image = carbone/carbone-ee
#                 port_mappings = [
#                     {
#                         name = "carbone-api"
#                         containerPort = 4000
#                         protocol = "tcp"
#                     }
#                 ]
#             }
#         }
#     }
#   }

}